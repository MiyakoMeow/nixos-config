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
    # AMDGPU
    ../../modules-physical/amdgpu.nix
    # ACPI - 电源管理
    ../../modules-physical/acpi.nix
    # Desktop Environment - Niri
    ./../../profile/niri.nix
    # 开发环境模块
    ../../modules-desktop/dev-desktop.nix
    # RustDesk
    ../../modules-desktop/rustdesk.nix
    # MateBook 音频配置
    ../../modules-desktop/audio-matebook.nix
  ];

  # Use Linux Zen
  boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;

  # Extra Grub Config
  boot.loader = {
    grub = {
      # Default to NixOS
      default = 0;
      # Screen Resolution (adjust for MateBook display)
      gfxmodeEfi = "1920x1080";
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

  # 设备类型 - 笔记本
  deviceType = "laptop";

  # MateBook 特定的 ACPI 配置优化
  services.tlp.settings = {
    # 键盘背光控制
    # KEYBOARD_BACKLIGHT_BRIGHTNESS_ON_AC = 100;
    # KEYBOARD_BACKLIGHT_BRIGHTNESS_ON_BAT = 50;
  };
}
