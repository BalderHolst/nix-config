{ self, inputs, ... }: {
  flake.nixosConfigurations.dolphin = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.dolphinConfiguration
    ];
  };
}
