{ pkgs, config, lib, username,... }:
{

    options.nas.service-name = lib.mkOption {
        type = lib.types.str;
        default = "nas-sync";
    };

    options.nas.network-ssid = lib.mkOption {
        type = lib.types.str;
    };

    options.nas.rclone-device = lib.mkOption {
        type = lib.types.str;
    };

    options.nas.interval = lib.mkOption {
        type = lib.types.int;
        default = 120;
    };

    options.nas.sync-locations = lib.mkOption
    {
        type = lib.types.listOf lib.types.attrs;
    };

    config =
    let 
        name = config.nas.service-name;
        pid_location = "/tmp/${name}.pid";
        
        exclude = pkgs.writeText "exclude.txt" ''
        - __pycache__/
        '';

        sync_commands = lib.strings.concatMapStrings
            (x: x + "\n")
            (
                lib.lists.forEach config.nas.sync-locations
                    (x: 
                    let 
                        remote = "${config.nas.rclone-device}:${x.remote}";
                        rclone = "${pkgs.callPackage ../pkgs/rclone.nix {}}/bin/rclone";
                    in
                    ''
                    [[ -d "${x.local}" ]] || mkdir -p ${x.local}
                    ${rclone} bisync --resilient --create-empty-src-dirs --links -v ${x.local} ${config.nas.rclone-device}:${x.remote} || {
                        echo "Resync needed..."
                        ${rclone} bisync --create-empty-src-dirs --links --resync ${x.local} ${remote} -v
                    }
                    echo "Done syncing ${x.local}."
                    '')
            );
        daemon = pkgs.writeShellScript "daemon.sh" ''
            while true; do
            SSID="$(${pkgs.wirelesstools}/bin/iwgetid -r)"
            if [ "$SSID" = "${config.nas.network-ssid}" ]; then
                ${sync_commands}
                echo "--------------------------------------- EVERYTHING UP TO DATE ----------------------------------------"
            fi
            echo "Waiting ${builtins.toString config.nas.interval} seconds."
            sleep ${builtins.toString config.nas.interval}
            done
        '';
        start = pkgs.writeShellScript "start.sh" ''
            ${daemon} & PID=$!
            echo "Started with pid: $PID"
            echo "$PID" > ${pid_location}
        '';

        stop = pkgs.writeShellScript "stop.sh" ''
            kill "$PID"
            # Remove locks
            ls /home/balder/.cache/rclone/bisync/*lck | xargs rm -v
        '';

        reload = pkgs.writeShellScript "reload.sh" ''
            ${stop}
            ${start}
        '';

    in
    {
        systemd.services.${name} = {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            description = "Syncronize local directorioes with NAS";
            serviceConfig = {
                Type = "forking";
                User = username;
                ExecStart = start; 
                ExecStop = stop;
                ExecReload = reload; 
            };
        };
    };
}
