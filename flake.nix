{
  description = "Build PDF from a source file in Markdown";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      python = pkgs.python312;

      pandoc-mustache = python.pkgs.buildPythonApplication rec {
        pname = "pandoc-mustache";
        version = "0.1.0";
        format = "setuptools";

        src = python.pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-xGjRwhZ2zx+YJARaB4/l1OhFauy/LMosIjMQqoGnxrM=";
        };

        propagatedBuildInputs = with python.pkgs; [
          panflute
          pystache
          pyyaml
          future
        ];

        doCheck = false;
      };

      texlive = pkgs.texliveMedium.withPackages (packages: [
        packages.collection-langcyrillic
      ]);
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.gnumake
          pkgs.pandoc
          pandoc-mustache
          texlive
          pkgs.liberation_ttf
          pkgs.file
        ];

        shellHook = ''
          export OSFONTDIR='${pkgs.liberation_ttf}/share/fonts'
        '';
      };
    };
}
