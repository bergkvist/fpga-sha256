{ pkgs ? import (fetchTarball {
    name = "nixpkgs-23.05";
    url = "https://github.com/NixOS/nixpkgs/archive/9a74ffb2ca1fc91c6ccc48bd3f8cbc1501bf7b8a.tar.gz";
    sha256 = "sha256:0r2gnb5yqdw0wz691gjyxzaakhky3z9lhdlxncm43kil19fsrjx2";
  }) {}
}:
pkgs.mkShell {
  buildInputs = [
    pkgs.verilog
    pkgs.entr
  ];
}
