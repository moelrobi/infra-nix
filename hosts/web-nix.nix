{
  config,
  lib,
  ...
}: {
  imports = [
    ../templates/server.nix
  ];

  networking.hostName = "web-nix";
  networking.fqdn = "web-nix.uwu.tools";

  # Enable Nginx service
  services.nginx.enable = true;
  services.nginx.virtualHosts."i.uwu.tools" = {
    enableSSL = true;
    sslCertificate = builtins.readFile ../certs/uwu.tools.crt;
    sslCertificateKey = config.sops.secrets."uwu.tools.key".path;

    locations."/" = {
      proxyPass = "http://localhost:3000";
    };
  };

  system.stateVersion = "25.05";
}
