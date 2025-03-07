{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Node.js 环境 (包含 npm)
    nodejs
    # 包管理
    pnpm
    yarn
    bun
    deno
    # 语言服务器
    vscode-langservers-extracted
    typescript-language-server
    # 前端框架语言服务器
    eslint
    prettier
    vue-language-server
    svelte-language-server
    angular-language-server
    tailwindcss_4
    tailwindcss-language-server
  ];
}
