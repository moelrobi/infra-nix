{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators/8ee78470029e641cddbd8721496da1316b47d3b4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # my-modules = {
    #   url = "github:joshleecreates/nix-modules/main";
    #   flake = false;
    # };
    # my-config = {
    #   url = "github:joshleecreates/nix-config/main";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    nixos-generators,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;

    hostsDir = ./hosts;
    readHost = file: import (hostsDir + ("/" + file));
    hostFiles = lib.filter (file: lib.hasSuffix ".nix" file) (lib.attrNames (builtins.readDir hostsDir));
    secrets = import ./secrets.nix;

    # Generate NixOS configurations for each host
    hostDefinitions = builtins.map (file: readHost file) hostFiles;
    makeSystem = host:
      lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          sops-nix.nixosModules.sops
          secrets
          host
        ];
      };

    systems = builtins.map makeSystem hostDefinitions;

    configurations = lib.listToAttrs (builtins.map (host: {
        name = host.config.networking.hostName;
        value = host;
      })
      systems);

    # Generate Proxmox images for each host
    fileToHostname = file: lib.removeSuffix ".nix" file;
    hostFilePairs =
      builtins.map (file: {
        name = fileToHostname file;
        value = readHost file;
      })
      hostFiles;

    makeProxmoxImage = {
      name,
      value,
    }: {
      inherit name;
      value = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          {
            # Pin nixpkgs to the flake input, so that the packages installed
            # come from the flake inputs.nixpkgs.url.
            nix.registry.nixpkgs.flake = nixpkgs;
            # set disk size to to 20G
            # virtualisation.diskSize = 20 * 1024;
          }
          sops-nix.nixosModules.sops
          secrets
          value
        ];
        format = "proxmox";
      };
    };

    proxmoxImages = lib.listToAttrs (builtins.map makeProxmoxImage hostFilePairs);
  in {
    nixosModules = {
      server = ./templates/server.nix;
      nginx = ./templates/nginx/nginx.nix;
    };

    nixosConfigurations = configurations;
    packages."x86_64-linux" = proxmoxImages;
  };
}
