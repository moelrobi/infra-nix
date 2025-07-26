{ lib, ... }:

{
    imports = [
        ../templates/server.nix
    ];

    networking.fqdn = "web-nix.uwu.tools";

    system.stateVersion = "25.05";
}