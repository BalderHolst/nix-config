{ pkgs }:
let
pavucontrol = pkgs.pavucontrol + "/bin/pavucontrol";
kitty = pkgs.kitty + "/bin/kitty";
bpython = pkgs.python311Packages.bpython + "/bin/bpython";
in
''
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
''

