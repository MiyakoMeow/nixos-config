{ pkgs, ... }:
{
  imports = [
    # Graphics
    ../modules-desktop/graphics.nix
    # Fonts
    ../modules-desktop/fonts.nix
    # Software
    ../modules-desktop/software.nix
    # Game
    ../modules-desktop/game.nix
    # Fcitx5
    ../modules-desktop/fcitx5.nix
    # Base Desktop
    ../modules-desktop/base-desktop.nix
    # Wayland
    ../modules-desktop/wayland.nix
    # Clipboard
    ../modules-desktop/clipboard.nix
    # Qt
    ../modules-desktop/qt.nix
  ];

  # Niri
  programs.niri = {
    enable = true;
  };

  # DankMaterialShell
  programs.dms-shell = {
    enable = true;

    systemd = {
      enable = true; # Systemd service for auto-start
    };

    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
  };

  # Use DankMaterialShell's polkit, avoid conflict with niri-flake-polkit
  systemd.user.services.niri-flake-polkit.enable = false;

  environment.systemPackages = with pkgs; [
    # For my config
    waybar
    fuzzel
    vesktop
    kitty
    alacritty
    fastfetch
  ];
}
