{pkgs}:
pkgs.writeShellScriptBin "nlsp" ''
  tr '\r\n' ' ' < /dev/stdin
''
