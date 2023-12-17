{ pkgs, ... }:
{
    home.packages = with pkgs; [
        (pass-wayland.withExtensions (exts: [
          exts.pass-update
          exts.pass-checkup
          exts.pass-genphrase
        ]))
    ];
}
