{ pkgs, ... }:
{
    home.packages = with pkgs; [
        pavucontrol                   # audio control GUI
        chromium                      # backup browser
        libreoffice                   # office suite to open those awful microsoft files
        zathura                       # pdf-viewer
        sxiv                          # image viewer
        eog                           # another image viewer
        mpv                           # media player
        vlc                           # good old video player (X11)
        ffmpeg                        # THE cli video tool
        nautilus                      # gui file explorer
        imagemagick                   # cli image manipulation
        wf-recorder                   # screen recorder
        filezilla                     # ftp gui interface
        transmission_4-qt             # bittorrent client for file shareing
        prusa-slicer                  # slicer for 3d printing
        tor-browser                   # secure and anonymous browsing
        xournalpp                     # write on pdfs!
        obsidian                      # note taking
        gimp                          # image manipulation
        # krita                       # digital painting
        drawio                        # create diagrams
        # olive-editor                # video editor
        tidal-hifi                    # music streaming
        musescore                     # music notation
        audacity                      # audio editor
        hyprpicker                    # color picker
        discord                       # communication
        font-manager                  # font management
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
