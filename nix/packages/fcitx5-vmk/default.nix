{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  go,
  gcc,
  gettext,
  hicolor-icon-theme,
  fcitx5,
  libinput,
  xorg,
  udev,
}:
stdenv.mkDerivation rec {
  pname = "fcitx5-vmk";
  version = "0.9.3-alpha5";

  src = fetchFromGitHub {
    inherit version;
    owner = "nhktmdzhg";
    repo = "VMK";
    rev = "v${version}";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    go
    gcc
    gettext
    hicolor-icon-theme
  ];

  buildInputs = [
    fcitx5
    libinput
    xorg.libX11
    udev
  ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
  '';

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installFlags = ["DESTDIR=$(out)" "PREFIX="];

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/fcitx5-vmk-server@.service \
      --replace "/usr/bin/fcitx5-vmk-server" "$out/bin/fcitx5-vmk-server"
  '';

  meta = with lib; {
    description = "Fcitx5 VMK input method";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
