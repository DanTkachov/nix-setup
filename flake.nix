{
    description="Dans Nix Configuration for quickly installing all packages";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        plasma-manager = {
            url = "github:nix-community/plasma-manager";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.home-manager.follows = "home-manager";
        };
        kde-panels-config = {
            url="github:DanTkachov/nix-setup/main?dir=configs/kde-panels.conf";
            flake = false;
        };
        lightly.url = "github:Bali10050/Darkly";
        zen-browser.url = "github:0xc000022070/zen-browser-flake";
    };

    outputs = {nixpkgs, home-manager, plasma-manager, kde-panels-config, lightly, zen-browser,...}:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs { 
            inherit system; 
            config.allowUnfree = true;
            };
    in{
        homeConfigurations.dan = home-manager.lib.homeManagerConfiguration{
            inherit pkgs;

            modules = [
                plasma-manager.homeManagerModules.plasma-manager
                ({config, lib, inputs, ...}:
                {
                    home.packages = with pkgs; [
                        # command line tools
                        tree 
                        cowsay
                        git
                        asciiquarium
                        fzf
                        yt-dlp
                        vim 
                        neovim
                        nano
                        ripgrep
                        jq
                        eza
                        which
                        gawk
                        gnupg
                        nix-output-monitor
                        iotop
                        alacritty
                        ventoy
                        neofetch

                        # networking
                        wireshark
                        nmap
                        iftop
                        ipcalc

                        # graphical applications 
                        arandr
                        chromium
                        firefox
                        gparted
                        vscodium
                        vlc
                        floorp
                        zen-browser.packages."${system}".beta
                        

                        # archives
                        zip
                        xz
                        unzip
                        p7zip
                        digikam

                        # creative
                        krita
                        audacity
                        
                        # other
                        virt-manager
                        ffmpeg
                        tldr
                        obs-studio
                        docker

                        # Known unfree modules
                        steam
                        obsidian
                        discord
                        mullvad-vpn
                        jetbrains-toolbox
                        anki
                    ];

                    # Plasma Configuration here:
                    # programs.plasma = {
                    #     enable = true;
                    #     workspace = {
                    #         theme = "breeze-dark";
                    #         colorScheme = "BreezeDark";
                    #         lookAndFeel = "org.kde.breezedark.desktop";
                    #         iconTheme = "breeze-dark";
                    #         cursor.theme = "Breeze";
                    #     };
                    # };

                    programs.alacritty = {
                        enable = true;
                    }
                    programs.git = {
                        enable = true;
                        userName = "Dan Tkachov";
                        userEmail = "danieltkachov67@gmail.com";
                        signing = {
                            signByDefault = false;
                            format = "ssh";  
                        };
                    };


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
                    programs.vscode = {
                        enable = true;
                        extensions = with pkgs.vscode-extensions; [
                            # Base Nix support
                            bbenoist.nix

                            # Python
                            ms-python.python
                            ms-python.vscode-pylance
                            ms-python.black-formatter

                            # Jupyter
                            ms-toolsai.jupyter
                            ms-toolsai.jupyter-keymap
                            ms-toolsai.vscode-jupyter-slideshow
                            ms-toolsai.vscode-jupyter-cell-tags
                            ms-toolsai.jupyter-renderers

                            # Misc
                            mechatroner.rainbow-csv
                            redhat.vscode-yaml
                        ];
                        package = pkgs.vscodium;
                    };

                    programs.direnv = {
                        enable = true;
                        nix-direnv.enable = true; # this is optional, see https://github.com/nix-community/nix-direnv
                        enableZshIntegration = true;
                    };

                    home.sessionVariables = {
                        # Enable desktop entries so that firefox/arandr/etc show up as desktop apps
                        XDG_DATA_DIRS = "${config.home.profileDirectory}/share:$HOME/.local/share:/usr/local/share:/usr/share";
                        # QT_QPA_PLATFORMTHEME = "qtct";
                    };

                    home = {
                        username = "dan";
                        homeDirectory = "/home/dan";
                        stateVersion = "25.05";

                    };

                    programs.home-manager.enable = true;
                }

                )

            ];
        };
    };
}