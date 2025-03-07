{
  pkgs,
  username,
  ...
}:
{
  # ================ 硬件配置 ================
  # 启用 AMDGPU 内核模块
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [
    "amdgpu"
    "kfd"
  ];

  # 内核参数调整 (针对 Polaris 架构)
  boot.kernelParams = [
    "amdgpu.sg_display=0" # 禁用安全显示
    "radeon.si_support=0" # 强制使用 amdgpu 驱动
    "amdgpu.cik_support=1"
    "amdgpu.dc=1" # 显示核心支持
  ];

  # ================ 图形支持 ================
  hardware.graphics = {
    enable32Bit = true; # For 32 bit applications
  };

  # 视频播放加速
  environment.systemPackages = with pkgs; [
    libva
    libva-vdpau-driver
    libvdpau-va-gl

    # 监测工具
    radeontop
  ];

  # ================ 计算支持 ================
  hardware.amdgpu.opencl = {
    enable = true;
  };

  # ================ 用户权限 ================
  users.users.${username} = {
    extraGroups = [
      "video"
      "render"
      "kvm"
    ];
  };
}
