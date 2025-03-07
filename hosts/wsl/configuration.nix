{
  hostname,
  username,
  ...
}:
{
  # 主要区别就是这个 wsl 模块
  wsl = {
    enable = true;
    defaultUser = "${username}";
    # 创建软件的桌面快捷方式
    startMenuLaunchers = true;
  };

  imports = [
    # 证书
    ../../modules/certificate.nix
    # 开发环境
    ../../modules/dev.nix
    ../../modules/docker.nix
  ];
}
