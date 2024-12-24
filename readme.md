Dan's Nix setup

1. Install nix[^1]
```bash
$ sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. Install home-manager using their standalone installation [^2]
```bash 
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager

nix-channel --update

nix-shell '<home-manager>' -A install
```



[^1]: https://nixos.org/download/
[^2]: https://nix-community.github.io/home-manager/#sec-install-standalone