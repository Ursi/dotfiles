with builtins;
{ lib, nixpkgs, pkgs, ... }:
  let l = lib; p = pkgs; in
  { imports =
      [ ./alacritty.nix
        ./git.nix
        ./package-alias.nix
        ./secrets/agenix.nix
      ];

    environment =
      { pkgs-with-aliases =
          with pkgs;
          [ { pkg = chez;
              aliases.scheme = "scheme ${./prelude.ss}";
            }

            (let hours-alias = "hours -j ~/.hours"; in
             { pkg = hours;

               aliases =
                 { hours = hours-alias;

                   hours-stop =
                     "hours show | tail -n 2 && hours session stop && hours show";

                   hours-undo = "hours eventlog undo && hours show";
                 };

               functions.hours-start =
                 ''${hours-alias} session start -t "$1" && ${hours-alias} show'';
             }
            )

            { pkg = j;
              aliases.j = "jconsole";
            }

            { pkg = jq;
              functions.jql = ''jq -C "$1" "$2" | less -r'';
            }

            { pkg = nodePackages.http-server;
              aliases.http-server = "http-server -c-1";
            }

            { pkg = trash-cli;
              aliases.trash = "trash-put";
            }

            { pkg = xclip;

              aliases =
                { xclipc = "xclip -selection clipboard";
                  xclipng = "xclip -t image/png -selection clipboard";
                };
            }
          ];

        shellAliases =
          { cal = "cal -m";
            fui = "nix flake lock --update-input";
            nix-use = "nix-env -if nix.nix";
            nix-remove = "nix-env -e nix";
            nixbuild = "nix build -f .";
            nixpkgs-unstable = ''echo $(nix eval --impure --raw --expr '(fetchGit { url = "https://github.com/NixOS/nixpkgs"; ref = "nixpkgs-unstable"; }).rev')'';

            nixrepl =
              let
                file = p.writeText "" "{ p }: { l = p.lib; inherit p; } // builtins";
              in
              ''nix repl --arg p '(builtins.getFlake "${./.}").inputs.nixpkgs.legacyPackages.x86_64-linux' ${file}'';

            nixshell = "nix develop -f shell.nix";
          };

        systemPackages =
          with pkgs;
          let
            no-windows =
              [ file
                git
                graphviz
                hexedit
                imagemagick
                ix
                ncdu
                neofetch
                neovim
                nix-du
                ntfs3g
                pciutils
                tmate
                unzip
                usbutils
                wally-cli
                w3m
              ];

            windows =
              [ audacity
                brave
                discord
                gimp
                gnome3.nautilus # for seeing images
                gparted
                mattermost-desktop
                pavucontrol
                peek
                qbittorrent
                qemu
                spectacle
                torbrowser
                vlc
                wxcam
                zulip
              ];
          in
          flake-packages
          ++ no-windows
          ++ (import ./shell-scripts.nix pkgs)
          ++ windows;


        variables =
          rec
          { EDITOR = VISUAL;
            VISUAL = "nvim";
          };
      };

    fonts.fonts = [ (p.nerdfonts.override {fonts = [ "Cousine" ]; }) ];
    gaming.enable = l.mkDefault true;

    hardware =
      { keyboard.zsa.enable = true;
        pulseaudio.enable = true;
      };

    networking =
      { firewall.enable = false;
        networkmanager.enable = true;
        # wireless.enable = true; # Enables wireless support via wpa_supplicant.

        # The global useDHCP flag is deprecated, therefore explicitly set to false here.
        # Per-interface useDHCP will be mandatory in the future, so this generated config
        # replicates the default behaviour.
        useDHCP = false;
      };

    nix =
      { extraOptions = "experimental-features = nix-command flakes";
        registry.nixpkgs.flake = nixpkgs;
        settings.trusted-users = [ "mason" "root" ];
      };

    programs =
      { alacritty.enable = true;
        dconf.enable = true;
        nm-applet.enable = true;

        xss-lock =
          { enable = true;
            lockerCommand = "${p.i3lock}/bin/i3lock -fc 440000";
          };

        z =
          { enable = true;
            cmd = "a";
          };
      };

    services =
      { picom =
          { enable = true;
            vSync = true;
          };

        xserver =
          { enable = true;

            # Disable mouse acceleration
            libinput =
              { enable = true;

                mouse =
                  l.mkDefault
                    { accelProfile = "flat";
                      accelSpeed = "0";
                    };
              };

            windowManager.i3.enable = true;
          };
      };

    sound.enable = true;

    ssbm =
      { cache.enable = true;

        gcc =
          { oc-kmod.enable = true;
            rules.enable = true;
          };
      };

    time.timeZone = "America/Toronto";

    users =
      { mutableUsers = false;

        users =
          { mason =
              { createHome = true;
                description = "Mason Mackaman";
                extraGroups = [ "networkmanager" "plugdev" "wheel" ];

                i3 =
                  { font =
                      { font = "pango:sans";
                        size = l.mkDefault 17;
                      };

                    extra-config = readFile ../i3/config;
                  };

                icons.cursor = p.icons.breeze.cursors.breeze;
                isNormalUser = true;
                password = "";
                links.path."/.bashrc" = ../.bashrc;
              };

            root =
              { extraGroups = [ "root" ];
                password = "";
              };
          };
      };
  }
