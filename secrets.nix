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
      - `key`: The key to use for decryption if the secret is in YAML format.
    '';
  };

  config = let
    host = config.networking.hostName;
    secretDir = "${./secrets}/${host}";
    allFiles = lib.attrNames (builtins.readDir secretDir);

    encryptedFiles = lib.filter (file: lib.hasSuffix ".enc" file) allFiles;

    overrides = config.sops.overrides or {};

    mkEntry = file: let
      basename = lib.removeSuffix ".enc" file;
      ovr = overrides.${basename} or {};
      path = "${secretDir}/${file}";
      isYaml = lib.hasSuffix ".yaml" file || lib.hasSuffix ".yml" file;
      format =
        if isYaml
        then "yaml"
        else "binary";
      keyAttr =
        if isYaml
        then (ovr.key or basename)
        else null;
    in {
      name = "${host}/${basename}";
      value = lib.filterAttrs (_: v: v != null) {
        sopsFile = path;
        format = format;
        key = keyAttr;
        mode = ovr.mode or "0400";
        owner = ovr.owner or "root";
      };
    };
  in {
    sops.age = {
      keyFile = "/etc/sops/age/keys.txt";
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      generateKey = true;
    };

    sops.secrets = lib.listToAttrs (builtins.map mkEntry encryptedFiles);
  };
}
