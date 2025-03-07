{ pkgs, ... }:
{
  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Wayland 相关软件包
  environment.systemPackages = with pkgs; [
    # XWayland support
    xwayland-satellite

    # Engine libraries
    glib
    gsettings-qt
    gtkmm3
  ];
}
