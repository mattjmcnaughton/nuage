{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.11;
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            tfswitch
            awscli2

            (vscode-with-extensions.override {
              vscode = vscodium;
              vscodeExtensions = with vscode-extensions; [
                hashicorp.terraform

                vscodevim.vim
              ];
            })
          ];

          shellHook = ''
            echo "Welcome to the dev env for nuage!"
          '';
        };
      });
}
