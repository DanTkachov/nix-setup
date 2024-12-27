{
    description="Dans Nix Configuration for quickly installing all packages";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        ghostty = {
            url = "github:ghostty-org/ghostty";
        };
    };

    outputs = {nixpkgs, home-manager, ghostty, ...}:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs { 
            inherit system; 
            config.allowUnfree = true;
            };
    in{
        homeConfigurations.dan = home-manager.lib.homeManagerConfiguration{
            inherit pkgs;
            extraSpecialArgs = { inherit ghostty; };

            modules = [
                {
                    home.packages = with pkgs; [
                        tree 
                        cowsay
                        git
                        (ghostty.packages.${system}.default)

                    ];

                    home = {
                        username = "dan";
                        homeDirectory = "/home/dan";
                        stateVersion = "25.05";

                    };

                    programs.home-manager.enable = true;
                }



            ];
        };
    };
}