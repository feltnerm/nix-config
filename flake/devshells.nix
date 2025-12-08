_: {
  perSystem =
    { pkgs, inputs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "feltnerm-dev";
        NIX_CONFIG = "experimental-features = nix-command flakes\nextra-substituters = https://feltnerm.cachix.org\nextra-trusted-public-keys = feltnerm.cachix.org-1:ZZ9S0xOGfpYmi86JwCKyTWqHbTAzhWe4Qu/a/uHZBIQ=";
        nativeBuildInputs = with pkgs; [
          nix
          git
          treefmt
          gitlint
          gnupg
          home-manager
          inputs.agenix.packages.${pkgs.system}.default
          age
          ssh-to-age
        ];
        shellHook = ''
          echo "Welcome to feltnerm-dev"
          echo "Commands:"
          echo "  nix fmt                                 # format the repo"
          echo "  nix flake check                         # run flake checks"
          echo "  nix flake update                        # update inputs"
          echo "  home-manager switch --flake .#mark"
          echo ""
          echo "Secrets Management:"
          echo "  agenix -e secrets/path/to/secret.age    # edit/create secret"
          echo "  ssh-to-age < ~/.ssh/id_ed25519.pub      # convert personal SSH key"
          echo "  ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub  # convert host key"
        '';
      };

      devShells.vm = pkgs.mkShell {
        name = "feltnerm-vm";
        NIX_CONFIG = "experimental-features = nix-command flakes\nextra-substituters = https://feltnerm.cachix.org\nextra-trusted-public-keys = feltnerm.cachix.org-1:ZZ9S0xOGfpYmi86JwCKyTWqHbTAzhWe4Qu/a/uHZBIQ=";
        nativeBuildInputs = with pkgs; [
          nix
          qemu
          cloud-utils # provides cloud-localds
        ];
        shellHook = ''
          echo "Welcome to feltnerm-vm"
          echo "VM Commands:"
           echo "  build-vm <host> <output> # build VM for host/output (vm|vmWithBootLoader|vmWithDisko or iso|qcow|...)"
           echo "  seed-cloud-init <user> <pubkey> [iso]  # create seed ISO"
           echo "  run-vm [result|path]     # run image with qemu"
           echo "  ssh -p 2222 mark@localhost"

           # Tunables for run-vm
           export VM_MEMORY=$${_VM_MEMORY:-4096}
           export VM_CPUS=$${_VM_CPUS:-2}

           # Source helper functions
           if [ -f scripts/devshell-vm.sh ]; then
             source scripts/devshell-vm.sh
           fi

        '';
      };

    };
}
