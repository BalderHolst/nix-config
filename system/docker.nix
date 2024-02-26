{ ... }:
{
    virtualisation.docker = {
        enable = true;
        storageDriver = "devicemapper";
        rootless = {
            enable = true;
            setSocketVariable = true;
        };
    };
}
