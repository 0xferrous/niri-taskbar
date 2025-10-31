{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = with pkgs; mkShell {
          nativeBuildInputs = [
            pkg-config
            # (rust-bin.selectLatestNightlyWith
            #   (toolchain: toolchain.default))
          ];
          buildInputs = [
            openssl
            cairo
            gdk-pixbuf
            pango
            at-spi2-atk
            gtk3
          ];
        };

        packages.default = nixpkgs.legacyPackages.x86_64-linux.hello;
      }
    );
}
