{pkgs}: let
  name = "nlsp";
in
  pkgs.writeShellScriptBin name ''
    tr '\r\n' ' ' < /dev/stdin
  ''
