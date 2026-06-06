{
  config,
  lib,
  pkgs,
  inputs,
  system ? pkgs.stdenv.hostPlatform.system,
  ...
}:
let
  cfg = config.feltnerm.developer.notes;

  /**
    Notes module for a lightweight writing-focused Neovim setup,
    plus optional journal and notebook sync helpers.
  */
  notesNixvimPkg = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    module = {
      globals = {
        mapleader = " ";
        maplocalleader = " ";
        netrw_banner = 0;
      };

      opts = {
        fileencoding = "utf-8";
        wrap = true; # writing-friendly: soft wrap
        linebreak = true;
        spell = true;
        spelllang = [ "en_us" ];
        list = true;
        listchars = {
          tab = "⇥ ";
          trail = "␣";
          nbsp = "⍽";
        };
        expandtab = true;
        shiftwidth = 2;
        softtabstop = 2;
        tabstop = 2;
        autoindent = true;
        breakindent = true;
        cursorline = true;
        number = true;
        relativenumber = false; # absolute numbers more useful for prose
        signcolumn = "auto";
        scrolloff = 4;
        termguicolors = true;
        title = true;
        updatetime = 100;
        ignorecase = true;
        incsearch = true;
        smartcase = true;
        splitbelow = true;
        splitright = true;
        backup = false;
        confirm = true;
        writebackup = false;
        undofile = true;
        undolevels = 10000;
        backspace = "eol,start,indent";
        mouse = "a";
      };

      keymaps = [
        {
          key = "<esc>";
          action = "<cmd>noh<CR>";
          options.desc = "clear search highlights";
        }
        {
          key = "B";
          action = "^";
          options.desc = "go to beginning of line";
        }
        {
          key = "E";
          action = "$";
          options.desc = "go to end of line";
        }
        {
          key = "jj";
          mode = "i";
          action = "<Esc>";
          options.desc = "";
        }
        {
          key = "jk";
          mode = "i";
          action = "<Esc>";
          options.desc = "";
        }
        {
          key = "<leader>sf";
          action = "<cmd>Telescope find_files<CR>";
          options.desc = "search notes files";
        }
        {
          key = "<leader>sg";
          action = "<cmd>Telescope live_grep<CR>";
          options.desc = "search text in notes";
        }
        {
          key = "<leader>sb";
          action = "<cmd>Telescope buffers<CR>";
          options.desc = "search buffers";
        }
        {
          key = "<leader>sr";
          action = "<cmd>Telescope oldfiles<CR>";
          options.desc = "search recent files";
        }
      ];

      plugins = {
        lz-n.enable = true;
        auto-save.enable = true;
        wrapping.enable = true;
        lualine.enable = true;
        web-devicons.enable = true;
        todo-comments.enable = true;

        markview = {
          enable = true;
          lazyLoad.settings.ft = "markdown";
        };

        telescope.enable = true;

        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            markdown
            markdown_inline
            yaml
            lua
          ];
        };

        lsp = {
          enable = true;
          servers = {
            marksman.enable = true;
            harper_ls.enable = true;
          };
        };

        blink-cmp = {
          enable = true;
          settings = {
            keymap.preset = "enter";
            sources.default = [
              "lsp"
              "path"
              "buffer"
            ];
            completion.documentation.auto_show = true;
          };
        };

        which-key = {
          enable = true;
          settings = {
            delay = 200;
            spec = [
              {
                __unkeyed-1 = "<leader>s";
                group = "Search";
                icon = "󰍉 ";
              }
            ];
          };
        };
      };
    };
  };

  notesVim = pkgs.writeShellScriptBin cfg.alias ''
    exec ${notesNixvimPkg}/bin/nvim "$@"
  '';

  syncSubmoduleType = lib.types.submodule (
    _:
    {
      options = {
        remote = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            rclone remote destination path for this item.
            When null, no sync commands or services are generated.
            Requires a configured rclone remote (set up manually via `rclone config`).
          '';
          example = "gdrive-personal:/Notes";
        };
        auto = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            When true, creates a background sync service
            (launchd agent on macOS, systemd timer on Linux).
            Requires `sync.remote` to be set.
          '';
        };
        interval = lib.mkOption {
          type = lib.types.int;
          default = 300;
          description = "Seconds between automatic syncs when `sync.auto` is enabled.";
          example = 600;
        };
      };
    }
  );

  syncNotebooks = lib.filter (n: n.sync.remote != null) cfg.notebooks;
  autoSyncNotebooks = lib.filter (n: n.sync.auto && n.sync.remote != null) cfg.notebooks;
  syncJournals = lib.filter (j: j.sync.remote != null) cfg.journals;
  autoSyncJournals = lib.filter (j: j.sync.auto && j.sync.remote != null) cfg.journals;

  mkSyncScript =
    prefix: item:
    pkgs.writeShellApplication {
      name = "${prefix}-sync-${item.name}";
      runtimeInputs = [ pkgs.rclone ];
      text = ''
        echo "Syncing ${prefix} ${item.name}: ${item.path} → ${item.sync.remote}"
        rclone sync \
          "${item.path}" \
          "${item.sync.remote}" \
          --progress \
          --transfers 4 \
          --checkers 8 \
          "$@"
        echo "Sync complete."
      '';
    };

  mkSyncAllScript =
    prefix: items:
    pkgs.writeShellApplication {
      name = "${prefix}-sync";
      runtimeInputs = map (mkSyncScript prefix) items;
      text = lib.concatMapStrings (item: ''
        echo "--- ${prefix} / ${item.name} ---"
        ${prefix}-sync-${item.name}
      '') items;
    };

  mkLaunchdAgent = prefix: item: {
    name = "${prefix}-sync-${item.name}";
    value = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.rclone}/bin/rclone"
          "sync"
          item.path
          item.sync.remote
          "--transfers"
          "4"
          "--checkers"
          "8"
        ];
        StartInterval = item.sync.interval;
        RunAtLoad = false;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${prefix}-sync-${item.name}.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${prefix}-sync-${item.name}-error.log";
      };
    };
  };

  mkSystemdService = prefix: item: {
    name = "${prefix}-sync-${item.name}";
    value = {
      Unit.Description = "Sync ${prefix}: ${item.name}";
      Service = {
        Type = "oneshot";
        ExecStart = lib.escapeShellArgs [
          "${pkgs.rclone}/bin/rclone"
          "sync"
          item.path
          item.sync.remote
          "--transfers"
          "4"
          "--checkers"
          "8"
        ];
      };
    };
  };

  mkSystemdTimer = prefix: item: {
    name = "${prefix}-sync-${item.name}";
    value = {
      Unit.Description = "Timer for ${prefix} sync: ${item.name}";
      Timer = {
        OnUnitActiveSec = "${toString item.sync.interval}s";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
in
{
  options.feltnerm.developer.notes = {
    enable = lib.mkEnableOption "notes";

    alias = lib.mkOption {
      type = lib.types.str;
      default = "nvim-notes";
      description = "Binary name for the minimal notes neovim editor.";
    };

    journals = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule (
          _:
          {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Journal identifier used by jrnl (e.g. \"default\", \"work\").";
                example = "default";
              };
              path = lib.mkOption {
                type = lib.types.str;
                description = ''
                  Path for this journal. If the path ends with `/`, jrnl uses one
                  file per entry (folder journal). Otherwise, all entries are
                  appended to a single file.
                '';
                example = "~/notes/journal/";
              };
              sync = lib.mkOption {
                type = syncSubmoduleType;
                default = { };
                description = "Sync configuration for this journal directory.";
              };
            };
          }
        )
      );
      default = [ ];
      description = ''
        Named jrnl journals. The first entry becomes the jrnl default journal.
        Each journal is reachable via `jrnl --journal <name>`.
        Set `editor` in jrnl via `programs.jrnl` - this module sets it to `cfg.alias` automatically.
      '';
      example = [
        {
          name = "default";
          path = "~/notes/journal/";
        }
        {
          name = "work";
          path = "~/work-notes/journal/";
        }
      ];
    };

    notebooks = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule (
          _:
          {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Notebook identifier, used in generated command names.";
              };
              path = lib.mkOption {
                type = lib.types.str;
                description = "Local directory path for notebook files.";
              };
              sync = lib.mkOption {
                description = "Sync configuration for this notebook.";
                default = { };
                type = syncSubmoduleType;
              };
            };
          }
        )
      );
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = builtins.all (n: builtins.match "^[a-zA-Z0-9_-]+$" n.name != null) cfg.notebooks;
            message = "feltnerm.developer.notes: notebook name contains invalid characters. Only letters, digits, hyphens, and underscores are allowed.";
          }
          {
            assertion = builtins.all (j: builtins.match "^[a-zA-Z0-9_-]+$" j.name != null) cfg.journals;
            message = "feltnerm.developer.notes: journal name contains invalid characters. Only letters, digits, hyphens, and underscores are allowed.";
          }
          {
            assertion = builtins.all (
              n: n.sync.remote == null || !n.sync.auto || n.sync.interval > 0
            ) cfg.notebooks;
            message = "feltnerm.developer.notes: notebook sync.auto requires sync.remote to be set and sync.interval must be positive.";
          }
          {
            assertion = builtins.all (
              j: j.sync.remote == null || !j.sync.auto || j.sync.interval > 0
            ) cfg.journals;
            message = "feltnerm.developer.notes: journal sync.auto requires sync.remote to be set and sync.interval must be positive.";
          }
        ];

        programs.jrnl = lib.mkIf (cfg.journals != [ ]) {
          enable = true;
          settings = {
            editor = cfg.alias;
            journals = lib.listToAttrs (
              map (j: {
                inherit (j) name;
                value = j.path;
              }) cfg.journals
            );
          };
        };

        home.activation = lib.mkIf (cfg.notebooks != [ ]) {
          notesNotebookDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] (
            lib.concatMapStringsSep "\n" (notebook: ''
              mkdir -p "${notebook.path}"
            '') cfg.notebooks
          );
        };

        home.packages = [
          notesVim
          pkgs.rclone
        ]
        ++ (map (mkSyncScript "notes") syncNotebooks)
        ++ (map (mkSyncScript "journal") syncJournals)
        ++ lib.optionals (syncNotebooks != [ ]) [ (mkSyncAllScript "notes" syncNotebooks) ]
        ++ lib.optionals (syncJournals != [ ]) [ (mkSyncAllScript "journal" syncJournals) ];

        launchd.agents = lib.mkIf pkgs.stdenv.isDarwin (
          lib.listToAttrs (
            (map (mkLaunchdAgent "notes") autoSyncNotebooks)
            ++ (map (mkLaunchdAgent "journal") autoSyncJournals)
          )
        );

        systemd.user = lib.mkIf pkgs.stdenv.isLinux {
          services = lib.listToAttrs (
            (map (mkSystemdService "notes") autoSyncNotebooks)
            ++ (map (mkSystemdService "journal") autoSyncJournals)
          );
          timers = lib.listToAttrs (
            (map (mkSystemdTimer "notes") autoSyncNotebooks)
            ++ (map (mkSystemdTimer "journal") autoSyncJournals)
          );
        };
      }
    ]
  );
}
