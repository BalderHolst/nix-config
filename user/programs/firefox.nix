{ inputs, pkgs, config, lib, ... }:
{

    options.firefox.username = lib.mkOption { type = lib.types.str; };

    config.programs.firefox = {
        enable = true;
        profiles."${config.firefox.username}" = {
            bookmarks = [
                {
                    name = "Nixos Packages";
                    tags = [ "nixos" ];
                    keyword = "nixpkgs";
                    url = "https://search.nixos.org/packages";
                }
                {
                    name = "SDU Email";
                    tags = [ "school" ];
                    keyword = "sdu";
                    url = "https://outlook.office.com/";
                }
                {
                    name = "SDU Itslearning";
                    tags = [ "school" ];
                    keyword = "itslearning";
                    url = "https://sdu.itslearning.com/";
                }
            ];
            search.engines = {
                "Nix Packages" = {
                    urls = [{
                        template = "https://search.nixos.org/packages";
                        params = [
                            { name = "type"; value = "packages"; }
                            { name = "query"; value = "{searchTerms}"; }
                        ];
                    }];
                    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    definedAliases = [ "!np" "!nix" "!nixpkgs" ];
                };
                "Crates.io" = {
                    urls = [{
                        template= "https://crates.io/search";
                        params = [
                            { name = "q"; value = "{searchTerms}"; }
                        ];
                    }];
                    icon = builtins.fetchurl {
                      url = "https://crates.io/assets/cargo.png";
                      sha256 = "sha256:1x254p99awa3jf1n617dn997aw44qv41jkfinhfdg9d3qblhkkr6";
                    };
                    definedAliases = [ "!rust" "!cargo" "!crate" "!crates" ];
                };
                "PyPI" = {
                    urls = [{
                        template= "https://pypi.org/search";
                        params = [
                            { name = "q"; value = "{searchTerms}"; }
                        ];
                    }];
                    icon = builtins.fetchurl {
                      url = "https://pypi.org/static/images/logo-small.2a411bc6.svg";
                      sha256 = "sha256:12ydpzmbc1a2h4g1gjk8wi02b3vkfqg84zja2v4c403iqdyi5xzr";
                    };
                    definedAliases = [ "!py" "!pip" "!pypi" ];
                };
                "ProtonDB" = {
                    urls = [{
                        template= "https://www.protondb.com/search";
                        params = [
                            { name = "q"; value = "{searchTerms}"; }
                        ];
                    }];
                    icon = builtins.fetchurl {
                      url = "https://www.protondb.com/sites/protondb/images/favicon-32x32.png";
                      sha256 = "sha256:06fa36flrakdrkywvayqzcqid8g3mdq05f61r2mj05lfjmh3cygv";
                    };
                    definedAliases = [ "!proton" ];
                };
                "Thangs" = {
                    urls = [{
                        template= "https://thangs.com/search/{searchTerms}";
                        params = [
                            { name = "scope"; value = "all"; }
                        ];
                    }];
                    icon = builtins.fetchurl {
                      url = "https://thangs.com/favicon.ico";
                      sha256 = "sha256:0l9f39ym5ivr5b44mksa2fi22ip4wfy8jy5fgf0dsv23yh4aaydn";
                    };
                    definedAliases = [ "!thangs" ];
                };
                "YouTube" = {
                    urls = [{
                        template= "https://www.youtube.com/results";
                        params = [
                            { name = "search_query"; value = "{searchTerms}"; }
                        ];
                    }];
                    icon = builtins.fetchurl {
                      url = "https://www.youtube.com/favicon.ico";
                      sha256 = "sha256:07cip1niccc05p124xggbmrl9p3n9kvzcinmkpakcx518gxd1ccb";
                    };
                    definedAliases = [ "!y" "!you" "!youtube" ];
                };
            };
            search.force = true;
            extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
                ublock-origin
                vimium
            ];
        };
    };
}
