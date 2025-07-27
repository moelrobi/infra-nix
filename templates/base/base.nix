{
  config,
  pkgs,
  modulesPath,
  lib,
  system,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  networking.fqdn = lib.mkDefault "base.uwu.tools";

  boot.growPartition = true;

  services.qemuGuest.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["nodev"];

  nix.settings.trusted-users = ["root" "@wheel"];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
    jq
    tmux
    unzip
  ];

  sops.age.keyFile = "/etc/sops/age/keys.txt";

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;

  time.timeZone = "Europe/Berlin";

  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = ["noatime"];
    autoResize = true;
  };

  system.stateVersion = "25.05";
}
