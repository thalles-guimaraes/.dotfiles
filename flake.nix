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

  outputs = { self, nixpkgs, home-manager, catppuccin,... }@inputs: {
    nixosConfigurations = {
      # MUDE AQUI: Substitua SEU_HOSTNAME pelo nome do seu PC
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # Passa os inputs para os módulos (útil no futuro)
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          
          # Módulo do Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.thallesnote = import ./home.nix;
          }
        ];
      };
    };
  };
}