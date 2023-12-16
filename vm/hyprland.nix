{ theme, pkgs, swap_escape, monitor, inputs, builtins, size, ... }:
let
    terminal = pkgs.kitty + "/bin/kitty";
    grim = pkgs.grim + "/bin/grim";
    slurp = pkgs.slurp + "/bin/slurp";
    swappy = pkgs.swappy + "/bin/swappy";
    paste = pkgs.wl-clipboard + "/bin/wl-paste";
    browser = pkgs.firefox + "/bin/firefox";
    rofi = pkgs.rofi-wayland + "/bin/rofi";
    launcher = "${rofi} -show drun";
    bmark = (pkgs.callPackage ../pkgs/bmark.nix { }) + "/bin/bmark";
    brightnessctl = pkgs.brightnessctl + "/bin/brightnessctl";
    wpctl = pkgs.wireplumber + "/bin/wpctl";
    #waybar = pkgs.waybar + "/bin/waybar";
    hyprpaper = pkgs.hyprpaper + "/bin/hyprpaper";
    convert = pkgs.imagemagick + "/bin/convert";
    pypr = (pkgs.callPackage ../pkgs/pyprland.nix { }) + "/bin/pypr";
    pavucontrol = pkgs.pavucontrol + "/bin/pavucontrol";
    kitty = pkgs.kitty + "/bin/kitty";
    bpython = pkgs.python311Packages.bpython + "/bin/bpython";
