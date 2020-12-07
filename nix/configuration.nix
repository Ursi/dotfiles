# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-WDC_WD10EZEX-08M2NA0_WD-WCC3FE0JTJMX"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  fonts.fonts = with pkgs; [ (nerdfonts.override {fonts = [ "Cousine" ]; }) ];

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      brave
      git
      (neovim.override { withNodeJs = true; })
      ntfs3g
      parted
      pavucontrol
      spectacle
      trash-cli
      unzip
      xclip
      xfce.xfce4-terminal
      w3m
    ];

    variables = { EDITOR = "nvim"; };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  programs.nm-applet.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    picom = {
      backend = "glx";
      enable = true;
      vSync = true;
    };

    udev.extraRules = ''
      # Teensy rules for the Ergodox EZ
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

      #GameCube Controller Adapter
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", TAG+="uaccess"

      #Mayflash DolphinBar
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", TAG+="uaccess"
    '';

    xserver = {
      enable = true;

      # Disable mouse acceleration
      libinput = {
        enable = true;
        accelProfile = "flat";
        accelSpeed = "0";
      };

      windowManager.i3.enable = true;
    };
  };

  users = {
    mutableUsers = false;

    users = {
      mason = {
        createHome = true;
        description = "Mason Mackaman";
        extraGroups = [ "networkmanager" "wheel" ];
        isNormalUser = true;

        packages = with pkgs;
          let
            communication = [
              discord
              mattermost-desktop
              signal-desktop
              zulip
            ];

            editor =
              let
                elm = with elmPackages; [
                  elm-language-server
                  elm-format
                ];

                node = with nodePackages; [
                  purty
                  purescript-language-server
                ];
              in
                elm ++ node;
          in
            [
              brightness
              gnome3.nautilus # for seeing images
              go-sct
              niv
              nodePackages.node2nix
              wally-cli
            ]
              ++ communication
              ++ editor;

        password = "";
      };

      root = {
        extraGroups = [ "root" ];
        password = "";
      };
    };
  };

  nixpkgs = rec {
    # pkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/<commit>.tar.gz") { inherit config; };
    config.allowUnfree = true;
  };


  system = {
    autoUpgrade.enable = true;

    # don't change - man configuration.nix
    stateVersion = "20.03"; # Did you read the comment?
  };
}