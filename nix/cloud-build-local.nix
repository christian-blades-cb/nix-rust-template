{ stdenv, fetchurl, autoPatchelfHook }:

let
  baseUrl = "https://storage.googleapis.com/local-builder";
  sources = system: {
    x86_64-darwin = {
      url = "${baseUrl}/cloud-build-local_darwin_amd64-v0.5.0";
      sha256 = "cdc5f59232c0591059719551cf7bb44a3cb0e0273842e11c3cc41975a79440e2";
    };

    x86_64-linux = {
      url = "${baseUrl}/cloud-build-local_linux_amd64-v0.5.0";
      sha256 = "4c84e19f973236fbad580f0ec06d3e1e41a2e881da946bd3d9ca55d478f5c94e";
    };
  }.${system};
in stdenv.mkDerivation rec {
  pname = "cloud-build-local";
  version = "0.5.0";

  src = fetchurl (sources stdenv.hostPlatform.system);

  dontConfigure = true;
  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = ''
    install -m755 -D ${src.out} $out/bin/cloud-build-local
  '';

  meta = with stdenv.lib; {
    description = "local cloudbuild";
    longDescription = ''
      Local Builder runs Google Cloud Build builds locally, allowing faster debugging, less vendor lock-in, and integration into local build and test workflows.
    '';
    homepage = https://github.com/GoogleCloudPlatform/cloud-build-local;
    license = licenses.gpl3Plus;
    maintainers = [ "Christian Blades <blades@mailchimp.com>" ];
    platforms = platforms.all;
  };
}
