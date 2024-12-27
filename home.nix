{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "anthony";
  home.homeDirectory = "/Users/anthony";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
      
  home.packages = with pkgs; [];

  programs.git = {
    enable = true;
    userName = "chunaki7";
    userEmail = "25187609+chunaki7@users.noreply.github.com";
    ignores = [ ".DS_Store" ];
    extraConfig = {
      init.defaultBranch = "master";
    };
  };

  # programs.vscode = {
  #   enable = true;
  #   mutableExtensionsDir = false;

  #   userSettings = {
  #     "workbench.colorTheme" = "Tokyo Night";
  #   };

  #   extensions = with pkgs.vscode-marketplace; [
  #     enkia.tokyo-night
  #     # jnoortheen.nix-ide
  #   ];
  # };
}
