{
  cmake,
  qt5,
  zlib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "quazip";
  version = "1.5";
  src = fetchFromGitHub {
    owner = "stachenov";
    repo = "quazip";
    tag = "v1.5";
    hash = "sha256-AOamvy2UgN8n7EZ8EidWkVzRICzEXMmvZsB18UwxIVo=";
  };
  buildInputs = [
    qt5.qtbase
  ];
  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    zlib
  ];
})
