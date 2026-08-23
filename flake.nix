{
  description = "Minha primeira configuração com Flakes e Home Manager";

  inputs = {
    # Usando o canal estável do NixOS 26.05 (ajuste se estiver usando outra versão)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    
    # Home Manager acompanhando a mesma versão
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, ... }@inputs:
  let
    system = "x86_64-linux";

    homeManagerModule = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.backupFileExtension = "backup";

      home-manager.extraSpecialArgs = {
        inherit inputs;
      };

      home-manager.users.thallesnote = import ./home.nix;
    };
  in
  {
    nixosConfigurations = {

      notebook = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./configuration.nix
          ./hardware-notebook.nix

          {
            networking.hostName = "thalles-note";
          }

          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./configuration.nix
          ./hardware-desktop.nix

          {
            networking.hostName = "thalles-desktop";
          }

          # NVIDIA GTX 1060
          ({ config, ... }: {
            hardware.graphics.enable = true;

            services.xserver.videoDrivers = [ "nvidia" ];

            hardware.nvidia = {
              modesetting.enable = true;

              # GTX 1060 = Pascal.
              # Não suporta o módulo open atual da NVIDIA.
              open = false;

              # Pascal agora usa a branch legacy 580.
              package =
                config.boot.kernelPackages.nvidiaPackages.legacy_580;
            };
          })

          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
      };
    };
  };
}