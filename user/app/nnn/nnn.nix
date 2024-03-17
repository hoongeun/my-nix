{ config, pkgs, userSettings, ... }:

{
  programs.nnn = {
    enable = true;
    extraPackages = with pkgs; [
      tree
      glow
      poppler
    ];
    plugins = {
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v4.9";
        sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
      }) + "/plugins";
      mappings = {
        "c" = "fzcd";
        "f" = "finder";
        "p" = "preview-tui";
        "d" = "diffs";
        "t" = "nmount";
        "v" = "imgview";
      };
    };
  };
}
