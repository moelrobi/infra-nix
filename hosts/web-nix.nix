{
  config,
  lib,
  ...
}: let
  uwu.tools.crt = ../certs/uwu.tools.crt;
  uwu.tools.key = "/run/secrets.d/${config.networking.hostName}/uwu.tools.key";
in {
  imports = [
    ../templates/server.nix
  ];

  networking.hostName = "web-nix";
  networking.fqdn = "web-nix.uwu.tools";

  sops.overrides = {
    "uwu.tools.key" = {
      mode = "0400";
      owner = "nginx";
    };
  };

  # Enable Nginx service
  services.nginx.enable = true;
  services.nginx.virtualHosts."i.uwu.tools" = {
    forceSSL = true;
    sslCertificate = uwu.tools.crt;
    sslCertificateKey = config.sops.secrets."${config.networking.hostName}/uwu.tools.key".path;

    locations."/" = {
      proxyPass = "http://localhost:3000";
    };
  };

  system.stateVersion = "25.05";
}
