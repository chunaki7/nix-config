{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.zsh.enable = true;
      
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Declare the user that will be running 'nix-darwin'.
      users.users.anthony = {
        name = "anthony";
        home = "/Users/anthony";
      };


      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [];
        brews = [];
        casks = [];
      };

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Anthonys-MacBook-Pro
    darwinConfigurations."Anthonys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 

        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.anthony = import ./home.nix;
        }

      ];
    };
  };
}
