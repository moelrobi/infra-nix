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
    clientMaxBodySize = "10M";
    virtualHosts = {
      # Default virtual host
      "_" = {
        addSSL = true;
        sslCertificate = uwu.tools.crt;
        sslCertificateKey = config.sops.secrets."web-nix/uwu.tools.key".path;
        locations."/" = {
          return = "404";
        };
      };

      "mail.uwu.tools" = {
        addSSL = false;
        locations."/" = {
          return = "401";
        };

        locations.".well-known/" = {
          proxyPass = "http://mail.uwu.tools/.well-known/";
          recommendedProxySettings = true;
        };
      };

      # Redirect rules
      "discord.scprp.de" = {
        forceSSL = true;
        sslCertificate = scprp.de.crt;
        sslCertificateKey = config.sops.secrets."web-nix/scprp.de.key".path;
        locations."/" = {
          return = "301 https://discord.gg/kmMmfxnnZY";
        };
      };

      # Reverse proxy rules
      # vw.uwu.tools → password.uwu.tools
      "vw.uwu.tools" = {
        forceSSL = true;
        sslCertificate = uwu.tools.crt;
        sslCertificateKey = config.sops.secrets."web-nix/uwu.tools.key".path;
        locations."/" = {
          proxyPass = "http://password.uwu.tools";
          recommendedProxySettings = true;
        };
      };

      # wekan.scprp.de → wekan.uwu.tools
      "wekan.scprp.de" = {
        forceSSL = true;
        sslCertificate = scprp.de.crt;
        sslCertificateKey = config.sops.secrets."web-nix/scprp.de.key".path;
        locations."/" = {
          proxyPass = "http://wekan.uwu.tools";
          recommendedProxySettings = true;
        };
      };

      # i.uwu.tools → xbb-rob.uwu.tools
      "i.uwu.tools" = {
        forceSSL = true;
        sslCertificate = uwu.tools.crt;
        sslCertificateKey = config.sops.secrets."web-nix/uwu.tools.key".path;
        extraConfig = ''
          client_max_body_size 100M;
        '';
        locations."/" = {
          proxyPass = "http://xbb-rob.uwu.tools";
          recommendedProxySettings = true;
        };
      };

      # scr.enraiser.at → xbb-enraiser.uwu.tools
      "scr.enraiser.at" = {
        forceSSL = true;
        sslCertificate = enraiser.at.crt;
        sslCertificateKey = config.sops.secrets."web-nix/enraiser.at.key".path;
        extraConfig = ''
          client_max_body_size 100M;
        '';
        locations."/" = {
          proxyPass = "http://xbb-enraiser.uwu.tools";
          recommendedProxySettings = true;
        };
      };

      # i.snoks.net → xbb-snokie.uwu.tools
      "i.snoks.net" = {
        forceSSL = true;
        sslCertificate = snoks.net.crt;
        sslCertificateKey = config.sops.secrets."web-nix/snoks.net.key".path;
        extraConfig = ''
          client_max_body_size 100M;
        '';
        locations."/" = {
          proxyPass = "http://xbb-snokie.uwu.tools";
          recommendedProxySettings = true;
        };
      };

      # gmod.uwu.tools → gmod-web.uwu.tools
      "gmod.uwu.tools" = {
        forceSSL = true;
        sslCertificate = uwu.tools.crt;
        sslCertificateKey = config.sops.secrets."web-nix/uwu.tools.key".path;
        locations."/" = {
          proxyPass = "http://gmod-web.uwu.tools";
          recommendedProxySettings = true;
        };
      };

      # ls.uwu.tools → livesync.uwu.tools:5984
      "ls.uwu.tools" = {
        forceSSL = true;
        sslCertificate = uwu.tools.crt;
        sslCertificateKey = config.sops.secrets."web-nix/uwu.tools.key".path;
        extraConfig = ''
          client_max_body_size 100M;
        '';
        locations."/" = {
          proxyPass = "http://livesync.uwu.tools:5984";
          recommendedProxySettings = true;
        };
      };

      # git.scprp.de → gitea.uwu.tools
      "git.scprp.de" = {
        forceSSL = true;
        sslCertificate = scprp.de.crt;
        sslCertificateKey = config.sops.secrets."web-nix/scprp.de.key".path;
        extraConfig = ''
          client_max_body_size 100M;
        '';
        locations."/" = {
          proxyPass = "http://gitea.uwu.tools";
          recommendedProxySettings = true;
        };
      };

      # scprp.de → woltlab.uwu.tools
      "scprp.de" = {
        forceSSL = true;
        sslCertificate = scprp.de.crt;
        sslCertificateKey = config.sops.secrets."web-nix/scprp.de.key".path;
        locations."/" = {
          proxyPass = "http://woltlab.uwu.tools";
          recommendedProxySettings = true;
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
