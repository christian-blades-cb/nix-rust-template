{ source ? import ./nix/sources.nix,
  nixpkgs-mozilla ? import source.nixpkgs-mozilla,
  rust-src-overlay ? import "${source.nixpkgs-mozilla}/rust-src-overlay.nix",
  pkgs ? import source.nixpkgs { overlays = [ nixpkgs-mozilla rust-src-overlay ]; },
}:
let
  # rust version is pinned by the `rust-toolchain` file in the root of the repo
  rust' = (pkgs.rustChannelOf { rustToolchain = ./rust-toolchain; }).rust;
  # myPackages = p: with p; [ ipython numpy werkzeug ];
  # myPython = pkgs.python36.withPackages myPackages;
  cloud-build-local = pkgs.callPackage ./nix/cloud-build-local.nix { };
  gcloud = pkgs.callPackage ./nix/google-cloud-sdk.nix { };
in pkgs.mkShell {
  buildInputs = [
    # pkgs.upx
    rust'
    pkgs.rustracer
    pkgs.latest.rustChannels.stable.rustfmt-preview
    pkgs.llvmPackages.clang-unwrapped
    ####################
    # python packaging #
    ####################
    # pkgs.libiconv
    # myPython
    # pkgs.maturin
    ##################
    # wasm packaging #
    ##################
    # pkgs.cmake
    # pkgs.openssl
    # pkgs.python3
    # pkgs.wasm-pack
    # pkgs.wabt
    # pkgs.nodejs
    # pkgs.wasm-pack
    # nodeModules.webpack
    # nodeModules.webpack-cli
    #####################
    # optional niceties #
    #####################
    # pkgs.curl
    # cloud-build-local
    # gcloud
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.darwin.apple_sdk.frameworks.IOKit
    pkgs.darwin.apple_sdk.frameworks.Security
    pkgs.darwin.apple_sdk.frameworks.CoreServices
  ];
}
