{ pkgs, ... }:
{
    home.packages = with pkgs; [
        pavucontrol # audio control GUI
        firefox-wayland # main browser
        brave # backup browser
        libreoffice # office suite to open those awful microsoft files
        zathura # pdf-viewer
        sxiv # image viewer
        mpv # audio player
        vlc # video player
        gnome.nautilus # gui file explorer
        audacity # audio editor
        texlive.combined.scheme-full # latex with everything
        python311Packages.pygments # syntax highlighter for minted latex package
        python311Packages.dbus-python # used for initializing eduroam
        gimp # image manipulation
        drawio # create diagrams
        tidal-hifi # music streaming
        imagemagick # cli image manipulation
        wf-recorder # screen recorder
        filezilla # ftp gui interface
        kicad # design pcd's and draw circuits
        prusa-slicer # slicer for 3d printing
        tor-browser-bundle-bin # secure and anonymous browsing
        xournalpp # write on pdfs!
        discord # communication
        transmission-qt # bittorrent client for file shareing
        obsidian # note taking
        krita
    ];

    home.file = {
        ".config/zathura/zathurarc".text = ''
            set statusbar-h-padding 0
            set statusbar-v-padding 0
            set page-padding 1
            map d scroll half-down
            map u scroll half-up
            map R rotate
            map J zoom in
            map K zoom out
            map i recolor
            map p print
            set selection-clipboard clipboard
        '';
    };
}
