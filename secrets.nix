{
  config,
  lib,
  pkgs,
  ...
}: let
  mkOpt = lib.mkOption;
in {
  options.sops.overrides = mkOpt {
    type = lib.types.attrsOf lib.types.attrs;
    default = {};
    description = ''
      Overrides for SOPS secrets. Each entry should be named after the secret file without the `.enc` suffix.
      The value should be an attribute set with the following optional keys:
      - `mode`: The file mode for the secret (default: "0400").
      - `owner`: The owner of the secret file (default: "root").
    '';
  };

  config = let
    host = config.networking.hostName;
    secretDir = "${./secrets}/${host}";

    contents =
      if builtins.pathExists secretDir
      then lib.attrNames (builtins.readDir secretDir)
      else [];

    files =
      lib.filter (
        f: let
          path = "${secretDir}/${f}";
        in
          builtins.pathExists path
          && (
            lib.hasSuffix ".enc" f
            || lib.hasSuffix ".json" f
          )
      )
      contents;

    overrides = config.sops.overrides or {};

    mkEntry = f: let
      path = "${secretDir}/${f}";
      isEnc = lib.hasSuffix ".enc" f;
      isJsonEnc = lib.hasSuffix ".json.enc" f;
      isJson = !isEnc && lib.hasSuffix ".json" f;
      base =
        if isEnc
        then lib.removeSuffix ".enc" f
        else lib.removeSuffix ".json" f;
    in {
      name = "${host}/${base}";
      value = lib.filterAttrs (_: v: v != null) {
        # sopsFile für verschlüsselte Dateien, sonst null
        sopsFile = path;
        format =
          if isJson || isJsonEnc
          then "json"
          else "binary";
        # nur für echte .json.enc; bei foo.json reicht source
        # For JSON (and JSON.enc) files we set key to an empty string.  This
        # instructs sops-nix to emit the full decrypted JSON document rather
        # than extracting a single key.  Without this, it attempts to extract
        # a key named after the file (e.g. "secrets"), which fails for files
        # like `secrets.json` that have no such top-level key.
        key =
          if isJson || isJsonEnc
          then ""
          else null;
        mode = overrides.mode or "0400";
        owner = overrides.owner or "root";
      };
    };

    entries = builtins.map mkEntry files;
  in {
    sops.age = {
      keyFile = "/etc/sops/age/keys.txt";
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      generateKey = true;
    };

    sops.secrets = lib.listToAttrs entries;
  };
}
