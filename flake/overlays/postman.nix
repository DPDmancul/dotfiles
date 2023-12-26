self: super: {
  postman = super.postman.overrideAttrs (old:
    let
      version = "10.21.0";
    in
    {
      inherit version;
      src = super.fetchurl {
        url = "https://dl.pstmn.io/download/version/${version}/linux64";
        name = "${old.pname}-${version}.tar.gz";
        sha256 = "SCaNZli29M+qEXYku8zwCob6EAdtg6eVl19opSWqypE=";
      };
    }
  );
}

