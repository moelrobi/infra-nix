# Horizon Production Server Configuration

{
  config,
  lib,
  ...
}: {
  imports = [
    ../templates/server.nix
  ];

  networking.hostName = "hrz-prod-nix";
  networking.fqdn = "hrz-prod-nix.uwu.tools";

  system.stateVersion = "25.05";
}
