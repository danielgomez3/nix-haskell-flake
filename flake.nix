{
  description = "danielgomez3's Haskell development flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";  # Nix Options version as well
  };
  outputs = inputs@{...}:
    let 
      currentSystem = builtins.currentSystem or "x86_64-linux";  # Fallback if not detected
      supportedSystems = {
        linux = "x86_64-linux";
        darwinIntel = "x86_64-darwin"; 
        darwinAmd = "aarch64-darwin"; 
        android = "aarch64-linux"; 
      };
      pkgs = inputs.nixpkgs.legacyPackages.${currentSystem};
    in 
    {
      devShells.${currentSystem}.default = pkgs.mkShell { 
        buildInputs = with pkgs; [
          ghc  # Much depends on this FIXME: maybe specify with language?
          pfetch cabal-install
          ghcid haskellPackages.reflex-ghci sourceHighlight  # Cool IDE features
        ];  # deps needed at runtime.
        GREETING = "Hello, Nix!";
        shellHook = ''
          ${pkgs.pfetch}/bin/pfetch
          echo $GREETING
        '';
      };

    };
}
