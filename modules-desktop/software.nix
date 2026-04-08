{ pkgs, ... }:
{
  # Install extra part
  environment.systemPackages =
    with pkgs;
    with pkgs.nur-miyakomeow;
    [
      # 加密工具
      #bitwarden-desktop
      bitwarden-cli
      bitwarden-directory-connector
      bitwarden-directory-connector-cli
      seahorse

      # Audio & Volume
      alsa-utils

      # File manager
      thunar
      thunar-volman
      thunar-dropbox-plugin
      thunar-vcs-plugin
      thunar-archive-plugin
      thunar-media-tags-plugin
      xarchiver

      # Video player
      vlc
      vlc-bittorrent

      # Others
      rain-bittorrent
      p7zip-rar

      # OBS CLI
      obs-cli

      # Wine
      wineWow64Packages.waylandFull
      wineWow64Packages.fonts
      #wineasio
      winetricks
      vkd3d-proton
      dxvk

      # 一些常用软件
      chatbox
      chromium
      qq
      yutto # Bilibili downloader
      biliup-rs # CLI tool for uploading videos to Bilibili
      netease-cloud-music-gtk
      splayer
      wpsoffice-cn
      baidupcs-go

      # 常用软件（需要代理）
      bilibili
      xunlei-uos
      wechat-uos
      discord

      # VPN
      #clash-verge-rev

      # 常用软件（暂时不可用）
      #wechat
      #wechat-uos
      free-download-manager
    ];

  # FireFox
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    languagePacks = [
      "en-US"
      "zh-CN"
      "ja"
      "ko"
    ];
  };

  environment.sessionVariables.MOZ_DISABLE_CONTENT_SANDBOX = "1";

  # Steam
  programs.steam = {
    enable = true;
    extest.enable = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };

  # OBS Studio
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      input-overlay
      obs-gstreamer
      obs-vaapi
    ];
  };
}
