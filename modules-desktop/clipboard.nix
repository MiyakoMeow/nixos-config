{ pkgs, ... }:
{
  # 剪贴板
  programs.gpaste.enable = true;

  # 剪贴板相关软件包
  environment.systemPackages = with pkgs; [
    # Clipboard
    wl-clipboard
    clipse
  ];
}
