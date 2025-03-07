{ lib, config, ... }:
let
  rootPath = /etc/..;

  # ---------------------------------------------
  # 1. 手动追加的证书文件（Path 类型）
  # ---------------------------------------------
  manualCerts = [
    ./cert-files/mycert.crt
  ];

  # ---------------------------------------------
  # 2. 自动扫描的目录（保持不变）
  # ---------------------------------------------
  certDirs = [
    (rootPath + "/mnt/c/CA")
    (rootPath + "/mnt/d/CA")
    (rootPath + "/etc/nixos/extra-certs")
  ];

  getCertsFromDir =
    dir:
    if !builtins.pathExists dir then
      [ ]
    else
      let
        tryRead = builtins.tryEval (builtins.readDir dir);
      in
      if !tryRead.success then
        [ ]
      else
        let
          files = builtins.attrNames tryRead.value;
          crtFiles = builtins.filter (f: builtins.match ".*\\.crt$" f != null) files;
        in
        map (f: dir + "/${f}") crtFiles;

  autoCerts = builtins.concatLists (map getCertsFromDir certDirs);

  # ---------------------------------------------
  # 3. 合并结果（自动 + 手动）
  # ---------------------------------------------
  allCerts = autoCerts ++ manualCerts;
in
{
  security.pki.certificateFiles = builtins.trace "已加载证书文件列表: ${builtins.toString allCerts}" allCerts;
}
