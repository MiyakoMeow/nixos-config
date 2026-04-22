{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Webui
    metacubexd
    # 代理应用
    tunctl
  ];

  # Mihomo代理设置
  services.mihomo = {
    tunMode = true;
    enable = true;
    webui = pkgs.metacubexd;
    configFile = ./proxy-mihomo/mihomo.yaml;
  };

  # 内核模块：提供tun能力
  boot.kernelModules = [ "tun" ];
}
