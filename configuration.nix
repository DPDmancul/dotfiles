{ config, pkgs, args, lib, ... }:
let secrets = import ./secrets.nix;
in {
  security.pam.services.swaylock = {
    text = "auth include login";
  };
  boot.loader = {
    systemd-boot = {
      enable = true;
      # Remove old generation profiles to avoid
      # have a full boot partition
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.loader.timeout = 2;
  boot.tmpOnTmpfs = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };
  security.rtkit.enable = true;
  xdg.portal.wlr.enable = true;
  services.pipewire.media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [ { "device.name" = "~bluez_card.*"; } ];
      actions = {
        "update-props" = {
          "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          "bluez5.msbc-support" = true;
          "bluez5.sbc-xq-support" = true;
        };
      };
    }
    {
      matches = [
        # Matches all sources
        { "node.name" = "~bluez_input.*"; }
        # Matches all outputs
        { "node.name" = "~bluez_output.*"; }
      ];
      actions = {
        "node.pause-on-idle" = false;
      };
    }
  ];
  users.mutableUsers = false;
  users.users.dpd- = {
    isNormalUser = true;
    hashedPassword = secrets.dpd-.hashedPasswords;
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
      "networkmanager"
      "input"
      "video"
      #"kvm"
      "adbusers"
      "scanner"
      "lp"
    ];
  };
  services.dbus.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  environment.etc."dual-function-keys.yaml".text = ''
    MAPPINGS:
      - KEY: KEY_CAPSLOCK
        TAP: KEY_ESC
        HOLD: KEY_LEFTCTRL
      - KEY: KEY_RIGHTCTRL
        TAP: KEY_CAPSLOCK
        HOLD: KEY_RIGHTCTRL
  '';
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY:
              - KEY_CAPSLOCK
              - KEY_RIGHTCTRL
    '';
    };
  # services.clamav = {
  #   daemon.enable = true;
  #   updater.enable = true;
  # };
  programs.light.enable = true;
  programs.adb.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) (builtins.split "[ \n]" ''
    #<<<packages-unfree>>>
    brscan4
    brscan4-etc-files
    brother-udev-rule-type1
  '');

  environment.systemPackages = with pkgs; ([
    neovim
    bottom
    bat      # cat with syntax highlighting
    exa      # ls with colors and icosn
    tldr     # short command examples
    fd       # faster find
    ripgrep  # alternative grep
    usbutils
    pciutils
    xdg-utils
    wget
    git
    gnumake
    gcc
  ] ++ [
    #<<<packages-unfree>>>
  ]);
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      brlaser 
    ];
  };
  programs.system-config-printer.enable = true;
  hardware.printers = {
    ensureDefaultPrinter = "Brother";
    ensurePrinters = [{
      name = "Brother";
      location = "cjase";
      description = "Brother DCP 1612W";
      deviceUri = "ipp://192.168.1.4/ipp";
      model = "drv:///brlaser.drv/br1600.ppd";
      ppdOptions = {
        PageSize = "A4";
      };
    }];
  };
  hardware.sane.enable = true;
  hardware.sane.brscan4 = {
    enable = true;
    netDevices = {
      cjase = { model = "DCP-1612W"; ip = "192.168.1.4"; };
    };
  };
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.nixPath = [
    "nixpkgs=${args.nixpkgs.outPath}"
  ];
  imports = [ 
    (args.nixpkgs + "/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix")
    ./hardware-configuration.nix 
  ];

  fileSystems."/home/dpd-/datos" = { 
    device = "/dev/disk/by-uuid/42681448-3710-4f0b-9778-994a23c7f17e";
    fsType = "ext4";
  };
  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  systemd.enableEmergencyMode = false;
  hardware.opentabletdriver.enable = true;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  time.timeZone = "Europe/Rome";
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  boot.supportedFilesystems = [ "ntfs" ];
  nix.settings.auto-optimise-store = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [];
  };
  system.stateVersion = "21.11";
  i18n = {
    defaultLocale = "C.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8"; # ISO 8601
      LC_PAPER = "fur_IT";     # A4
      LC_MONETARY = "fur_IT";  # €
    };
  };
  # i18n.inputMethod.enabled = "fcitx5";
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking = {
    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;
    interfaces.wlp6s0.useDHCP = true;
  };
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
    kernelModules = [ "8821cu" ];
  };
  networking.enableIPv6 = false;
  services.openvpn.servers = {
    vpn  = {
      config = "config ${./it238.nordvpn.com.udp.ovpn}";
      updateResolvConf = true;
      authUserPass = secrets.vpn;
    };
  };
}
