{ pkgs, lib, ... }:
let
  systemLibs = with pkgs; [
    # 音频相关
    alsa-lib
    pulseaudio
    libpulseaudio
    jack2
    # 图形相关
    vulkan-loader
    libGL
    fontconfig
    freetype
    libxkbcommon
    harfbuzz
    pango
    cairo
    atk
    atkmm
    at-spi2-atk
    gdk-pixbuf
    gtk3
    webkitgtk_4_1
    libsoup_3
    librsvg
    libappindicator-gtk3
    xdotool
    # WebKitGTK 运行时依赖
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    libnotify
    libsecret
    adwaita-icon-theme
    # 网络相关
    openssl
    curl
    libssh2
    cyrus_sasl
    # 压缩相关
    zlib
    bzip2
    xz
    zstd
    # 图像处理
    libpng
    libjpeg_original
    libtiff
    libwebp
    # 加密相关
    libsodium
    gpgme
    # C++库
    glm
    opencv4
    # C++库：大号
    boost
    # 其他常用库
    expat
    icu
    pcre2
    sqlite
    glib
    dbus
    libffi
    gobject-introspection
    # X11相关
    libX11
    libXext
    libXrandr
    libXrender
    libXtst
    libXcursor
    libXi
    libXinerama
    libXft
    libXfixes
    libXcomposite
    libXdamage
    libXv
    libxcb
    # Wayland相关
    wayland
    wayland-protocols
    wlroots
    libdrm
    libinput
    xdg-desktop-portal
  ];

  devOutputs = map (pkg: if pkg ? dev then pkg.dev else pkg) systemLibs;
in
{
  environment.systemPackages =
    with pkgs;
    with pkgs.nur-miyakomeow;
    [
      # 开发常用工具
      file
      fd
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      eza # A modern replacement for 'ls'
      fzf # A command-line fuzzy finder
      sd

      # YAML
      yq-go # yaml processor https://github.com/mikefarah/yq
      yamlfmt
      yamlfix
      yamllint

      # TOML
      taplo # A fast TOML toolkit

      # Git
      lazygit
      gh

      # 网络工具
      curl
      wget

      # 数据库
      sqlite
      sqlitecpp
      sqlite_orm
      sqlite-web

      # 语言服务器
      tree-sitter
      bash-language-server
      yaml-language-server
      vscode-json-languageserver
      nufmt

      # AI Agent Cli
      opencode

      # AI工具插件
      rtk

      # 构建工具
      ninja
      meson
      cmake
      gnumake
      autoconf
      automake
      libtool

      # Rust需要
      pkg-config

      # Nix开发工具
      treefmt
      nix-update
      nix-prefetch-git
      nix-prefetch-scripts
      nix-index
      nix-init
      nix-search-cli
      statix
      deadnix

      # 仅编译工具（不在运行时路径中）
      vulkan-headers
      wayland-scanner
    ]
    ++ systemLibs;

  environment.sessionVariables = {
    PKG_CONFIG_PATH = map (pkg: "${pkg}/lib/pkgconfig") devOutputs;
    LD_LIBRARY_PATH = map (pkg: "${pkg}/lib") systemLibs;
    CPATH = map (pkg: "${pkg}/include") devOutputs;
    C_INCLUDE_PATH = map (pkg: "${pkg}/include") devOutputs;
    CPLUS_INCLUDE_PATH = map (pkg: "${pkg}/include") devOutputs;
    LIBRARY_PATH = map (pkg: "${pkg}/lib") systemLibs;
    CMAKE_PREFIX_PATH = systemLibs;
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
  };

  imports = [
    # Dev
    ./dev/rust.nix
    ./dev/c_cpp.nix
    ./dev/python.nix
    ./dev/java.nix
    ./dev/go.nix
    ./dev/javascript.nix
    ./dev/nix.nix
  ];
}
