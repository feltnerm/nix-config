{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.feltnerm.programs.firefox;
in
{
  options.feltnerm.programs.firefox = {
    enable = lib.mkOption {
      description = "Enable Firefox";
      default = false;
    };
  };

  # TODO the nix firefox package does not work on isDarwin
  # note: ~Library/Application Support/Firefox/profiles.ini
  config = lib.mkIf (cfg.enable || !pkgs.stdenv.isDarwin) {
    home.packages = with pkgs; [
      firefox
    ];

    programs.firefox = {
      enable = true;
      # package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      #   forceWayland = true;
      #   extraPolicies = {
      #     ExtensionSettings = {};
      #   };
      # };
      profiles.mark = {
        id = 0;
        name = "Mark Feltner";
        settings =
          let
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
              # clipboard events: https://superuser.com/questions/1595994/dont-let-websites-overwrite-clipboard-in-firefox-without-explicitly-giving-perm
              # Breaks copy/paste on websites
              #"dom.event.clipboardevents.enabled" = false;
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
        # bookmarks = [];
        extraConfig = ""; # user.js
        userChrome = ''
          /* hides the native tabs */
          #TabsToolbar, #sidebar-header {
            visibility: none !important;
          }
        '';
        userContent = ""; # custom user content CSS
      };
    };
  };
}
