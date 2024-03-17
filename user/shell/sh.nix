{ pkgs, ... }:
let
  myAlias = {
    ls = "eza --icons -l -T -L=1";
    cat = "bat";
    fd = "fd -Lu";
    nixos-rebuild = "systemd-run --no-ask-password --uid=0 --system --scope -p MemoryLimit=16000M -p CPUQuota=60% nixos-rebuild";
    home-manager = "systemd-run --no-ask-password --uid=1000 --user --scope -p MemoryLimit=16000M -p CPUQuota=60% home-manager";
  };
in
{
  programs.fish = {
    enable = true;
    shellAliases = myAlias;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAlias;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "material_darker";
      editor = {
        line-number = "relative";
        true-color = true;
        lsp.display-messages = true;
      };
    };
    defaultEditor = true;
    extraPackages = with pkgs; [
      clang-tools
      gopls
      jdt-language-server
      nodePackages.typescript-language-server
      nodePackages_latest.vscode-json-languageserver
      kotlin-language-server
      marksman
      nil
      buf-language-server
      python311Packages.pylsp-rope
      rust-analyzer
      nodePackages_latest.vscode-css-languageserver-bin
      nodePackages_latest.svelte-language-server
    ];
  };

  home.packages = with pkgs; [
    bat eza bottom fd
    gnugrep gnused
    direnv nix-direnv
    ripgrep
    fishPlugins.fzf-fish
    fzf
    fishPlugins.grc
    grc
  ];
}
