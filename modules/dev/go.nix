{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Go 语言工具链
    go # 默认安装最新稳定版
    gopls # Go 官方语言服务器（VSCode 插件依赖）
    delve # Go 调试工具
    go-tools # 静态分析工具集（golint 等）
  ];

  # 环境变量配置
  environment.variables = {
    # 启用 Go Modules 并配置国内镜像（阿里云或七牛云）
    GO111MODULE = "on";
    GOPROXY = "https://goproxy.cn";
    # 可选：自定义工作区路径（默认 ~/go）
    #GOPATH = "$HOME/go";
  };

  # 可选：为 Go 工具链添加二进制路径
  #environment.variables.PATH = [
  #  "$GOPATH/bin"
  #];
}
