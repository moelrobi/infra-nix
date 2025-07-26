# CAUTION: DO NOT BUILD THIS FILE DIRECTLY!
# This file is the example file for the base host.
# Copy this file and remove this comment to create your own host configuration.

{
  config,
  lib,
  ...
}: {
  imports = [
    ../templates/server.nix
  ];

  networking.hostName = "base";
  networking.fqdn = "base.uwu.tools";

  system.stateVersion = "25.05";
}
