{ config, pkgs, ... }:

let
  # Define the 'unstable' source.
  # This allows us to pull specific tools (like Claude) from the latest daily builds
  # while keeping the rest of your system on the stable release.
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
    config = { allowUnfree = true; };
  };
in
{
  # Optimize storage and automatic garbage collection
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # 1. Allow proprietary software
  # Required for: Rider, VS Code, Claude Code
  nixpkgs.config.allowUnfree = true;

  # 2. List of Packages
  environment.systemPackages = with pkgs; [
    # --- Core Tools ---
    git
    gh
    vscode

    zip
    unzip
    p7zip
    icu

    # --- Applications ---
    telegram-desktop
    slack
    spotify
    obsidian
    super-productivity
    syncthing
    youtube-music          # Pear Desktop (YouTube Music client)
    dbeaver-bin            # Database management tool
    onlyoffice-desktopeditors # ONLYOFFICE Desktop Editors (binary)

    # --- .NET Development ---
    jetbrains.rider
    dotnet-sdk_10
    
    # --- Nix Development ---
    nixd             # Language Server (autocompletion)
    nixpkgs-fmt      # Formatter
    
    # --- Node.js Ecosystem ---
    nodejs_22
    yarn             # Recommended: npm install -g often fails on NixOS

    # --- Python ---
    python3
    python3Packages.pip

    # --- Enhanced CLI Tools ---
    lazygit           # Terminal UI for git
    sourcegit         # GUI client for Git
    btop              # System monitor
    tldr              # Simplified man pages
    eza               # Modern ls replacement
    bat               # Cat with syntax highlighting

    # --- Fish Shell Plugins ---
    fishPlugins.tide  # Modern prompt theme for Fish


    # --- Bleeding Edge Tools ---
    # We install Claude from 'unstable' so you get the latest updates
    unstable.claude-code

    # --- AI Coding Assistants ---
    codex                  # OpenAI Codex CLI
    opencode               # AI coding assistant

    # --- PowerShell ---
    powershell             # Microsoft PowerShell

    # --- Docker ---
    docker-compose         # Docker Compose

    unstable.ghostty       # Bleeding edge terminal for Wayland
    neovim                 # Base Neovim package

    # --- Yazi File Manager ---
    (yazi.override {
      _7zz = _7zz-rar;     # Enable RAR extraction support
    })

    # Yazi optional dependencies for enhanced functionality
    ffmpeg               # Video thumbnails
    p7zip                # Archive extraction
    jq                   # JSON preview
    poppler-utils        # PDF preview
    fzf                  # Fuzzy file searching
    zoxide               # Smart directory navigation
    imagemagick          # Font and image preview

    # Build essentials for NvChad (Treesitter, etc.)
    fontconfig
    freetype
    pkg-config
    gcc
    gnumake
    unzip
    ripgrep
    fd

    tor-browser

    # gnome
    # --- GNOME Customization Tools ---
    gnome-tweaks          # Essential tool for fonts, themes, and windows
    gnome-extension-manager # Better than the browser extension website

    # --- Essential Extensions ---
    gnomeExtensions.dash-to-dock    # Turns the dash into a permanent dock (macOS style)
    gnomeExtensions.appindicator    # Adds system tray icons (Discord, Steam, etc.)
    gnomeExtensions.blur-my-shell   # Adds nice blur effects to the shell
    gnomeExtensions.just-perfection # deeply customize UI (hide search, move clock, etc.)
  ];

  # 3. Fonts Configuration
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
  ];

  # 4. Fish Shell Configuration
  programs.fish = {
    enable = true;

    # Shell initialization for interactive sessions
    interactiveShellInit = ''
      # Disable fish greeting
      set -g fish_greeting

      # Yazi shell wrapper - allows changing directory on exit
      # Usage: Use 'y' instead of 'yazi' to launch the file manager
      # Press 'q' to quit and change to the last directory
      # Press 'Q' to quit without changing directory
      function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      end

      # Modern CLI tool abbreviations
      # These expand when you type them, showing the actual command
      abbr -a ls 'eza --icons'
      abbr -a ll 'eza -l --icons --git'
      abbr -a la 'eza -la --icons --git'
      abbr -a lt 'eza --tree --icons'
      abbr -a cat 'bat'
    '';

    # Shell environment setup (runs for all fish sessions)
    shellInit = ''
      # Add npm global bin to PATH
      fish_add_path $HOME/.npm-global/bin
    '';
  };

  # 5. Bash Configuration (kept as fallback)
  # Note: Fish is now the default shell, but bash remains available for scripts
  programs.bash.interactiveShellInit = ''
    # Minimal bash config for system scripts and fallback use
    export PATH="$HOME/.npm-global/bin:$PATH"
  '';

  # 6. NPM Global Packages Configuration
  environment.sessionVariables.NPM_CONFIG_PREFIX = "$HOME/.npm-global";

  # Remove default GNOME applications
  environment.gnome.excludePackages = with pkgs; [
    gnome-console       # The default GNOME terminal (sometimes called 'kgx')
    gnome-terminal      # The legacy terminal (good to exclude just in case)
    epiphany            # The default GNOME web browser (GNOME Web)
    gnome-tour          # The "Welcome to GNOME" tour app
  ];

  # Enable the connector so you can install other extensions from the browser if needed
  services.gnome.gnome-browser-connector.enable = true;
}
