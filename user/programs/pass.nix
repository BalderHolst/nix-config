{ pkgs, ... }:
{
    home.packages = with pkgs; [
        (pass-wayland.withExtensions (exts: [
          exts.pass-update
          exts.pass-checkup
          exts.pass-genphrase
        ]))
    ];

    home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${pkgs.pinentry-qt}/bin/pinentry-qt
    '';
}
