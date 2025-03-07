{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # 代理应用
    tunctl
  ];

  # 内核模块：提供tun能力
  boot.kernelModules = [ "tun" ];

  # 其他代理
  networking.proxy = {
    # Use proxy in clash-verge
    # default = "127.0.0.1:7897";
  };
}
