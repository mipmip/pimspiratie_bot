with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "crystal";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    #THIS IS ESSENTIAL TO MAKE CRYSTAL WORK
    cryptsetup
    openssl_3_0

    crystal
    shards
  ];
}



