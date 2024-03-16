{ lib, pkgs, systemSettings, userSettings, ... }:

with lib;
let
  nixos-wsl = import ( fetchGit {
     url = "https://github.com/nix-community/NixOS-WSL";
     rev = "34eda458bd3f6bad856a99860184d775bc1dd588"; # 23.11
  });
in
{
  imports = [
    nixos-wsl.nixosModules.wsl
    ../../system/hardware/kernel.nix
    ../../system/hardware/systemd.nix
    ../../system/hardware/time.nix
    ../../system/hardware/opengl.nix
    ../../system/hardware/printing.nix
    ../../system/hardware/bluetooth.nix
    ../../system/security/automount.nix
    ../../system/security/doas.nix
    ../../system/security/gpg.nix
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = userSettings.username;
    startMenuLaunchers = true;
    # docker-native.enable = true;
    # docker-desktop.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;

  boot.kernelModules = [ "i2c-dev" "i2c-piix4" "cpufreq_powersave" ];

  networking.hostName = systemSettings.hostname;

  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    uid = 1000;
  };

  environment.systemPackages = with pkgs; [
    hx
    wget
    curl
    fish
    git
    home-manager
  ];

  environment.shells = with pkgs; [ fish ];
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  system.stateVersion = "23.11";
}
