{
  pkgs,
  ...
}:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
    inputMethod = {
      enable = true;
      type = "fcitx5";

      enableGtk2 = true;
      enableGtk3 = true;

      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          (fcitx5-rime.override {
            rimeDataPkgs = [
              rime-ice
              rime-moegirl
              rime-zhwiki
            ];
          })
          fcitx5-gtk # Fcitx5 gtk im module and glib based dbus client library
          fcitx5-material-color
        ];
        #ignoreUserConfig = true; #启用不光个人设置无效，个人词库也会无法保存
        # User configuration is managed by dotfiles (~/.config/fcitx5/)
      };
    };
  };

  # Environment variables for fcitx5 on Wayland (niri/wlroots)
  # Based on: https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
  #
  # System: niri 25.11 (wlroots 0.19.3) + Qt 6.10.2
  # Supports: text-input-v3 ✅
  environment.sessionVariables = {
    # X11 input method (for XWayland apps)
    XMODIFIERS = "@im=fcitx";

    # Qt 6.8.2+ input method - use text-input-v3 first, fallback to fcitx
    QT_IM_MODULES = "wayland;fcitx";

    # SDL2 applications (XWayland or native)
    SDL_IM_MODULE = "fcitx";

    # GLFW applications (for some games)
    GLFW_IM_MODULE = "ibus";

    # Electron/Chromium - use Wayland with IME support
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # Note: fcitx5 is started by niri/window manager, not systemd
}
