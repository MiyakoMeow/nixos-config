{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Rust
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt
    # Cargo插件
    cargo-llvm-cov
    cargo-udeps
    cargo-deny
    cargo-binutils
    cargo-tauri
    cargo-audit
  ];
}
