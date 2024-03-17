{
  description = "A very basic flake";

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, home-manager, rust-overlay }:
  let
    systemSettings = {
      system = "x86_64-linux";
      hostname = "hoongeun";
      profile = "wsl";
      timezone = "Asia/Seoul";
      locale = "en_US.UTF-8";
    };

    userSettings = rec {
      username = "hoongeun";
      name = "Hoongeun";
      email = "me@hoongeun.com";
      dotfileDirs = "~/.dotfiles";
      editor = "hx";
    };

    pkgs = import nixpkgs {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
      overlays = [ rust-overlay.overlays.default ];
    };

    pkgs-stable = import nixpkgs-stable {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
        overlays = [ rust-overlay.overlays.default ];
      };
    };

    lib = nixpkgs.lib;

    supportedSystems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];

    forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

    nixpkgsFor = forAllSystems (system:
      import inputs.nixpkgs { inherit system; });

  in
  {
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ (./. + "/profiles"+("/"+systemSettings.profile)+"/home.nix") ];
        extraSpecialArgs = {
          inherit pkgs;
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };

    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        modules = [ (./. + "/profiles"+("/"+systemSettings.profile)+"/configuration.nix") ];
        specialArgs = {
          inherit pkgs;
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };

    packages = forAllSystems (system:
      let pkgs = nixpkgsFor.${system}; in
      {
        defualt = self.pakcages.${system}.install;

        install = pkgs.writeScriptBin "install" ./install.sh;
      });

    apps = forAllSystems (system: {
      default = self.apps.${system}.install;

      install = {
        type = "app";
        program = "${self.packages.${system}.install}/bin/install";
      };
    });
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
  };
}
