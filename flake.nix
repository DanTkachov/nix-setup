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
            url="github:DanTkachov:nix-setup/configs/kde-panels.conf";
            flake = false;
        };
    };

    outputs = {nixpkgs, home-manager, plasma-manager, kde-panels-config, ...}:
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
                ({config, ...}:
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

                        # archives
                        zip
                        xz
                        unzip
                        p7zip
                        
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
                    ];

                    # Plasma Configuration here:
                    programs.plasma = {
                        enable = true;
                        workspace = {
                            theme = "breeze-dark";
                            colorScheme = "BreezeDark";
                            lookAndFeel = "org.kde.breezedark.desktop";
                            iconTheme = "breeze-dark";
                            cursor.theme = "Breeze_Light";
                        };
                        # panels = [
                        #     {
                        #         location = "left";
                        #         height = 44; # in px, the thickness of the panel
                        #         floating = false;
                        #         alignment = "center";
                        #         minLength = 1000;
                        #         maxLength = 1600;
                        #         screen = 0;
                        #         widgets = [
                        #             "org.kde.plasma.kickoff" # Application Launcher
                        #             "org.kde.plasma.systemtray"  # System tray
                        #         ];
                        #         hiding = "none";
                        #         lengthMode = "fill";
                        #     }
                        # ];

                        startup.desktopScript."panels" = {
                            text = ''
                                cp ${kde-panels-config} $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc
                             '';
                             priority = 2;
                        };
                    };

                    programs.git = {
                        enable = true;
                        userName = "Dan Tkachov";
                        userEmail = "danieltkachov67@gmail.com";
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

                    # Enable desktop entries so that firefox/arandr/etc show up as desktop apps
                    home.sessionVariables = {
                        XDG_DATA_DIRS = "${config.home.profileDirectory}/share:$HOME/.local/share:/usr/local/share:/usr/share";
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