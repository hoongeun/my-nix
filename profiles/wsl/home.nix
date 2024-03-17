{ config, pkgs, pkgs-stable, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  programs.home-manager.enable = true;

  imports = [
              ../../user/shell/sh.nix
              ../../user/shell/useful-cli.nix
              ../../user/app/git/git.nix
              ../../user/app/nnn/nnn.nix
              ../../user/lang/cc/cc.nix
              ../../user/lang/go/go.nix
              ../../user/lang/java/java.nix
              ../../user/lang/js/js.nix
              ../../user/lang/kotlin/kotlin.nix
              ../../user/lang/python/python.nix
              ../../user/lang/rust/rust.nix
            ];

  home.stateVersion = "23.11";

  home.packages = [
    # Office
    pkgs-stable.libreoffice-fresh

    # Various dev packages
    pkgs-stable.texinfo
    pkgs-stable.libffi
    pkgs-stable.zlib
  ];

  services.syncthing.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    EDITOR = userSettings.editor;
  };
}
