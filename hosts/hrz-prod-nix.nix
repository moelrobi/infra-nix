# Horizon Production Server Configuration
{
  config,
  pkgs,
  lib,
  ...
}: let
  serverHostname = "hrz-prod-nix | Testing environment";
  serverPassword = "debug123";
  horizonTemplates = ../templates/horizon;
  horizonBin = pkgs.stdenv.mkDerivation {
    name = "horizon-bin";
    src = pkgs.fetchurl {
      url = "https://i.uwu.tools/VOxE5/sojebuHa66.zip/download";
      sha256 = "2043e8dfc0d80f416372229a0f8c62f687cb9c92a66feb1ee94d83db88e4aab3";
    };
    nativeBuildInputs = [pkgs.unzip];
    buildPhase = "true";
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out/bin
    '';
  };
in {
  imports = [
    ../templates/server.nix
  ];

  networking.hostName = "hrz-prod-nix";
  networking.fqdn = "hrz-prod-nix.uwu.tools";

  environment.systemPackages = with pkgs; [
    horizonBin
    git
    steamcmd
    jq
    jinja2-cli
  ];

  users.groups.horizon = {};
  users.users.horizon = {
    isSystemUser = true;
    description = "Horizon Production User";
    home = "/srv/horizon";
    group = "horizon";
    createHome = true;
  };

  # system.activationScripts.installGames = {
  #   text = ''
  #     #!/usr/bin/env bash
  #     set -euo pipefail

  #     # Create the steam directory
  #     mkdir -p /srv/steam/css
  #     chown -R horizon:horizon /srv/steam

  #     # Install games
  #     echo "Installing games..."
  #     ${pkgs.steamcmd}/bin/steamcmd +force_install_dir /srv/horizon +login anonymous +app_update 4020 validate +quit

  #     # Install games
  #     echo "Installing games..."
  #     ${pkgs.steamcmd}/bin/steamcmd +force_install_dir /srv/steam/css +login anonymous +app_update 2332330 validate +quit
  #   '';
  # };

  # system.activationScripts.deployHorizon = {
  #   text = ''
  #     #!/usr/bin/env bash
  #     set -euo pipefail
  #     SECRETS_JSON=/run/secrets/hrz-prod-nix/secrets

  #     # Secrets aus JSON lesen
  #     GITEA_PW=$(jq -r '.gitea_password'    $SECRETS_JSON)
  #     PROD_DB=$(jq -r '.prod_db_password'   $SECRETS_JSON)

  #     mkdir -p /opt/horizon/garrysmod/lua/bin
  #     cp -r ${horizonBin}/opt/horizon/garrysmod/lua/bin/* \
  #        /opt/horizon/garrysmod/lua/bin

  #     BASE="https://hrzn:\$\{GITEA_PW\}@git.scprp.de/Horizon"
  #     for repo in scprp helix addons scprp-weapon; do
  #       dest="/opt/horizon/garrysmod/$(
  #         case $repo in
  #           scprp|helix) echo "gamemodes/$repo";;
  #           addons)       echo "addons";;
  #           scprp-weapon) echo "addons/scprp-weapon";;
  #         esac
  #       )"
  #       rm -rf $dest
  #       mkdir -p $dest
  #       git clone "\$\{BASE\}/\$\{repo\}.git" "$dest"
  #     done

  #     mkdir -p /opt/horizon/garrysmod/cfg
  #     mkdir -p /opt/horizon/garrysmod/gamemodes/helix
  #     mkdir -p /opt/horizon/garrysmod/addons/{sam-147/gmodadminsuite-config,awarn3/addons/sreport}/lua

  #     jinja2 \
  #       -D sv_hostname=${serverHostname} \
  #       -D sv_password=${serverPassword} \
  #       ${horizonTemplates}/garrysmod/cfg/server.cfg.j2 \
  #       -o /opt/horizon/garrysmod/cfg/server.cfg
  #   '';
  # };

  system.stateVersion = "25.05";
}
