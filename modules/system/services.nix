{ config, pkgs, lib, ... }:
{
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
}
