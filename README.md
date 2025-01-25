# nix-config

# Install the  [Nix Package Manager](https://nixos.org/download/)
```
sh <(curl -L https://nixos.org/nix/install)
```


# Create a Directory for Nix Darwin.

Using Flakes. Create a directory for your Nix configuration.

```
mkdir -p ~/.config/nix
cd ~/.config
```

Clone the repo into the directory that you've just created.
```
git clone git@github.com:chunaki7/nix-config.git nix
```

Set the hostname in the `flake.nix` file using the below:
```
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
```

# Install your Nix configuration

```
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix
```
## Updating your configuration
```
nixswitch
```
> If you set a different location for your Nix configuration, you'll need to update the directory name in the shell alias for `nixswitch`
# Upgrading packages
```
nix flake update
```

```
nixswitch
```

# References
[Nix Darwin](https://github.com/LnL7/nix-darwin)

[Nix Documentation](https://nix.dev)