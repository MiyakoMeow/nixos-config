{ pkgs, ... }:
{
  imports = [
    ./proxy.nix
  ];

  environment.systemPackages = with pkgs; [
    # Webui
    metacubexd
  ];

  # Mihomo代理设置
  services.mihomo = {
    tunMode = true;
    enable = true;
    webui = pkgs.metacubexd;
    configFile = ./proxy/mihomo.yaml;
  };
}
