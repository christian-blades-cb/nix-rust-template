{ fetchurl, pkgs, stdenv }:
let
  baseUrl = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads";
  version = "334.0.0";
  sources = name: system: {
    x86_64-darwin = {
      url = "${baseUrl}/${name}-darwin-x86_64.tar.gz";
      sha256 = "33700393698a6127682931b498f79c4c7d69ab786ff7872cb67bc0947f6d4f33";
    };

    aarch64-darwin = {
      url = "${baseUrl}/${name}-darwin-arm.tar.gz";
      sha256 = "322a5bb60300c1a2b81b6b63fe0fda13ba49487a312ab01965ecd531a573cb7a";
    };

    x86_64-linux = {
      url = "${baseUrl}/${name}-linux-x86_64.tar.gz";
      sha256 = "8ba026255d73e8b11b8a9b6a4e7f72cbe8b08952df2739d78d6d003666a39d3d";
    };
  }.${system};
in
pkgs.google-cloud-sdk.overrideAttrs (oldAttrs: rec {
  inherit version;
  src = fetchurl (sources "${oldAttrs.pname}-${version}" stdenv.hostPlatform.system);
})
