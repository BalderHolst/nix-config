{ ... }:
{
    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
        rootless = {
            enable = true;
            setSocketVariable = true;
        };
    };
}
