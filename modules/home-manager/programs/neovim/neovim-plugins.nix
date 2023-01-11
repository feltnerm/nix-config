{
  pkgs,
  lib,
  ...
}: {
  "vim-denops/denops.vim" = pkgs.vimUtils.buildVimPlugin {
    name = "denops.vim";
    buildInputs = [pkgs.perl];
    buildPhase = "echo 'hello'";
    src = pkgs.fetchFromGitHub {
      owner = "vim-denops";
      repo = "denops.vim";
      rev = "v3.4.2";
      sha256 = "sha256-0TBrI7dvG/JlJ7Ni+MNylcAxwG8rw1J6jMydrBYTA6A=";
    };
  };

  "vim-denops/denops-helloworld.vim" = pkgs.vimUtils.buildVimPlugin {
    name = "denops-helloworld.vim";
    # buildInputs = [pkgs.perl];
    buildPhase = "echo 'hello'";
    src = pkgs.fetchFromGitHub {
      owner = "vim-denops";
      repo = "denops-helloworld.vim";
      rev = "v2.0.0";
      sha256 = "sha256-nbeSKGRNZ/XV8B6CQc5wE6rn8GPFOVDVM8vxKCSrVHM=";
    };
  };

  "Shougo/ddu.vim" = pkgs.vimUtils.buildVimPlugin {
    name = "Shougo/ddu.vim";
    # buildInputs = [pkgs.deno];
    buildPhase = "echo 'hello'";
    src = pkgs.fetchFromGitHub {
      owner = "Shougo";
      repo = "ddu.vim";
      rev = "v2.1.0";
      sha256 = "sha256-gKiDhXj+n3e1XisxNAw+Y+E2fqIfJYlZH0IoO/q8yjg=";
    };
  };

  "Shougo/ddu-ui-ff" = pkgs.vimUtils.buildVimPlugin {
    name = "Shougo/ddu-ui-ff";
    # buildInputs = [pkgs.deno];
    buildPhase = "echo 'hello'";
    src = pkgs.fetchFromGitHub {
      owner = "Shougo";
      repo = "ddu-ui-ff";
      rev = "15bf4602cb10f4816878c6b7f49a020c6fb4f28b";
      sha256 = "sha256-2xxAsA+GVxxuIqrJCLdK03ecK2Mf1P2uNEW4JWQk58k";
    };
  };

  "Shougo/ddu-kind-file" = pkgs.vimUtils.buildVimPlugin {
    name = "Shougo/ddu-kind-file";
    # buildInputs = [pkgs.deno];
    buildPhase = "echo 'hello'";
    src = pkgs.fetchFromGitHub {
      owner = "Shougo";
      repo = "ddu-kind-file";
      rev = "v0.3.2";
      sha256 = "sha256-2xxAsA+GVxxuIqrJCLdK03ecK2Mf1P2uNEW4JWQk58k";
    };
  };

  "Shougo/ddu-matcher_substring" = pkgs.vimUtils.buildVimPlugin {
    name = "Shougo/ddu-fitler-matcher_substring";
    # buildInputs = [pkgs.deno];
    buildPhase = "echo 'hello'";
    src = pkgs.fetchFromGitHub {
      owner = "Shougo";
      repo = "ddu-filter-matcher_substring";
      rev = "21cd289ea5d6ed7b57bed6d96df8dff2027ae6d9";
      sha256 = lib.fakeHash;
    };
  };

  "shun/ddu-source-rg" = pkgs.vimUtils.buildVimPlugin {
    name = "shun/ddu-source-rg";
    src = pkgs.fetchFromGitHub {
      owner = "shun";
      repo = "ddu-source-rg";
      rev = "313186643f430beb125c092455821113430f5088";
      sha256 = "sha256-yg8zubi0t/bj7BmSolG+/mHSnpQb8zl51txJR79i55U=";
    };
  };

  "shun/ddu-source-buffer" = pkgs.vimUtils.buildVimPlugin {
    name = "shun/ddu-source-buffer";
    src = pkgs.fetchFromGitHub {
      owner = "shun";
      repo = "ddu-source-buffer";
      rev = "feb15531ae08ec39eb162b3e6dcdb78ce77f6668";
      sha256 = "sha256-soUfrWsIkx8ECmE90E8vXwwvtipl6UMQHSC6P2Aww34=";
    };
  };
}
