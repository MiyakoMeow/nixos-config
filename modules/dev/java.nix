{ pkgs, ... }:
let
  jdk = pkgs.jdk.override {
    enableJavaFX = true;
    openjfx_jdk = pkgs.openjfx.override {
      featureVersion = "21";
    };
  };
  gradle = pkgs.gradle.override {
    java = jdk;
  };
in
{
  # 安装软件包
  environment.systemPackages = with pkgs; [
    # Java 开发环境
    jdk
    # 项目构建工具
    maven
    gradle
    # JVM 性能分析工具 (可选)
    visualvm
  ];
}
