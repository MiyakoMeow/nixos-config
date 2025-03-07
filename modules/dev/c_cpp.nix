{
  pkgs,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    with pkgs.nur-miyakomeow;
    [
      # GNU 编译工具链
      gcc
      binutils # 二进制工具集
      gnumake # Make 工具
      gdb

      # Clang
      clang
      clang-tools
      lldb # LLVM 调试器
      llvm # LLVM 核心库
      libllvm
    ];
}
