# My NixOS Config

## Apply

### 方式一：Flake 方式（推荐）

#### 1. 安装准备

```bash
nix-shell -p git
```

#### 2. 克隆仓库

```bash
sudo mv /etc/nixos /etc/nixos.bak
sudo git clone https://gitee.com/MiyakoMeow/nixos-config.git /etc/nixos
cd /etc/nixos
```

#### 3. 安装配置

**WSL2 环境：**
```bash
sudo nixos-rebuild --flake .#MiyakoMeowWSL switch \
  --option substituters 'https://mirrors.ustc.edu.cn/nix-channels/store' \
  --option extra-substituters 'https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://nix-community.cachix.org https://miyakomeow.cachix.org https://attic.xuyh0120.win/lantian https://cache.nixos.org' \
  --option extra-trusted-public-keys 'nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= miyakomeow.cachix.org-1:85k7pjjK1Voo+kMHJx8w3nT1rlBow3+4/M+LsAuMCRY= lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc='
```

**物理机/虚拟机环境：**
```bash
# 工作站
sudo nixos-rebuild --flake .#MiyakoMeowWorkStatNixOS switch \
  --option substituters 'https://mirrors.ustc.edu.cn/nix-channels/store' \
  --option extra-substituters 'https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://nix-community.cachix.org https://miyakomeow.cachix.org https://cache.nixos.org' \
  --option extra-trusted-public-keys 'nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= miyakomeow.cachix.org-1:85k7pjjK1Voo+kMHJx8w3nT1rlBow3+4/M+LsAuMCRY='

# 笔记本
sudo nixos-rebuild --flake .#MiyakoMeowMateBookNixOS switch \
  --option substituters 'https://mirrors.ustc.edu.cn/nix-channels/store' \
  --option extra-substituters 'https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://nix-community.cachix.org https://miyakomeow.cachix.org https://cache.nixos.org' \
  --option extra-trusted-public-keys 'nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= miyakomeow.cachix.org-1:85k7pjjK1Voo+kMHJx8w3nT1rlBow3+4/M+LsAuMCRY='
```

### 方式二：传统无 Flake 方式

#### 1. 安装准备

```bash
nix-shell -p git
```

#### 2. 克隆仓库

```bash
sudo mv /etc/nixos /etc/nixos.bak
sudo git clone https://gitee.com/MiyakoMeow/nixos-config.git /etc/nixos
cd /etc/nixos
```

#### 3. 创建基础配置文件

复制基础配置并调整：
```bash
cp minimal-configuration.nix configuration.nix
```

#### 4. 编辑配置文件

根据您的环境编辑 `configuration.nix`：

**物理机环境：**
- 确保 `fileSystems` 配置正确
- 确保 `boot.loader.grub.devices` 配置正确

**WSL2 环境：**
- 可以跳过文件系统配置（使用默认）

#### 5. 安装配置

**WSL2 环境：**
```bash
sudo nixos-install --root / --option extra-substituters "https://mirrors.ustc.edu.cn/nix-channels/store"
```

**物理机/虚拟机环境：**
- 如果已有 NixOS 系统，可以直接重建：
```bash
sudo nixos-rebuild switch --option extra-substituters "https://mirrors.ustc.edu.cn/nix-channels/store https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
```
- 如果是全新安装，需要先配置引导：
```bash
sudo nixos-install --option extra-substituters "https://mirrors.ustc.edu.cn/nix-channels/store https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
```

## Notes

