{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  vulkan-loader,
  ninja,
  writeText,
  vulkan-headers,
  vulkan-utility-libraries,
  libX11,
  libXrandr,
  libxcb,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "vulkan-hdr-layer";
  version = "0-unstable-2025-02-13";

  src = fetchFromGitHub {
    owner = "Zamundaaa";
    repo = "VK_hdr_layer";
    rev = "1f13469feb0704bcf56b64fd6ec3793e5087d895";
    fetchSubmodules = true;
    hash = "sha256-5WfkIATcwecr+ioI4GfQQ34G0jWLctZ4oBlSFqw6UE8=";
  };

  nativeBuildInputs = [
    vulkan-headers
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    vulkan-utility-libraries
    libX11
    libXrandr
    libxcb
    wayland
  ];

  # Help vulkan-loader find the validation layers
  setupHook = writeText "setup-hook" ''
    addToSearchPath XDG_DATA_DIRS @out@/share
  '';

  meta = with lib; {
    description = "Layers providing Vulkan HDR";
    homepage = "https://github.com/Zamundaaa/VK_hdr_layer";
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
