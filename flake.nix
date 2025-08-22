{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    {
      overlays.ckb-next = import ./overlay.nix;
      nixosModules = {
        ckb-next-overlay = import ./modules/ckb-next-overlay.nix;
        ckb-next = import ./modules/ckb-next.nix;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = builtins.attrValues self.overlays;
        };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        packages = {
          ckb-next = pkgs.ckb-next;
          ckb-next-experimental = pkgs.ckb-next-experimental;
          quazip = pkgs.quazip;
        };
      }
    );
}
