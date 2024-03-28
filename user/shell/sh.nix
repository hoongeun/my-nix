{ pkgs, config, ... }:
let
  myAlias = {
    ls = "eza --icons -l -T -L=1";
    cat = "bat";
    fd = "fd -Lu";
    nixos-rebuild = "systemd-run --no-ask-password --uid=0 --system --scope -p MemoryLimit=16000M -p CPUQuota=60% nixos-rebuild";
    home-manager = "systemd-run --no-ask-password --uid=1000 --user --scope -p MemoryLimit=16000M -p CPUQuota=60% home-manager";
  };
  flavorsRepo = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "6394c3904ca6bd31ba1d600ef8e5488d7dfad374";
    sha256 = "f4jjJOQOxQz19M/oWk8QiuMoDysiae040K+P9qbLD5U=";
  };
in
{
  programs.fish = {
    enable = true;
    shellAliases = myAlias;
    shellInit = ''
      set -x NNN_FIFO '/tmp/nnn.fifo'
      function yy
        set tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          cd -- "$cwd"
        end
        rm -f -- "$tmp"
      end
    '';
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
        whitespace = {
          render = "all";
          characters = {
            nbsp = "⍽";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
        };
        insert-final-newline = true;
      };
    };
    defaultEditor = true;
    extraPackages = with pkgs; [
      clang-tools
      lldb
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

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    theme = {
      flavor = {
        use = "catppuccin-frappe";
      };
    };
  };

  home.file.".config/yazi/flavors".source = flavorsRepo;

  home.packages = with pkgs; [
    bat eza bottom fd
    gnugrep gnused
    direnv nix-direnv
    ripgrep
    fishPlugins.fzf-fish
    fzf
    fishPlugins.grc
    grc
    jq fd zoxide
  ];
}
