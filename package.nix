# @path: ~/projects/nixproj/derivations/input-overlay/sources.nix
# @anthor: redskaber
# @datetime: 2026-04-25
# @description: nix derivation build for obs-studio plguin input-overlay

{
  pkgs ? import <nixpkgs> { },
}:

let
  inherit (pkgs)
    stdenv
    lib
    fetchFromGitHub
    cmake
    pkg-config
    ninja
    obs-studio
    sdl3
    libx11
    libXau
    libXdmcp
    libXtst
    libXext
    libXi
    libXt
    libXinerama
    libxkbcommon
    libxkbfile
    ;

  inherit (pkgs.qt6) qtbase;

in
stdenv.mkDerivation rec {
  pname = "obs-input-overlay";
  version = "unstable-2026-03-23";

  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "input-overlay";
    rev = "0735d52e8e7845b8eb3da3d110e034fa3a7f9be5";
    hash = "sha256-cUULaOoV4fffEvsHkcG3lnFCIHSvnv3LHg+SDuuVLao=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    obs-studio
    qtbase
    sdl3

    libx11
    libXau
    libXdmcp
    libXtst
    libXext
    libXi
    libXt
    libXinerama
    libxkbcommon
    libxkbfile
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib/obs-plugins"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86 [
    "-DCMAKE_CXX_FLAGS=-msse4.1"
  ];

  postUnpack = ''
    sed -i '/set(CMAKE_CXX_FLAGS "-march=native")/d' source/CMakeLists.txt
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Show keyboard, gamepad and mouse input on stream";
    homepage = "https://github.com/univrsal/input-overlay";
    license = licenses.gpl2;
    platforms = obs-studio.meta.platforms;
    maintainers = with lib.maintainers; [ redskaber ];
  };
}
