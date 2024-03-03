{ pkgs, ... }:

{
  home.packages = with pkgs; [
      # Python setup
      nodejs
  ];
}
