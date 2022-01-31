{ inputs =
    { agenix.url = "github:ryantm/agenix";
      breeze.url = "github:ursi/breeze";
      brightness.url = "github:ursi/brightness";
      flake-make.url = "github:ursi/flake-make";

      hours =
        { flake = false;
          url = "github:Quelklef/hours";
        };

      im-home.url ="github:ursi/im-home";
      json-format.url = "github:ursi/json-format";
      localVim.url = "github:ursi/nix-local-vim";
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      nixpkgs-neovim.url = "github:NixOS/nixpkgs/9dea98679d45d22c85ff2fc5d190ebbe5b03d6bc";
      ssbm.url = "github:djanatyn/ssbm-nix";
      z.url = "github:ursi/z-nix";
    };

  outputs =
    { agenix
    , breeze
    , brightness
    , flake-make
    , hours
    , im-home
    , json-format
    , localVim
    , nixpkgs
    , nixpkgs-neovim
    , ssbm
    , utils
    , z
    , ...
    }:
    with builtins;
    let
      l = nixpkgs.lib; p = pkgs;
      system = "x86_64-linux";

      pkgs =
        import nixpkgs
          { inherit system;
            config = { allowUnfree = true; };

            overlays =
              [ (_: super:
                  { alacritty =
                      super.writeScriptBin "alacritty"
                        ''
                        if [[ "$@" = *--config-file* ]]; then
                          ${super.alacritty}/bin/alacritty "$@";
                        else
                          ${super.alacritty}/bin/alacritty \
                            --config-file ${../alacritty.yml} "$@";
                        fi
                        '';

                    hours = import hours { pkgs = super; inherit system; };
                    icons = { breeze = breeze.packages.${system}; };

                    flake-packages =
                      utils.defaultPackages system
                        { inherit agenix brightness flake-make json-format; };

                    inherit neovim;
                  }
                )

                ssbm.overlay
                z.overlay
              ];
          };

      neovim =
        import ./neovim
          { inherit (localVim) mkOverlayableNeovim;
            pkgs = nixpkgs-neovim.legacyPackages.${system};
          };

      make-app = pkg: exe:
        { type = "app";
          program = "${pkg}/bin/${exe}";
        };
    in
    { apps.${system} =
        { alacritty = p.alacritty;
          neovim = make-app neovim "nvim";
        };

      devShell.${system} =
        p.mkShell
          { shellHook =
              ''
              nixos-work-test() {
                sudo nixos-rebuild test \
                  && git restore flake.lock
              }

              nixos-work-switch() {
                sudo nixos-rebuild switch \
                  && git restore flake.lock
              }
              '';
          };

    nixosConfigurations =
        mapAttrs
          (_: modules:
             l.nixosSystem
               { inherit pkgs system;
                 modules =
                   [ { _module.args = { inherit nixpkgs; }; }
                     ./configuration.nix
                     agenix.nixosModules.age
                     ssbm.nixosModule
                     z.nixosModule
                   ]
                   ++ attrValues im-home.nixosModules
                   ++ modules;
               }
          )
          { desktop-2019 = [ ./desktop-2019 ];
            hp-envy = [ ./hp-envy ];
          };

      packages.${system} =
        { inherit (p) alacritty;
          inherit neovim;
        };
    };
}
