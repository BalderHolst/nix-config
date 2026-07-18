{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        prefer-no-csd = {};

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard.xkb.layout = "dk";

        layout = {
            gaps = 10;
            border.width = 2;
            focus-ring.width = 2;
        };

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Q".close-window = {};
          "Mod+P".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+B".spawn-sh = lib.getExe pkgs.firefox;
          "Mod+F".fullscreen-window = {};
          "Mod+C".maximize-column = {};
          "Mod+Shift+Return".toggle-window-floating = {};

          "Mod+H".focus-column-left = {};
          "Mod+J".focus-window-or-workspace-down = {};
          "Mod+K".focus-window-or-workspace-up = {};
          "Mod+L".focus-column-right = {};

          "Mod+WheelScrollDown".focus-workspace-down = {}; # { cooldown-ms=150; };
          "Mod+WheelScrollUp".focus-workspace-up = {}; # { cooldown-ms=150; };
          "Mod+WheelScrollRight".focus-column-right = {};
          "Mod+WheelScrollLeft".focus-column-left = {};

          # Workspace navigation
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          "Mod+Shift+1".move-window-to-workspace = 1;
          "Mod+Shift+2".move-window-to-workspace = 2;
          "Mod+Shift+3".move-window-to-workspace = 3;
          "Mod+Shift+4".move-window-to-workspace = 4;
          "Mod+Shift+5".move-window-to-workspace = 5;
          "Mod+Shift+6".move-window-to-workspace = 6;
          "Mod+Shift+7".move-window-to-workspace = 7;
          "Mod+Shift+8".move-window-to-workspace = 8;
          "Mod+Shift+9".move-window-to-workspace = 9;

          "Mod+Escape".toggle-keyboard-shortcuts-inhibit = {};

        };
      };
    };
  };
}
