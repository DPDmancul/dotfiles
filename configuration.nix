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
  i18n = {
    defaultLocale = "C.UTF-8";
    extraLocaleSettings = {
      LC_PAPER = "it_IT.UTF-8";
    };
  };
  # i18n.inputMethod.enabled = "fcitx5";
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
  boot.kernelModules = [ "8821cu" ];
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
  services.dbus.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.printing.enable = true;
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
  users.mutableUsers = false;
  users.users.dpd- = {
    isNormalUser = true;
    hashedPassword = secrets.dpd-.hashedPasswords;
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
      "networkmanager"
      "input"
      "video"
      "kvm" # qemu
      "adbusers" # adb
    ];
  };
  environment.systemPackages = with pkgs; [
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
  ];
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.nixPath = [
    "nixpkgs=${args.nixpkgs.outPath}"
  ];
  imports = [ ./hardware-configuration.nix ];

  fileSystems."/home/dpd-/datos" = { 
    device = "/dev/disk/by-uuid/42681448-3710-4f0b-9778-994a23c7f17e";
    fsType = "ext4";
  };
  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  systemd.enableEmergencyMode = false;
  hardware.opentabletdriver.enable = true;
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
}
