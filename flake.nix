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
        system = "x86_64-linux";
        pkgs = import nixpkgs { 
            inherit system; 
            config.allowUnfree = true;
            };
    in{
        homeConfigurations.dan = home-manager.lib.homeManagerConfiguration{
            inherit pkgs;

            modules = [{
                config, ...
            }:
                {
                    home.packages = with pkgs; [
                        tree 
                        cowsay
                        git
                        asciiquarium
                        fzf
                        arandr
                        chromium
                        firefox
                        gparted
                        yt-dlp
                        vscodium
                    ];


                    # Add VSCodium config to automatically tap into microsoft extensions
                    xdg.configFile."VSCodium/product.json".text = ''
                        {
                            "extensionsGallery": {
                            "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
                            "itemUrl": "https://marketplace.visualstudio.com/items",
                            "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
                            "controlUrl": ""
                            }
                        }
                        '';

                    # Enable desktop entries so that firefox/arandr/etc show up as desktop apps
                    targets.genericLinux.enable = true;
                    xdg = {
                        enable = true;
                        mime.enable = true;
                        systemDirs.data = [ "${config.home.profileDirectory}/share" ];
                    };

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