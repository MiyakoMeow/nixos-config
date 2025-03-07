{ pkgs, ... }:
{
  # XDG Portal
  xdg.portal.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # GVFS
  services.gvfs.enable = true;

  # Polkit
  security.polkit.enable = true;
  security.soteria.enable = true;

  # Enable keyring service (using package's built-in service file)
  services.gnome.gnome-keyring.enable = true;

  # GSettings configuration
  programs.dconf.enable = true;

  # Install GSettings schemas for desktop applications
  environment.systemPackages = with pkgs; [
    gsettings-desktop-schemas
  ];

  # Java GUI 程序可能需要字体配置
  fonts.fontDir.enable = true;
}
