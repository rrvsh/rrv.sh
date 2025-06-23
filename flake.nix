{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  outputs = inputs: {
    packages.x86_64-linux.default = ./default.nix;
  };
}
