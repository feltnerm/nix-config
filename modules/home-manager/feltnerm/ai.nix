{
  config,
  lib,
  ...
}:
let
  cfg = config.feltnerm.developer.ai;
in
{
  # Only apply when developer and AI are enabled
  config = lib.mkIf cfg.enable {

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
        agents = {
          explain = ''
            ---
            temperature: 0.3
            tools:
              write: false
              edit: false
              patch: false
            ---
            You are an expert explainer of complex technical concepts.
            Your goal is to break down complicated ideas into clear, concise, and easily understandable explanations.
            Use analogies and examples where appropriate.
          '';
          deep_thinker = ''
            ---
            temperature: 0.1
            maxSteps: 15
            tools:
              write: false
              edit: false
              patch: false
            ---
            You are a methodical and rigorous expert problem solver.
            For every request, you must first create a detailed, numbered step-by-step reasoning plan before arriving at a final, thoroughly checked answer.
            Show your work.
          '';
          code_reviewer = ''
            ---
            description: Reviews code for quality and best practices.
            temperature: 0.05
            tools:
              write: false
              edit: false
              patch: false
            ---

            You are a meticulous, objective Code Reviewer.
            Analyze the provided code for quality, performance, maintainability, and architectural fit.
            Provide a clear summary, then a line-by-line critique.
            Your tone must be constructive and professional.
          '';
          security_auditor = ''
            ---
            description: Audits and reviews code for security best practices.
            temperature: 0.0
            tools:
              write: false
              edit: false
              patch: false
            ---

            You are an expert Security Auditor specializing in OWASP Top 10 and language-specific vulnerabilities.
            Review the code for security flaws, buffer overflows, injection risks, and inadequate authentication/authorization.
            If a flaw is found, provide a fix and a detailed explanation of the vulnerability.
          '';
          technical_writer = ''
            ---
            description: Review and create documentation.
            temperature: 0.5
            ---

            You are a professional Technical Writer.
            Your goal is to generate clear, well-structured, and accurate documentation, comments, or explanations for the code or concept provided.
            Use appropriate Markdown headings and formatting.
          '';
          quick_thinker = ''
            ---
            description: Get a simple answer fast.
            temperature: 0.4
            tools:
              write: false
              edit: false
              patch: false
            ---

            You are a fast, high-level consultant.
            Provide concise, immediate feedback or a quick solution path, focusing on speed and simplicity.
            Limit your response to 3-5 sentences.
          '';
          creative_thinker = ''
            ---
            description: Suggest new ideas and approaches.
            temperature: 0.8
            tools:
              write: false
              edit: false
              patch: false
            ---

            You are a generative ideator and lateral thinker.
            Your primary goal is to provide at least three diverse and unconventional options for the user's request.
            Focus on architectural possibilities, creative solutions, and innovative approaches.
            Be bold.
          '';
        };
        settings = {
          model = lib.mkDefault "github-copilot/gpt-5";
          small_model = lib.mkDefault "github-copilot/claude-sonnet-4";
          agent = {
            build = { };
            plan = {
              model = lib.mkDefault "github-copilot/claude-sonnet-4.5";
            };
            explore = {
              model = lib.mkDefault "github-copilot/gpt-4o";
            };
            general = {
              model = lib.mkDefault "github-copilot/gpt-5";
            };
            explain = {
              mode = "primary";
              model = lib.mkDefault "github-copilot/gpt-5";
              reasoningEffort = lib.mkDefault "high";
              textVerbosity = lib.mkDefault "low";
            };
            deep_thinker = {
              mode = "subagent";
              model = lib.mkDefault "github-copilot/claude-sonnet-4.5";
            };
            code_reviewer = {
              mode = "subagent";
              model = lib.mkDefault "github-copilot/claude-sonnet-4.5";
            };
            security_auditor = {
              mode = "subagent";
              model = lib.mkDefault "github-copilot/gpt-5";
            };
            technical_writer = {
              mode = "subagent";
              model = lib.mkDefault "github-copilot/claude-sonnet-4.5";
            };
            quick_thinker = {
              mode = "subagent";
              model = lib.mkDefault "github-copilot/claude-sonnet-4";
            };
            creative_thinker = {
              mode = "subagent";
              model = lib.mkDefault "github-copilot/gpt-4o";
            };
          };
        };
      };
    };
  };
}
