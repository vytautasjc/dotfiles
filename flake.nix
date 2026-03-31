{
  description = "Multi-platform Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      mkHome =
        {
          system,
          username,
          homeDirectory,
          extraModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          modules = [
            ./nix/users/${username}.nix
            {
              home = {
                inherit username homeDirectory;
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        limadev = mkHome {
          system = "aarch64-linux";
          username = "limadev";
          homeDirectory = "/home/limadev";
          extraSpecialArgs = {
            # In case of a VM this should point to a volume that is persisted between VM runs, e.g. a persistent volume
            # This value is passed as env variable from Lima provision scripts
            dataMountPath = builtins.getEnv "PERSISTENT_DATA_PATH"; 
          };
        };

        dev = mkHome {
          system = "aarch64-darwin";
          username = "dev";
          homeDirectory = "/Users/dev";
        };

        vytautas = mkHome {
          system = "aarch64-darwin";
          username = "vytautas";
          homeDirectory = "/Users/vytautas";
        };
      };
    };
}
