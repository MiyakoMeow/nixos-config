{ pkgs, ... }:
{
  # Display and graphics packages
  environment.systemPackages = with pkgs; [
    # 显示
    mesa
    mesa-demos
    glew
    egl-wayland
    vulkan-tools
    vulkan-loader
    vulkan-headers
    vulkan-validation-layers
    vulkan-utility-libraries

    # Multi-Media
    ffmpeg-full
    flac
    vorbis-tools

    # Xorg modules for desktop
    xrandr
    libxrandr
    wlr-randr

    # System
    brightnessctl
    wl-gammactl
  ];
}
