{
  description = "NixOS flake config. @MiyakoMeow";

  # The nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    # Override the default substituters
    substituters = [
      # Cache mirror located in China
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"

      # nix community's cache server
      "https://nix-community.cachix.org"

      "https://miyakomeow.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

      # MiyakoMeow's cache server public key
      "miyakomeow.cachix.org-1:85k7pjjK1Voo+kMHJx8w3nT1rlBow3+4/M+LsAuMCRY="

      # cache.nixos.org public key
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-unstable 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # NUR: https://nur.nix-community.org
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-miyakomeow = {
      url = "github:MiyakoMeow/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NixOS WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-wsl,
      ...
    }@inputs:
    let
      # Expose all systems
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      # 仅为主流架构生成格式化工具
      mainSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      formatterForMainSystems = nixpkgs.lib.genAttrs mainSystems (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );

      mkSystem =
        {
          system,
          hostname,
          username,
          modules,
          extraModules ? [ ],
          extraArgs ? { },
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              hostname
              username
              ;
          }
          // extraArgs;
          modules = [
            (
              { ... }:
              {
                imports = [
                  ./global.nix
                ];

                config = {
                  system.stateVersion = "25.11";
                  networking.hostName = "${hostname}";
                };
              }
            )
          ]
          ++ modules
          ++ extraModules;
        };
    in
    {
      # Set formatter for this config
      formatter = formatterForMainSystems;
      # Set nixosConfigurations for all systems
      nixosConfigurations = {
        MiyakoMeowWorkStatNixOS = mkSystem {
          system = "x86_64-linux";
          hostname = "MiyakoMeowWorkStatNixOS";
          username = "miyakomeow";
          modules = [
            ./hosts/work_station/configuration.nix
          ];
          # extraModules = [ ... ]; # 可选，添加特有模块
          # extraArgs = { ... };    # 可选，传递特有参数
        };
        MiyakoMeowWSL = mkSystem {
          system = "x86_64-linux";
          hostname = "MiyakoMeowWSL";
          username = "miyakomeow";
          modules = [
            nixos-wsl.nixosModules.wsl
            ./hosts/wsl/configuration.nix
          ];
          # extraModules = [ ... ]; # 可选，添加特有模块
          extraArgs = { }; # 可选，传递特有参数
        };
        MiyakoMeowMateBookNixOS = mkSystem {
          system = "x86_64-linux";
          hostname = "MiyakoMeowMateBookNixOS";
          username = "miyakomeow";
          modules = [
            ./hosts/mate_book/configuration.nix
          ];
          # extraModules = [ ... ]; # 可选，添加特有模块
          # extraArgs = { ... };    # 可选，传递特有参数
        };
      };
    };
}
