{ config, pkgs, inputs, secrets, lib, ... }:
{
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-pc-laptop-hdd
    common-cpu-intel
    common-gpu-intel
  ] ++ [
    ./net.nix
  ];

  environment.sessionVariables.XDG_CURRENT_DESKTOP = "sway";
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  fileSystems."/home/dpd-/datos" = {
    device = "/dev/disk/by-uuid/42681448-3710-4f0b-9778-994a23c7f17e";
    fsType = "ext4";
    options = [ "noatime" ];
  };
  fileSystems."/".options = [ "compress=zstd" ];
  hardware.opentabletdriver.enable = true;
  time.timeZone = "Europe/Rome";
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [ ];
  };
  # TODO remove in favour of PereBook/system
  security.pam.services.swaylock = {
    text = "auth include login";
  };
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
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
      matches = [{ "device.name" = "~bluez_card.*"; }];
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
  networking.networkmanager.enable = true;
}
