# flake.nix

{
  description = "Public Key Encryption Demo with OpenSSL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    devShell.x86_64-linux =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in pkgs.mkShell {

        buildInputs = [
          pkgs.openssl
        ];

        shellHook = ''
          echo "Entering the development environment!"
          chmod +x public_key_encryption_script.sh
          bash public_key_encryption_script.sh
        '';
      };

    devShells = rec {
      default = self.devShell.x86_64-linux;
    };
  };

}
