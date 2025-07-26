{
  config,
  lib,
  pkgs,
  ...
}: {
  sops.secrets."uwu.tools.key" = {
    sopsFile = ./secrets/uwu.tools.key.enc;
    format = "binary";
    mode = "0400";
    owner = "nginx";
  };
}
