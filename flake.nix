{
    description = "NixOS module for the Ark dedicated server";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
        flake-utils.url = "github:numtide/flake-utils";
        steam-fetcher = {
            url = "github:aidalgol/nix-steam-fetcher";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        self,
        nixpkgs,
        flake-utils,
        steam-fetcher,
    }: 

    {
        nixosModules = rec {
            ark = import ./module.nix {inherit self steam-fetcher;};
            default = ark;
        };
        overlays.default = final: prev: {
            ark-server-unwrapped = final.callPackage ./ark-server {};
            ark-server = final.callPackage ./fhsenv.nix {};
        };
    };
}
