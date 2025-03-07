{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Language Server
    nil
    nixd

    # Formatter
    nixfmt
    nixpkgs-fmt
    alejandra
  ];
}
