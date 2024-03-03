{ pkgs, ... };

{
  home.packages = with pkgs; [
    rsync
    zellij
    unzip
    fzf
    pandoc
    lazygit
    gdu
    presenterm
  ]
}
