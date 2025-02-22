{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-vscode-extensions, mac-app-util }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ ];

      nix.enable = false;
      
      nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];

      # Allow non-free software to be installed
      nixpkgs.config.allowUnfree = true;

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

      # Use TouchID for sudo
      security.pam.enableSudoTouchIdAuth = true;

      # MacOS Docker auto-hide
      system.defaults.dock.autohide = true;

      # MacOS hide desktop items
      system.defaults.WindowManager.StandardHideDesktopIcons = true;

      # MacOS show recent apps on dock
      system.defaults.dock.show-recents = false;

      # MacOS change speed of showing/hiding dock
      system.defaults.dock.autohide-time-modifier = 0.2;

      # MacOS change dock autohide delay
      system.defaults.dock.autohide-delay = 0.0;

      # MacOS show icons on desktop (Finder)
      system.defaults.finder.CreateDesktop = false;

      # MacOS Default window in Finder
      system.defaults.finder.NewWindowTarget = "Home";

      # MacOS Show path in Finder
      system.defaults.finder.ShowPathbar = true;

      # MacOS show CD/DVD etc.. on Desktop
      system.defaults.finder.ShowRemovableMediaOnDesktop = false;

      # MacOS show prompt when changing file extensions
      system.defaults.finder.FXEnableExtensionChangeWarning = false;

      # MacOS Delay until Key Repeat (120, 94, 68, 35, 25, 15)
      system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;

      # MacOS Key repeat rate (120, 90, 60, 30, 12, 6, 2)
      system.defaults.NSGlobalDomain.KeyRepeat = 2;

      # MacOS enable tap to click ?
      system.defaults.NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
      
      # Don't know if these even work?
      system.defaults.screensaver.askForPassword = true;
      system.defaults.screensaver.askForPasswordDelay = 0;

      system.defaults.CustomUserPreferences = {

        # Safari Preferences
        "com.apple.Safari" = {
          ShowFullURLInSmartSearchField = true;
          ShowFavoritesBar = false;
          AutoFillFromAddressBook = false;
          AutoFillCreditCardData = false;
          AutoFillMiscellaneousForms = false;
          AutoFillPasswords = false;
          WarnAboutFraudulentWebsites = true;
        };

        # Don't create DS_Store files on network shares
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
        };

      };

      # Declare the user that will be running 'nix-darwin'.
      users.users.anthony = {
        name = "anthony";
        home = "/Users/anthony";
      };


      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;

        taps = [];
        brews = [];
        casks = [
          "visual-studio-code"
          "ghostty"
          "discord"
          "spotify"
          "tailscale"
          "notion"
          "anki"
          "protonvpn"
          "alt-tab"
          "docker"
          "rectangle"
          "microsoft-office-businesspro"
          "firefox"
          "vlc"
          "brave-browser"
        ];

        masApps = {
          "WindowsApp" = 1295203466;
          "Kindle" = 302584613;
          "XCodeGUI" = 497799835;
        };

      };

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Anthonys-MacBook-Pro
    darwinConfigurations."Anthonys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 

        mac-app-util.darwinModules.default

        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.anthony = import ./home.nix;

          home-manager.sharedModules = [ mac-app-util.homeManagerModules.default ];
        }

      ];
    };
  };
}
