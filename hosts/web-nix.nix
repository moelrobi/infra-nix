{lib, ...}: {
  imports = [
    ../templates/server.nix
  ];

  networking.hostName = "web-nix";
  networking.fqdn = "web-nix.uwu.tools";

  # Enable Nginx service
  services.nginx.enable = true;

  system.stateVersion = "25.05";
}
