with import <nixpkgs>{};

let
  ruby = pkgs.ruby_2_3;
  # Install gems in bundler
  gems = bundlerEnv {
    name = "test";

    inherit ruby;
    gemdir = ./.;
  };

  # Install virtualenv, the rest is controlled in that virtualenv
  python-pkgs = python-packages: with python-packages; [
      virtualenv
  ];
  python-with-pkgs = python27.withPackages python-pkgs;

in

stdenv.mkDerivation rec {
  name = "test";
  version = "0.1.0";
  
  preInstall = ''
  unset GEM_PATH
  '';
  
  buildInputs = [
    # Ruby
    ruby_2_3
    bundler
    bundix
    libxslt libxml2 pkgconfig libffi libiconv openssl
    gems

    # Python
    python-with-pkgs

    # Terraform
    terraform-full

    # Tools
    wget
  ];
  
  # Create the virtualenv and install requirements
  shellHook = ''
    virtualenv venv --always-copy
    . venv/bin/activate
    pip install -r requirements.txt
  '';
}