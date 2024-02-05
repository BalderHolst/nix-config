{ ... }:
{
    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfd";
        rootless = {
            enable = true;
            setSocketVariable = true;
        };
    };
}
