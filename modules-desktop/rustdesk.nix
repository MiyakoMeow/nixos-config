{ pkgs, hostname, ... }:
{
  services.rustdesk-server = {
    enable = true;
    relay.enable = true;
    signal = {
      enable = true;
      relayHosts = [ "${hostname}.local" ];
    };
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    rustdesk
  ];
}
