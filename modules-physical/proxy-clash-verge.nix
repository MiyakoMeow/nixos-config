{ ... }:
{
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    # Mode
    serviceMode = true;
    tunMode = true;
  };

  environment.systemPackages = with pkgs; [
    # 代理应用
    tunctl
  ];

  # 内核模块：提供tun能力
  boot.kernelModules = [ "tun" ];
}
