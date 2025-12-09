{ user, inputs, pkgs, config, lib, ... }:
let
    extra-extensions.rys = inputs.firefox-addons.lib."x86_64-linux".buildFirefoxXpiAddon {
        pname = "RYS — Remove YouTube Suggestions";
        version = "4.3.54";
        addonId = "c7ad48bb-c7f5-42ec-8882-3b65f955c225";
        url = "https://addons.mozilla.org/firefox/downloads/file/4246711/remove_youtube_s_suggestions-4.3.54.xpi";
        sha256 = "sha256-1OqTBaa+9yul7Py3DgZYl14PI61mRAndrf88l7HsX84=";
        meta = with lib; {
            homepage = "https://prod.outgoing.prod.webservices.mozgcp.net/v1/f0c080567cceb13a165ec97ae4e7b0444fad901efa22634c1f89a5ae3b23f94d/https%3A//github.com/lawrencehook/remove-youtube-suggestions";
            description = "Stop the YouTube rabbit hole. Customize YouTube's user interface to be less engaging.";
            license = licenses.mpl20;
            platforms = platforms.all;
          };
    };
in
{

    options.firefox = {
        username = lib.mkOption { type = lib.types.str; };
        theme = lib.mkOption {
            type = lib.types.str;
            default = "default";
        };
    };

    config.programs.firefox =
    let
        theme = import (./themes/${config.firefox.theme}.nix) { inherit pkgs lib; };
    in
    {
        enable = true;

        policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
                Value= true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
            };
            DisablePocket = true;
            DisableFirefoxAccounts = true;
            DisableAccounts = true;
            DisableFirefoxScreenshots = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DontCheckDefaultBrowser = true;
            DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
            DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
            SearchBar = "unified"; # alternative: "separate"

            /* ---- EXTENSIONS ---- */
            # Check about:support for extension/add-on ID strings.
            # Valid strings for installation_mode are "allowed", "blocked",
            # "force_installed" and "normal_installed".
            ExtensionSettings = {
                "*".installation_mode = "allowed";
                # "uBlock0@raymondhill.net" = {
                #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                #     installation_mode = "force_installed";
                # };
            };
        };

        profiles.default = {
            bookmarks = {
                    force = true;
                    settings = [
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
            };
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
                    definedAliases = [ "!cargo" "!crate" "!crates" ];
                };
                "rust-lang-std" = {
                    urls = [{
                        template= "https://doc.rust-lang.org/std/";
                        icon = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/rust-lang/rust-artwork/bf0b3272f9ba8d22f7fd45e408496d05621b3b5c/logo/rust-logo-blk.svg";
                            sha256 = "sha256:18kcl3libfj6xjxd6i2an487n70jp3qrk0hbc4xfqkfk0bm4k5cs";
                        };
                        params = [
                            { name = "search"; value = "{searchTerms}"; }
                        ];
                    }];
                    definedAliases = [ "!rust" ];
                };
                "PyPI" = {
                    urls = [{
                        template= "https://pypi.org/search";
                        params = [
                            { name = "q"; value = "{searchTerms}"; }
                        ];
                    }];
                    icon = builtins.fetchurl {
                        url = "https://pypi.org/static/images/logo-small.8998e9d1.svg";
                      sha256 = "sha256:02azs1k7prj7f305xqdy7l4aldk3saczx1pvxvl6dp9x67glyiww";
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
                "youtube" = {
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
                "PriceRunner" = {
                    urls = [{
                        template= "https://www.pricerunner.dk/results";
                        params = [
                            { name = "q"; value = "{searchTerms}"; }
                        ];
                    }];
                    icon = builtins.fetchurl {
                      url = "https://owp.klarna.com/images/i/pricerunner_favicon_black.ico";
                      sha256 = "sha256:0l3c7a8p9f8dn4kyrk6h0glr98mzgjwsvqzy2rz92fn2q1qf51ny";
                    };
                    definedAliases = [ "!pr" "!price" "!pricerunner" ];
                };
                "drtv" = {
                    urls = [{
                        template= "https://www.dr.dk/drtv/soeg";
                        params = [
                            { name = "q"; value = "{searchTerms}"; }
                        ];
                    }];
                    definedAliases = [ "!drtv" ];
                };
            };
            search.force = true;
            extensions.packages = [
                inputs.firefox-addons.packages."x86_64-linux".ublock-origin
                inputs.firefox-addons.packages."x86_64-linux".sponsorblock
                inputs.firefox-addons.packages."x86_64-linux".return-youtube-dislikes
                extra-extensions.rys
            ];
            userChrome = ''
                @import "${theme.userChrome}";
            '';
            userContent = ''
                @import "${theme.userChrome}";
            '';
            extraConfig = theme.userJs;
            settings = {
               "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
               "xpinstall.signatures.required" = false; # Make extensions work
               # "browser.uidensity" = 0; # Set UI density to normal
               # "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
            };
        };
    };
}
