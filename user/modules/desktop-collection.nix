{ pkgs, ... }:
{
    home.packages = with pkgs; [
        pavucontrol                   # audio control GUI
        firefox-wayland               # main browser
        brave                         # backup (chromium) browser
        libreoffice                   # office suite to open those awful microsoft files
        zathura                       # pdf-viewer
        sxiv                          # image viewer
        eog                           # another image viewer
        mpv                           # media player
        vlc                           # good old video player (X11)
        ffmpeg                        # THE cli video tool
        xplayer                       # wayland video player
        nautilus                      # gui file explorer
        audacity                      # audio editor
        texlive.combined.scheme-full  # latex with everything
        gimp                          # image manipulation
        drawio                        # create diagrams
        tidal-hifi                    # music streaming
        imagemagick                   # cli image manipulation
        wf-recorder                   # screen recorder
        filezilla                     # ftp gui interface
        kicad                         # design pcd's and draw circuits
        prusa-slicer                  # slicer for 3d printing
        tor-browser                   # secure and anonymous browsing
        xournalpp                     # write on pdfs!
        discord                       # communication
        transmission_4-qt             # bittorrent client for file shareing
        obsidian                      # note taking
        krita                         # digital painting
        musescore                     # music notation
        olive-editor                  # video editor
        hyprpicker                    # color picker
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
