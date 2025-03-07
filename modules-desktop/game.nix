{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    with pkgs.nur-miyakomeow;
    [
      beatoraja
      lampghost
      pbmsc
      mbmplay
      mbmconfig
      hmcl
    ];
}
