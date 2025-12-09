{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.feltnerm.home.firefox;

  baseSettings = let
    newTab = {
      "browser.newtabpage.activity-stream.feeds.topsites" = true;
      "browser.newtabpage.activity-stream.feeds.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
      "browser.newtabpage.activity-stream.feeds.highlights.includePocket" = false;
      "browser.newtabpage.activity-stream.section.highights.includePocket" = false;
      "browser.newtabpage.activity-stream.showSearch" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
    };

    searchBar = {
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    };

    telemetry = {
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.ping-centre.telemetry" = false;
      "toolkit.telemetry.reportingpolicy.firstRun" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "app.shield.optoutstudies.enable" = false;
    };

    domPrivacy = {
      # "dom.event.clipboardevents.enabled" = false; # breaks copy/paste in places
      "dom.battery.enabled" = false;
    };

    https = {
      "dom.security.https_only_mode" = true;
      "dom.security.https_only_mode_ever_enabled" = true;
    };

    graphics = {
      "media.ffmpeg.vaapi.enabled" = true;
      "media.rdd-ffmpeg.enabled" = true;
      "media.navigator.mediadataencoder_vpx_enabled" = true;
    };

    general_settings = {
      "widget.use-xdg-desktop-portal.file-picker" = 2;
      "widget.use-xdg-desktop-portal.mime-handler" = 2;
      "browser.aboutConfig.showWarning" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.toolbars.bookmarks.visibility" = "newtab";
      "browser.urlbar.showSearchSuggestionsFirst" = false;
      "extensions.htmlaboutaddons.inline-options.enabled" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "extensions.pocket.enabled" = false;
      "browser.fullscreen.autohide" = false;
    };

    passwords = {
      "signon.autofillForms" = false;
      "signon.firefoxRelay.feature" = false;
      "signon.generation.enabled" = false;
      "signon.management.page.breach-alerts.enabled" = false;
      "signon.rememberSignons" = false;
    };

    downloads = {
      "browser.download.useDownloadDir" = false;
    };
  in
    general_settings
    // https
    // newTab
    // searchBar
    // domPrivacy
    // telemetry
    // graphics
    // passwords
    // downloads;

  webAppDefaults = {
    "browser.tabs.inTitlebar" = 0;
    "browser.link.open_newwindow" = 3;
    "browser.toolbars.bookmarks.visibility" = "never";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };

  mkProfileSettings = profile:
    baseSettings
    // (lib.optionalAttrs profile.isWebApp webAppDefaults)
    // (profile.settings or {});

in {
  options.feltnerm.home.firefox = {
    baseSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = baseSettings;
      description = "Base Firefox settings applied to all profiles.";
    };

    webAppDefaults = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = webAppDefaults;
      description = "Settings applied to web app profiles in addition to base settings.";
    };

    profiles = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
          id = lib.mkOption {
            type = lib.types.int;
            description = "Profile ID (0 reserved for 'mark').";
          };
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
            description = "Display name for the profile.";
          };
          isDefault = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether this is the default Firefox profile.";
          };
          isWebApp = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether this profile is for a sandboxed web app.";
          };
          url = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Launch URL for web app profiles.";
          };
          settings = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = {};
            description = "Profile-specific settings merged last.";
          };
          userChrome = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Custom CSS for browser chrome (userChrome.css).";
          };
          userContent = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Custom CSS for content (userContent.css).";
          };
          createDesktopEntry = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to create a desktop entry for this profile (future).";
          };
        };
      }));
      default = {
        mark = {
          id = 0;
          name = "Mark Feltner";
          isDefault = true;
          settings = {};
          userChrome = ''
            /* hides the native tabs */
            #TabsToolbar, #sidebar-header {
              visibility: none !important;
            }
          '';
          userContent = "";
        };
      };
      description = "Firefox profiles configuration (declarative).";
    };
  };

  # Only configure Firefox on non-Darwin platforms
  config = lib.mkIf (config.programs.firefox.enable && !pkgs.stdenv.isDarwin) {
    home.packages = with pkgs; [ firefox ];

    programs.firefox = {
      # package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      #   forceWayland = true;
      #   extraPolicies = {
      #     ExtensionSettings = {};
      #   };
      # };
      profiles = lib.mapAttrs (
        pname: p:
          {
            id = p.id;
            name = p.name;
            isDefault = p.isDefault;
            settings = mkProfileSettings p;
            extraConfig = ""; # user.js
            userChrome = p.userChrome;
            userContent = p.userContent;
          }
      ) cfg.profiles;
    };
  };
}
