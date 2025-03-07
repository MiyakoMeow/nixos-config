{
  pkgs,
  inputs,
  username,
  ...
}:
{
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  # system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://miyakomeow.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "miyakomeow.cachix.org-1:85k7pjjK1Voo+kMHJx8w3nT1rlBow3+4/M+LsAuMCRY="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    # Use Flake & Nix Commands
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Optimise storage
  # you can also optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  #nix.settings.auto-optimise-store = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    password = "123456"; # Default password
  };

  # 设置所有用户的默认登录 Shell 为 NuShell
  users.defaultUserShell = pkgs.nushell;

  # git 相关配置
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # GNUPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Neovim (System, no config)
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  # Starship prompt
  programs.starship = {
    enable = true;
  };

  # nixpkgs设置
  nixpkgs = {
    config = {
      # 可选：允许非自由软件
      allowUnfree = true;
    };
    overlays = [
      # NUR
      inputs.nur.overlays.default
      # MiyakoMeow's NUR Repo
      (final: prev: {
        nur-miyakomeow = import inputs.nur-miyakomeow {
          # 关键点：使用当前系统的配置，使上述config能够生效
          pkgs = prev;
        };
      })
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    with pkgs.nur-miyakomeow;
    [
      # Disk manager
      unixtools.fdisk
      gptfdisk
      parted

      # Nushell
      nushell

      # 其他构建工具
      cmake
      meson
      xmake

      # Age加密工具
      age

      # File System
      tree

      # Terminal tools
      zellij
      lf
      nnn
      yazi

      # Terminal shell wrapper
      starship

      # HWInfo
      fastfetch
      hwinfo

      btop # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb

      # Config Management
      chezmoi

      # Editor
      helix

      zip
      xz
      unzip
      p7zip
      unrar
      mtr
      iperf3
      dnsutils
      ldns
      aria2
      socat
      nmap
      ipcalc
      cowsay
      file
      which
      gnused
      gnutar
      gawk
      zstd
      nix-output-monitor
      hugo
      glow
    ];

  environment.variables = {
    # Use Neovim as default editor
    EDITOR = "nvim";
  };

  # Direnv for devShell
  programs.direnv = {
    enable = true;
  };

  imports = [
    ./modules/certificate.nix
    # Dev
    ./modules/dev.nix
    ./modules/docker.nix
  ];
}
