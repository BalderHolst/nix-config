{ builtins }:
{
  lake = {
    background = "#070A1C";
    foreground = "#E3DFD6";
    primary = "#80A0AA";
    secondary = "#10303A";
    alert = "#A54242";
    disabled = "#707880";
    wallpaper = builtins.fetchurl {
            url = "https://free4kwallpapers.com/uploads/originals/2020/07/22/minimal-landscape-black-and-white-wallpaper.png";
            sha256 = "sha256:1lcv6naa0p5p3d3a69yymrhz72r2i0y74y1drl6amyswi16p0sdn";
        };
    # Mirror: https://wallpapers.com/images/high/landscape-white-minimalist-d0h9lllw9ds8g39m.webp
  };
}
