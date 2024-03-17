{ pkgs, ... }
let
  myAlaias = {
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
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAlias = myAlias;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAlias = myAlias;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "material-darker"
      editor = {
        line-number = "relative";
        true-color = true;
        lsp.display-messages = true;
      }
    };
    defaultEditor = true;
    extraPackages = with pkgs; [
      clangd 
      gopls 
      jdtls 
      typescript-language-server 
      vscode-json-language-server 
      kotlin-language-server 
      marksman 
      nil 
      bufls 
      pylsp 
      rust-analyzer 
      vscode-css-language-server 
      svelteserver 
      wgsl_analyzer 
    ];
  };

  home.packages = with pkgs; [
    helix
    bat eza bottom fd 
    gnugrep gnused
    direnv nix-direnv
    ripgrep
  ];
}
