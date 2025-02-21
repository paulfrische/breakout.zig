{
  pkgs,
  lib,
  ...
}: let
  libs = with pkgs; [
    llvmPackages.libclang

    libGL
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama

    alsa-lib
    libpulseaudio
  ];
in {
  packages = with pkgs;
    [
      cmake
      pkg-config
      clang
    ]
    ++ libs;

  env.LD_LIBRARY_PATH = lib.makeLibraryPath libs;
  env.LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
}
