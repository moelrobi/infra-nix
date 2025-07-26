{
  config,
  lib,
  ...
}: let
  # Define the path to the SSL certificate for all virtual hosts
  aob-ssl.crt = ../certs/aob-ssl.crt;
  enraiser.at.crt = ../certs/enraiser.at.crt;
  scprp.de.crt = ../certs/scprp.de.crt;
  snoks.net.crt = ../certs/snoks.net.crt;
  uwu.tools.crt = ../certs/uwu.tools.crt;
in {
  imports = [
    ../templates/server.nix
  ];

  networking.hostName = "web-nix";
  networking.fqdn = "web-nix.uwu.tools";

  networking.firewall.allowedTCPPorts = [80 443];

  sops.overrides = {
    "aob-ssl.key" = {
      mode = "0400";
      owner = "nginx";
    };
    "enraiser.at.key" = {
      mode = "0400";
      owner = "nginx";
    };
    "scprp.de.key" = {
      mode = "0400";
      owner = "nginx";
    };
    "snoks.net.key" = {
      mode = "0400";
      owner = "nginx";
    };
    "uwu.tools.key" = {
      mode = "0400";
      owner = "nginx";
    };
  };

  # Enable Nginx service
  services.nginx = {
    enable = true;
    virtualHosts = {
      # vw.uwu.tools → password.uwu.tools
      "vw.uwu.tools" = {
        forceSSL = true;
        sslCertificate = uwu.tools.crt;
        sslCertificateKey = config.sops.secrets."web-nix/uwu.tools.key".path;
        locations."/" = {
          proxyPass = "http://password.uwu.tools";
        };
      };

      # wekan.scprp.de → wekan.uwu.tools
      "wekan.scprp.de" = {
        forceSSL = true;
        sslCertificate = scprp.de.crt;
        sslCertificateKey = config.sops.secrets."web-nix/scprp.de.key".path;
        locations."/" = {
          proxyPass = "http://wekan.uwu.tools";
        };
      };

      # i.uwu.tools → xbb-rob.uwu.tools
      "i.uwu.tools" = {
        forceSSL = true;
        sslCertificate = uwu.tools.crt;
        sslCertificateKey = config.sops.secrets."web-nix/uwu.tools.key".path;
        locations."/" = {
          proxyPass = "http://xbb-rob.uwu.tools";
        };
      };

      # scr.enraiser.at → xbb-enraiser.uwu.tools
      "scr.enraiser.at" = {
        forceSSL = true;
        sslCertificate = enraiser.at.crt;
        sslCertificateKey = config.sops.secrets."web-nix/enraiser.at.key".path;
        locations."/" = {
          proxyPass = "http://xbb-enraiser.uwu.tools";
        };
      };

      # i.snoks.net → xbb-snokie.uwu.tools
      "i.snoks.net" = {
        forceSSL = true;
        sslCertificate = snoks.net.crt;
        sslCertificateKey = config.sops.secrets."web-nix/snoks.net.key".path;
        locations."/" = {
          proxyPass = "http://xbb-snokie.uwu.tools";
        };
      };

      # gmod.uwu.tools → gmod-web.uwu.tools
      "gmod.uwu.tools" = {
        forceSSL = true;
        sslCertificate = uwu.tools.crt;
        sslCertificateKey = config.sops.secrets."web-nix/uwu.tools.key".path;
        locations."/" = {
          proxyPass = "http://gmod-web.uwu.tools";
        };
      };

      # ls.uwu.tools → livesync.uwu.tools:5984
      "ls.uwu.tools" = {
        forceSSL = true;
        sslCertificate = uwu.tools.crt;
        sslCertificateKey = config.sops.secrets."web-nix/uwu.tools.key".path;
        locations."/" = {
          proxyPass = "http://livesync.uwu.tools:5984";
        };
      };

      # git.scprp.de → gitea.uwu.tools
      "git.scprp.de" = {
        forceSSL = true;
        sslCertificate = scprp.de.crt;
        sslCertificateKey = config.sops.secrets."web-nix/scprp.de.key".path;
        locations."/" = {
          proxyPass = "http://gitea.uwu.tools";
        };
      };

      # scprp.de → woltlab.uwu.tools
      "scprp.de" = {
        forceSSL = true;
        sslCertificate = scprp.de.crt;
        sslCertificateKey = config.sops.secrets."web-nix/scprp.de.key".path;
        locations."/" = {
          proxyPass = "http://woltlab.uwu.tools";
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
