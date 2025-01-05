Dan's Nix setup

Run the quick install:
```bash
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/DanTkachov/nix-setup/main/quick-setup.sh)"
```

1. Install nix[^1]
```bash
$ sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. Install home-manager using their standalone installation [^2]
```bash 
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update

nix-shell '<home-manager>' -A install
```

3. Enable flakes on your new system if not already enabled
` echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf` 

4. Switch over to the flake:
```bash
home-manager switch --flake github:dantkachov/nix-setup --no-write-lock-file --refresh
```

5. Rebuild KDE cache if using KDE for desktop icons:
```bash
kbuildsycoca6 --noincremental
```

[^1]: https://nixos.org/download/
[^2]: https://nix-community.github.io/home-manager/#sec-install-standalone