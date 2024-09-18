{ pkgs, config, user, lib, ... }:
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

    options.nas.always-sync = lib.mkOption {
        type = lib.types.bool;
        default = false;
    };

    options.nas.sync-locations = lib.mkOption
    {
        type = lib.types.listOf lib.types.attrs;
    };

    options.nas.temp-dir = lib.mkOption {
        type = lib.types.str;
        default = "/tmp";
    };

    options.nas.remote-backup-dir = lib.mkOption {
        type = lib.types.str;
        default = "";
    };

    options.nas.backup-exclude = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
    };

    config.environment.systemPackages = [
        (
        let 
            excludes = lib.strings.concatMapStrings (x: x + " ") (
                lib.lists.forEach config.nas.backup-exclude (x: "--exclude=\"${x}\"") 
            );
        in
        pkgs.stdenv.mkDerivation rec {
            name = "backup-home";
            script = name;

            src =  pkgs.writeShellScriptBin script (if config.nas.remote-backup-dir != "" then ''

            ${ 
            if config.nas.always-sync then "" else ''
                # Check if we are on the correct internet
                SSID="$(${pkgs.wirelesstools}/bin/iwgetid -r)"
                if [ ! "$SSID" = "${config.nas.network-ssid}" ]; then
                    echo "You are not connected to '${config.nas.network-ssid}'. Cannot backup home directory."
                    exit 1
                fi
            ''
            }

            time=$(date "+%Y.%d.%m-%H.%M.%S")
            name="$time-$(hostname)-home-backup.tar.gz"

            
            path="${config.nas.temp-dir}/backups/$name"
            mkdir -p "${config.nas.temp-dir}/backups"

            tar -c ${excludes} --verbose --use-compress-program=zstdmt -f "$path" /home

            echo "Created archive '$name'."

            echo "Sending to ${config.nas.rclone-device}..."

            ${pkgs.callPackage ../pkgs/rclone.nix {}}/bin/rclone copy -v "$path" "${config.nas.rclone-device}:${config.nas.remote-backup-dir}"

            rm -v "$path"

            echo "Done!"

            '' else ''
            echo "Option 'nas.remote-backup-dir' not specified in nix configuration."
            '');

            installPhase = ''
            mkdir -p $out/bin
            cp -v $src/bin/${script} $out/bin/${script}
            '';
        }
        )
        pkgs.rclone
    ];

    config = {

        systemd.services.${config.nas.service-name} =
        let 
            pid_location = "/tmp/${config.nas.service-name}.pid";
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
                ${if config.nas.always-sync then "" else ''
                    if [ "$SSID" = "${config.nas.network-ssid}" ]; then
                ''}
                ${sync_commands}
                echo "--------- EVERYTHING UP TO DATE ----------"
                ${if config.nas.always-sync then "" else "fi"}
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
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            description = "Syncronize local directorioes with NAS";
            serviceConfig = {
                Type = "forking";
                User = user.username;
                ExecStart = start; 
                ExecStop = stop;
                ExecReload = reload; 
            };
        };
    };
}
