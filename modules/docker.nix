{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    dockerfile-language-server
  ];
}
