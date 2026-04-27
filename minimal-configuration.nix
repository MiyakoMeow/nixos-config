{
  lib,
  pkgs,
  ...
}:
let
  baseProxyUrl = "https://get.2sb.org/";
  isWSL =
    if builtins.pathExists "/mnt/wsl" then
      builtins.trace "[NixOS-WSL] 检测到 /mnt/wsl 路径，WSL 配置已启用。" true
    else
      builtins.trace "[NixOS-WSL] 未检测到 /mnt/wsl 路径，WSL 配置未启用。" false;
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  nixosWSLTarball = fetchTarball {
    url =
      baseProxyUrl
      + "https://github.com/nix-community/NixOS-WSL/archive/${lock.nodes.nixos-wsl.locked.rev}.tar.gz";
    sha256 = lock.nodes.nixos-wsl.locked.narHash;
  };
  nixosWSL =
    (import ./helpers/flake-compat.nix {
      src = nixosWSLTarball;
      baseProxyUrl = baseProxyUrl;
    }).defaultNix;
in
{
  imports =
    (lib.optionals isWSL [
      nixosWSL.nixosModules.default
      ({
        config = (
          lib.mkIf isWSL {
            wsl = {
              enable = true;
            };
          }
        );
      })
    ])
    ++ [
      # 证书
      ./modules/certificate.nix
    ];

  # 仅在非WSL下配置 fileSystems 和 grub
  fileSystems = lib.mkIf (!isWSL) {
    "/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
  };
  boot.loader.grub.devices = lib.mkIf (!isWSL) [ "/dev/sda" ];

  nix.settings = let
    subs = (builtins.fromTOML (builtins.readFile ./substituters.toml)).substituters;
  in {
    substituters = map (s: s.url) subs;
    trusted-public-keys = map (s: s.public-key) (builtins.filter (s: s ? public-key) subs);
    # Use Flake & Nix Commands
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    tmux
    zsh
    fish
    nushell
    starship
    tldr
    chezmoi
  ];

  programs.git = {
    enable = true;
  };

  environment.variables = {
    # Use Neovim as default editor
    EDITOR = "nvim";
  };
}
