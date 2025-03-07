{ pkgs, lib, ... }:
{
  # Qt
  qt.enable = true;

  # Qt 环境变量配置
  environment.sessionVariables = {
    #QT_PLUGIN_PATH = ["${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}"]; # Defined by fcitx
    QML2_IMPORT_PATH = [ "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtQmlPrefix}" ];
    QT_QPA_PLATFORM_PLUGIN_PATH = [
      "${pkgs.qt6.qtbase}/lib/qt-${pkgs.qt6.qtbase.version}/plugins/platforms"
    ];
  };
}
