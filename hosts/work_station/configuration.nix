# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  username,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # 物理机模块
    ../../profile/physical.nix
    # Cuda
    ../../modules-physical/cuda.nix
    # ACPI - 电源管理
    ../../modules-physical/acpi.nix
    # Desktop Environment - Niri
    ./../../profile/niri.nix
    # 开发环境模块
    ../../modules-desktop/dev-desktop.nix
    # RustDesk
    ../../modules-desktop/rustdesk.nix
    # 音频配置
    ../../modules-desktop/audio.nix
  ];

  # Use Linux Zen
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Extra Grub Config
  boot.loader = {
    grub = {
      # select windows by default
      default = 2;
      # Screen Resolution
      gfxmodeEfi = "2560x1440";
    };
  };

  # Display Manager
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "niri";
    autoLogin = {
      enable = true;
      user = "${username}";
    };
  };

  # 设备类型 - 台式机
  deviceType = "desktop";

  # 工作站特定的电源管理配置
  # 使用 power-profiles-daemon 和 auto-cpufreq 进行电源管理
  # 配置在 modules/acpi.nix 中统一管理
}
