{
    description="Dans Nix Configuration for quickly installing all packages";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {nixpkgs, home-manager, ...}:
    let
        system = builtins.currentSystem;
        pkgs = nixpkgs.legacyPackages.${system};
    in{
        homeConfigurations.dan = home-manager.lib.homeManagerConfiguration{
            inherit pkgs;

            modules = [
                {
                    home.packages = with pkgs; [
                        tree
                        cowsay
                        

                    ];

                    home = {
                        username = "dan";
                        homeDirectory = "/home/dan";
                        stateVersion = "24.11";

                    };

                    programs.home-manager.enable = true;
                }
            ];
        };
    };
}