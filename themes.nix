{
  lake = {
    background = "070A1C";
    foreground = "E3DFD6";
    primary = "80A0AA";
    secondary = "10303A";
    alert = "A54242";
    disabled = "707880";
    focus = "80C0FF";
    wallpaper = builtins.fetchurl {
      url = "https://free4kwallpapers.com/uploads/originals/2020/07/22/minimal-landscape-black-and-white-wallpaper.png";
      sha256 = "sha256:1lcv6naa0p5p3d3a69yymrhz72r2i0y74y1drl6amyswi16p0sdn";
    };
    # Mirror: https://wallpapers.com/images/high/landscape-white-minimalist-d0h9lllw9ds8g39m.webp
  };

  firewatch = rec {
    background = "201022";
    foreground = "FFFED8";
    primary = "FFA030";
    secondary = "6B202C";
    alert = "A54242";
    disabled = "68595D";
    focus = foreground;
    wallpaper = builtins.fetchurl {
      url = "https://images.hdqwalls.com/download/firewatch-game-2560x1440.jpg";
      sha256 = "sha256:03xx867vf4mhcnbqzv8dalj9x19y4l3pzy585vbkwxn5vq4rw55b";
    };
  };
}
