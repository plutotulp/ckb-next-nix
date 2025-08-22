{
  gnused,
  cmake,
  pkgconf,
  udev,
  pulseaudio,
  qt5,
  quazip,
  zlib,
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ckb-next";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    tag = "v0.6.2";
    hash = "sha256-lA1FpUee2SpUQwJotbYhG0QX7LT5l2PP9lJ9F3uNtdU=";
  };

  buildInputs = [
    qt5.qtbase
    qt5.qtx11extras
    qt5.qtwayland

    # FIXME: not sure where qt5 linguist comes from, so just using
    # full for now.
    qt5.full
  ];

  nativeBuildInputs = [
    cmake
    gnused
    pkgconf
    pulseaudio
    qt5.wrapQtAppsHook
    quazip
    udev
    zlib
  ];

  cmakeFlags = [
    (lib.strings.cmakeOptionType "LIST" "FORCE_INIT_SYSTEM" "systemd")
    (lib.strings.cmakeBool "USE_XCB" false)
    (lib.strings.cmakeBool "USE_DBUS_MENU" false)
    (lib.strings.cmakeOptionType "STRING" "SYSTEMD_UNIT_INSTALL_DIR" "lib/systemd/system")
    (lib.strings.cmakeOptionType "STRING" "UDEV_RULE_DIRECTORY" "etc/udev/rules.d")
  ];

  postFixup = ''
    sed -i 's:/usr/bin/env sed :${lib.getExe gnused} :g' $out/etc/udev/rules.d/*
  '';
})
