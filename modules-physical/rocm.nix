{
  pkgs,
  username,
  ...
}:
{
  # ================ ROCm 组件 ================
  hardware.graphics = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  environment.systemPackages = with pkgs; [
    # ROCm 核心组件
    rocmPackages.rocm-core
    rocmPackages.rocm-device-libs

    # 开发工具链
    rocmPackages.hipblas
    rocmPackages.hipcc
    rocmPackages.hipfft
    rocmPackages.hipfort
    rocmPackages.rocblas
    rocmPackages.rocsolver

    # 诊断工具
    rocmPackages.rocminfo
    clinfo
  ];

  # ================ 环境变量 ================
  environment.variables = {
    # 强制指定架构
    HSA_OVERRIDE_GFX_VERSION = "8.0.3";
    ROC_ENABLE_PRE_VEGA = "1";

    # OpenCL 配置
    #OCL_ICD_VENDORS = "${pkgs.rocm-opencl-icd}/etc/OpenCL/vendors";
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # ================ 验证命令 ================
  environment.shellAliases = {
    check-rocm = "rocminfo | grep -E 'Agent|Marketing'";
    test-opencl = "clinfo | grep 'Device Name'";
  };
}