in 
{

    wayland.windowManager.hyprland = {
       plugins = [
          inputs.hyprgrass.packages.${pkgs.system}.default
       ];
    };

    home.file = {
        ".config/hypr/hyprland.conf".text = ''
        general {
            gaps_in = 5
            gaps_out = 10
            border_size = 2
            col.active_border = rgb(${theme.focus})
            col.inactive_border = rgba(595959aa)
            layout = dwindle
        }

        binds {
            workspace_back_and_forth = true
        }

        plugin {
          touch_gestures {
            sensitivity = 4.0

            # must be >= 3
            workspace_swipe_fingers = 3
          }
        }

        gestures {
          workspace_swipe = true
          workspace_swipe_cancel_ratio = 0.15
        }

        ${
        if swap_escape then ''
        input {
            kb_options = caps:swapescape
        }
        '' else ""
        }

        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor=,preferred,auto,auto
        # See https://wiki.hyprland.org/Configuring/Keywords/ for more

        # Execute your favorite apps at launch
        exec-once = dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY
        exec-once = waybar
        exec-once = ${hyprpaper}
        exec-once = ${pypr}

        # Cursor size in qt applications
        env = XCURSOR_SIZE, 18

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input {
            kb_layout = dk
            kb_variant =
            kb_model =
            kb_rules =

            follow_mouse = 1

            touchpad {
                natural_scroll = yes
            }

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            repeat_delay = 200
            repeat_rate = 40
        }

        decoration {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 7

            blur {
                enabled = true
                size = 3
                passes = 1
            }

            drop_shadow = yes
            shadow_range = 4
            shadow_render_power = 3
            col.shadow = rgba(1a1a1aee)
        }

        animations {
            enabled = yes

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = myBezier, 0.05, 0.9, 0.1, 1.05

            animation = windows, 1, 4, myBezier
            animation = windowsOut, 1, 4, default, popin 80%
            animation = border, 1, 10, default
            animation = borderangle, 1, 4, default
            animation = fade, 1, 4, default
            animation = workspaces, 1, 4, default
        }

        dwindle {
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = yes # you probably want this
        }

        master {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_is_master = true
        }

        gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = on
        }

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
        device:epic-mouse-v1 {
            sensitivity = -0.5
        }

        # Example windowrule v1
        # windowrule = float, ^(kitty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        $mainMod = SUPER

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, RETURN, exec, ${terminal}
        bind = $mainMod, Q, killactive, 
        bind = , swipe:4:d, killactive
        bind = $mainMod SHIFT, Q, exit, 
        bind = $mainMod, E, exec, ${bmark} open
        bind = $mainMod, V, togglefloating, 
        bind = $mainMod, P, exec, ${launcher}
        bind = $mainMod, B, exec, ${browser}
        bind = $mainMod SHIFT, S, exec, ${grim} -g "$(${slurp})" - | ${convert} - -shave 1x1 PNG:- | ${swappy} -f -
        bind = $mainMod SHIFT, E, exec, ${paste} | ${swappy} -f -
        bind = $mainMod SHIFT, P, exec, eval "$HOME/.myutils/passmenu"
        bind=SUPER, F, fullscreen
        # bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, S, togglesplit, # dwindle

        # Volume and Brightness
        bind = ,XF86MonBrightnessUp, exec, ${brightnessctl} set +4%
        bind = ,XF86MonBrightnessDown, exec, ${brightnessctl} set 4%-
        bind = SHIFT, XF86MonBrightnessUp, exec, ${brightnessctl} set 100%
        bind = SHIFT, XF86MonBrightnessDown, exec, ${brightnessctl} set 10%

        bind = ,XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
        bind = ,XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
        bind = SHIFT, XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 100%
        bind = SHIFT, XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 10%
        bind = ,XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle

        # Move focus with mainMod + arrow keys
        bind = $mainMod, h, movefocus, l
        bind = $mainMod, l, movefocus, r
        bind = $mainMod, k, movefocus, u
        bind = $mainMod, j, movefocus, d

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        # Scratchpads
        bind=$mainMod,T,exec,${pypr} toggle term && hyprctl dispatch bringactivetotop
        bind=$mainMod,C,exec,${pypr} toggle calculator && hyprctl dispatch bringactivetotop
        bind=$mainMod,A,exec,${pypr} toggle pavucontrol && hyprctl dispatch bringactivetotop
        $scratchpadsize = size 80% 85%

        $scratchpad = class:^(scratchpad)$
        windowrulev2 = float,$scratchpad
        windowrulev2 = $scratchpadsize,$scratchpad
        windowrulev2 = workspace special silent,$scratchpad
        windowrulev2 = center,$scratchpad

        $pavucontrol = class:^(pavucontrol)$
        windowrulev2 = float,$pavucontrol
        windowrulev2 = size 86% 40%,$pavucontrol
        windowrulev2 = move 50% 6%,$pavucontrol
        windowrulev2 = workspace special silent,$pavucontrol


        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        # Moonlander
        bind = $mainMod SHIFT CTRL, w, exec, command
        bind = $mainMod SHIFT CTRL, m, exec, ${browser} "https://configure.zsa.io/moonlander/layouts/KR0rp/latest/0"
        '';

        ".config/hypr/pyprland.json".text = ''
        {
            "pyprland": {
                "plugins": ["scratchpads", "magnify"]
            },
            "scratchpads": {
                "term": {
                    "command": "${kitty} --class scratchpad",
                    "margin": 50,
                    "unfocus": "hide",
                    "animation": "fromTop",
                    "lazy": true
                },
                "calculator": {
                    "command": "${kitty} --class scratchpad ${bpython}",
                    "margin": 50,
                    "unfocus": "hide",
                    "animation": "fromTop",
                    "lazy": true
                },
                "pavucontrol": {
                    "command": "${pavucontrol}",
                    "margin": 50,
                    "unfocus": "hide",
                    "animation": "fromTop",
                    "lazy": true
                }
            }
        }
        '';

        ".config/hypr/hyprpaper.conf".text = ''
        preload = ${theme.wallpaper}
        wallpaper = ${monitor}, ${theme.wallpaper}
        '';

        # Swappy screenshot editing tool
        ".config/swappy/config".text = ''
        [Default]
        save_dir=$HOME/Pictures/Screenshots
        save_filename_format=swappy-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=sans-serif
        paint_mode=brush
        early_exit=true
        fill_shape=false
        '';

        # Rofi config
        ".config/rofi/config.rasi".source = ../configs/rofi.rasi;
        ".config/rofi/theme.rasi".text = ''
            * {
                bg: #${theme.background}80;
                bg-alt: #${theme.background};
                fg: #${theme.foreground};
                fg-alt: #${theme.primary};
            }
        '';

    # Waybar config
    ".config/waybar/config".text = ''
        {
            "height": ${size 24},
            "spacing": ${size 10},
    '' + builtins.readFile ../configs/waybar/config;

    ".config/waybar/style.css".text = ''
        @define-color background #${theme.background};
        @define-color foreground #${theme.foreground};
        @define-color primary #${theme.primary};
        @define-color secondary #${theme.secondary};
        @define-color alert #${theme.alert};
        @define-color disabled #${theme.disabled};

        * {
            font-family: FiraCode Nerd Font;
            font-size: ${size 13}px;
        }
        '' + builtins.readFile ../configs/waybar/style.css;



    };

}
