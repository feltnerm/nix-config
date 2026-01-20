{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm.developer.ai;
in
{
  # Only apply when developer and AI are enabled
  config = lib.mkIf cfg.enable {

    programs.git = lib.mkIf config.programs.git.enable {
      ignores = [
        ".opencode"
        ".aider"
      ];
    };

    home.packages = with pkgs; [
      spec-kit
    ];

    services = {
      ollama = {
        # fails on aarm64-darwin
        enable = lib.mkDefault false;
      };
    };

    programs = {
      # OpenCode CLI configuration and agents
      opencode = {
        enable = lib.mkDefault true;
        agents = { };
        settings = {

          agent = {
            # primary agents
            # built-in
            build = {
              model = lib.mkDefault "github-copilot/claude-sonnet-4.5";
              reasoningEffort = lib.mkDefault "medium";
              textVerbosity = lib.mkDefault "low";
            };
            plan = {
              model = lib.mkDefault "github-copilot/gpt-5";
              reasoningEffort = lib.mkDefault "high";
              textVerbosity = lib.mkDefault "low";
            };

            # sub-agents
            # built-in
            explore = {
              model = lib.mkDefault "github-copilot/gpt-4o";
            };
            general = {
              model = lib.mkDefault "github-copilot/gpt-5";
            };
          };
        };
      };
    };
  };
}
