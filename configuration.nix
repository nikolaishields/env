{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      displayManager.autoLogin.enable = true;
      displayManager.autoLogin.user = "nshields";
      layout = "us";
      xkbVariant = "";
    };

    nscd.enable = true;
    printing.enable = true;
  };

  programs.zsh.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
    pki.certificates = [ (builtins.readFile ./ssl/dwauth2-2019a.crt) (builtins.readFile ./ssl/dwca-2018a.crt)];
  };

  users.users.nshields = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Nikolai Shields";
    extraGroups = [ "docker" "networkmanager" "wheel" "podman" ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.networkmanager-openconnect
    nss
    sssd
    nsss
    vim
    git
    curl
    wget
    wl-clipboard
    unscd
    glibc
    glib
    openconnect
  ];

  virtualisation = {
    docker = { enable = true; };
    podman = {
      enable = true;
      dockerCompat = false;
      autoPrune.enable = true;
    };
    containers = {
      registries.search = [ "artifactory.dwavesys.local" ];
    };
  };

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
