{ pkgs, ... }:
{
  imports = [
    # Proxy
    ../modules-physical/proxy-clash-verge.nix
  ];

  # Use the Grub EFI boot loader.
  boot.loader = {
    grub =
      let
        themePackage = pkgs.nur-miyakomeow.grub-themes.star-rail.hyacine_cn;
      in
      {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
        # do not need to keep too much generations
        configurationLimit = 50;
        # Theme
        theme = themePackage;
        splashImage = "${themePackage}/background.png";
      };
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot/efi";
    };
  };

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Use systemd-resolved because of hosts management.
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        fallbackDns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };
  };

  hardware.bluetooth.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # 启用 nix-ld 兼容层（可选，用于运行动态链接的二进制文件）
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # 硬件
    fastfetch
    hwinfo
  ];

  # 启用固件
  hardware.enableRedistributableFirmware = true;
}
