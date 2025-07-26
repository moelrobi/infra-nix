# Infrastructure as code as NixOS

To create a new host:

Put a new Host-File in hosts/ directory. Use the blank.nix file for this:
```
nix build .#<hostname>
```

After that, deploy the image to the proxmox Cluster. Dont forget to set unique Flag and change the Hostname. (Reboot 2 time for new DNS Record to be live)

Generate a new public key from the SSH-Host Key:
```
nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
```

put the output to `.sops.yaml` under hosts.
Update the keys with the `rebuild-infra` command (found in my original nixfiles).

after that the VM should be up and can be rebuilded with `rebuild-infra`