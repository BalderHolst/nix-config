{ pkgs, config, inputs, lib, configDir, ... }:
let
    scripts = import ./scripts { inherit pkgs; };
in
{

    options.niri.theme              = lib.mkOption { type = lib.types.attrs; };
    options.niri.monitor            = lib.mkOption { type = lib.types.str; };
    options.niri.size               = lib.mkOption { type = lib.types.functionTo lib.types.str; };
    options.niri.swap_escape        = lib.mkOption { type = lib.types.bool; };
    options.niri.disable_escape_led = lib.mkOption { type = lib.types.bool; };
    options.niri.utilsDir           = lib.mkOption { type = lib.types.str; default = false; };

    config.home.packages = with pkgs; [
        noctalia-shell
        kdePackages.breeze # Cursor
        swaylock
        brightnessctl # Brightness control
        wireplumber   # Audio control
        grim          # Capture screen
        slurp         # Select screenshot area
        swappy        # Annotate Screenshot
        imagemagick   # Trim screenshot
    ];


    config.home.file = {

###################### NIRI CONFIG ######################

        ".config/niri/config.kdl".text = /* kdl */ ''

workspace "browser"

window-rule {
    match app-id="firefox$"
    open-maximized true
    open-on-workspace "browser"
}

input {
    keyboard {
        xkb {
            layout "dk"
            ${if config.niri.swap_escape then "options \"caps:swapescape\"" else ""}
        }

        repeat-delay 180
        repeat-rate 50
        // track-layout "global"
        // numlock
    }

    touchpad {
        // off
        tap
        // dwt
        // dwtp
        // drag false
        // drag-lock
        natural-scroll
        // accel-speed 0.2
        // accel-profile "flat"
        // scroll-factor 1.0
        // scroll-factor vertical=1.0 horizontal=-2.0
        // scroll-method "two-finger"
        // scroll-button 273
        // scroll-button-lock
        // tap-button-map "left-middle-right"
        // click-method "clickfinger"
        // left-handed
        // disabled-on-external-mouse
        // middle-emulation
    }

    mouse {
        // off
        // natural-scroll
        // accel-speed 0.2
        // accel-profile "flat"
        // scroll-factor 1.0
        // scroll-factor vertical=1.0 horizontal=-2.0
        // scroll-method "no-scroll"
        // scroll-button 273
        // scroll-button-lock
        // left-handed
        // middle-emulation
    }

    // disable-power-key-handling
    // warp-mouse-to-focus
    // focus-follows-mouse max-scroll-amount="0%"
    workspace-auto-back-and-forth

    mod-key "Super"
    mod-key-nested "Alt"
}

spawn-at-startup "noctalia-shell"

${if config.niri.disable_escape_led
then /* kdl */ ''
    spawn-at-startup "brightnessctl --device='*capslock*' set 0"
'' else ""
}

prefer-no-csd
screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

cursor {
    xcursor-theme "breeze_cursors"
    xcursor-size 24
    hide-when-typing
    hide-after-inactive-ms 1000
}

xwayland-satellite {
    path "${lib.getExe pkgs.xwayland-satellite}";
}

layout {

    always-center-single-column

    // Visuals
    gaps 10
    focus-ring {
        off
    }

    border { 
        width 2
        inactive-color "#${config.niri.theme.background}"
        active-color "#${config.niri.theme.focus}"
        urgent-color "#${config.niri.theme.alert}"
    }


    background-color "#${config.niri.theme.background}"
}

layer-rule {
    // This is for swaybg; change for other wallpaper tools.
    // Find the right namespace by running niri msg layers.
    match namespace="^wallpaper$"
    place-within-backdrop true
}

window-rule {
    geometry-corner-radius 8
    clip-to-geometry true
}

hotkey-overlay {
    skip-at-startup
}

binds {
    Mod+Return { spawn-sh "kitty"; }
    Mod+Q { close-window; }
    Mod+P { spawn-sh "noctalia-shell ipc call launcher toggle"; }

    Mod+B { spawn-sh "${pkgs.writeShellScript "focus_firefox" /* bash */ ''
        # 1. If Firefox is not running at all, launch it
        if ! pgrep firefox > /dev/null 2>&1; then
            firefox &
            exit 0
        fi

        # 2. Get the name of the currently focused workspace from niri
        CURRENT_WORKSPACE=$(niri msg -j workspaces | jq -r '.[] | select(.is_focused == true) | .name')

        # 3. If already on the "browser" workspace, open a new Firefox window/instance
        #    Otherwise, switch focus to the "browser" workspace
        if [ "$CURRENT_WORKSPACE" = "browser" ]; then
            firefox --new-window &
        else
            niri msg action focus-workspace browser
        fi
    ''}"; }

    Mod+F { fullscreen-window; }
    Mod+C { maximize-column; }
    Mod+Shift+Return { toggle-window-floating; }
    Mod+Shift+S { spawn-sh "grim -g \"$(slurp)\" - | magick - -shave 3x3 PNG:- | swappy -f -"; }

    Mod+H { focus-column-left; }
    Mod+L { focus-column-right {}; }
    Mod+J { focus-window-or-workspace-down {}; }
    Mod+K { focus-window-or-workspace-up {}; }

    Mod+Shift+H { consume-or-expel-window-left; }
    Mod+Shift+L { consume-or-expel-window-right; }
    Mod+Shift+J { move-window-down-or-to-workspace-down; }
    Mod+Shift+K { move-window-up-or-to-workspace-up; }

    Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
    Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
    Mod+WheelScrollRight { focus-column-right; }
    Mod+WheelScrollLeft { focus-column-left; }

    Mod+W { toggle-column-tabbed-display; }

    // Workspace navigation
    Mod+0 { spawn-sh "${scripts.create-empty-first-workspace}"; }
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    Mod+6 { focus-workspace 6; }
    Mod+7 { focus-workspace 7; }
    Mod+8 { focus-workspace 8; }
    Mod+9 { focus-workspace 9; }

    Mod+O { toggle-overview; }

    Mod+Shift+1 { move-window-to-workspace 1; }
    Mod+Shift+2 { move-window-to-workspace 2; }
    Mod+Shift+3 { move-window-to-workspace 3; }
    Mod+Shift+4 { move-window-to-workspace 4; }
    Mod+Shift+5 { move-window-to-workspace 5; }
    Mod+Shift+6 { move-window-to-workspace 6; }
    Mod+Shift+7 { move-window-to-workspace 7; }
    Mod+Shift+8 { move-window-to-workspace 8; }
    Mod+Shift+9 { move-window-to-workspace 9; }

    Mod+Escape { toggle-keyboard-shortcuts-inhibit; }

    Mod+Shift+E { quit; }

    XF86MonBrightnessUp   { spawn "brightnessctl" "set" "+4%"; }
    XF86MonBrightnessDown { spawn "brightnessctl" "set" "4%-"; }

    Shift+XF86MonBrightnessUp { spawn "brightnessctl" "set" "100%"; }
    Shift+XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%"; }

    XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "5%+"; }
    XF86AudioLowerVolume { spawn "wpctl" "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "5%-"; }
    Shift+XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "100%"; }
    Shift+XF86AudioLowerVolume { spawn "wpctl" "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "10%"; }
    XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
}
        '';

        ".cache/noctalia/wallpapers.json".text = builtins.toJSON {
            defaultWallpaper = config.niri.theme.wallpaper;
        };

        ".config/noctalia/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/user/vm/niri/noctalia.settings.json";

    };
}
