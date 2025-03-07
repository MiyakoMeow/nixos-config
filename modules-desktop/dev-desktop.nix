{
  pkgs,
  ...
}:
{
  imports = [
    ../modules/dev.nix
  ];

  environment.systemPackages = with pkgs; [
    neovide
    zed-editor

    # Antigravity
    antigravity
  ];
}
