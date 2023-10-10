{ config, pkgs, unstablePkgs, name, githubUser, email, graphical, editor, vaultAddr, ...
}: {
  targets.genericLinux.enable = true;
  home = {
    stateVersion = "23.05";
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";

    file = {
      ".local/bin" = { source = ./scripts; };
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
        XDG_SRC_DIR = "${config.home.homeDirectory}/Code";
        XDG_SCRIPTS_DIR = "${config.home.homeDirectory}/.local/bin";
    };
  };  
  
  xdg.configFile = {
    "nvim/lua" = {
      enable = editor;
      recursive = true;
      source = ./nvim/lua;
    };

    "wezterm/" = {
      enable = graphical;
      recursive = true;
      source = ./wezterm;
    };
  };

  xdg.dataFile = {
    ".local" = {
      enable = editor;
      recursive = true;
      source = ./scripts;
    };
  };



  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    cilium-cli
    go
    packer
    ansible
    unstablePkgs.clusterctl
    entr
    file
    gnumake
    gum
    htop
    jq
    k9s
    krew
    kubectl
    kubernetes-helm
    ovftool
    nixfmt
    ranger
    ripgrep
    shellcheck
    shfmt
    sops
    sysz
    tealdeer
    tmux
    unstablePkgs.awscli2
    unstablePkgs.fira-code-nerdfont
    vault
    whois
  ];

  programs = {
    home-manager.enable = true;
    bat.enable = true;

    ssh = { forwardAgent = true; };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    bash = {
      enable = true;
      sessionVariables = {
        EDITOR = "nvim";
        VAULT_ADDR = "https://it-vault.dwavesys.local";
        LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
        PATH = "$PATH:$HOME/.krew/bin:$HOME/.local/bin";
      };
    };

    zsh = {
      enable = true;
      enableVteIntegration = true;
      completionInit = "autoload -U compinit && compinit";
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      shellAliases = {
        la = "ls -la";
        ip = "ip --color=auto";
        k = "kubectl";
        tf = "terraform";
      };

      sessionVariables = {
        EDITOR = "nvim";
        VAULT_ADDR = vaultAddr;
        LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
        PATH = "$PATH:$HOME/.tfenv/bin:$HOME/.krew/bin:$HOME/.local/bin:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
      };

      oh-my-zsh = {
        enable = true;
        theme = "awesomepanda";
      };

      dirHashes = {
        Code = "$HOME/Code";
        work = "$HOME/Code/git.dwavesys.local";
        nix = "$HOME/Code/github.com/${githubUser}/nixos-config";
        dl = "$HOME/Downloads";
      };

    };

    tmux = {
      enable = true;
      extraConfig = builtins.readFile tmux/tmux.conf;
    };

    neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      withPython3 = true;
      extraPackages = with pkgs; [
        git
        gopls
        nodePackages.bash-language-server
        ripgrep
        shfmt
        terraform-ls
      ];

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter
        nvim-treesitter-parsers.nix
        nvim-treesitter-parsers.go
        nvim-treesitter-parsers.hcl
        nvim-treesitter-parsers.bash
        nvim-treesitter-parsers.yaml
        nvim-treesitter-parsers.terraform
        nvim-treesitter-parsers.lua
        nvim-treesitter-parsers.json
        vimwiki
        luasnip
        auto-pairs
        auto-save-nvim
        neoformat
        neomake
        nerdcommenter
        nvim-lspconfig
        papercolor-theme
        catppuccin-nvim
        plenary-nvim
        popup-nvim
        project-nvim
        nvim-cmp
        cmp-nvim-lsp
        telescope-file-browser-nvim
        telescope-fzy-native-nvim
        telescope-nvim
        undotree
        vim-fugitive
        vim-nix
        telescope-project-nvim
      ];

      extraLuaConfig = builtins.readFile nvim/init.lua;
    };

    wezterm = {
      enable = false; # TODO: set to 'graphical' when wezterm is patched for wayland
      package = unstablePkgs.wezterm;
      extraConfig = builtins.readFile wezterm/wezterm.lua;
    };

    chromium = {
      enable = graphical;
      package = pkgs.brave;
      extensions = [
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
        { id = "bfogiafebfohielmmehodmfbbebbbpei"; }
        { id = "nngceckbapebfimnlniiiahkandclblb"; }
      ];
    };

    git = {
      enable = true;
      aliases = {
        co = "checkout";
        c = "commit";
        s = "status";
        ss = "snapshot";
        sp = "safe-pull";
        rl = "remote-log";
        sb = "switch-to-branch";
      };

      userName = name;
      userEmail = email;
      signing = {
        key = "~/.ssh/id_ed25519";
        signByDefault = true;
      };

      extraConfig = {
        core = {
          editor = "nvim";
          pager = "bat";
        };

        gpg = {
          format = "ssh";
          ssh = { allowedSignersFile = "~/.config/git/allowed_signers"; };
        };

        init = { defaultBranch = "main"; };
      };
    };
  };
}

