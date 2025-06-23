{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.systems.url = "github:nix-systems/default-linux";
  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib legacyPackages;
      forEachSystem = lib.genAttrs (import inputs.systems);
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = legacyPackages.${system};
        in
        {
          default = pkgs.callPackage ./default.nix { };
        }
      );
    };
}
