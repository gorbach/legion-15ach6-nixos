# NixOS System Context for Claude

## System Overview

You are assisting with a **NixOS** system running on a **Lenovo Legion 15ACH6** laptop.

### Hardware Specifications
- **CPU**: AMD Ryzen (specific model TBD)
- **GPU**: NVIDIA GeForce RTX 3050 Laptop (PCI ID: 0x10de:0x25e2)
- **Display**: 4K (3840x2160) @ 60Hz
- **BIOS Mode**: Discrete Graphics Only (AMD iGPU disabled, NVIDIA-only mode)

### Graphics Configuration
- **Driver**: NVIDIA 580.119.02
- **Backend**: VA-API NVDEC direct backend
- **Display Server**: Wayland
- **Desktop Environment**: GNOME
- **Hardware Acceleration**: Firefox has hardware acceleration and WebRender force-enabled

## NixOS Configuration Structure

This system uses a **modular configuration approach**:

```
/etc/nixos/
├── configuration.nix              # Main system configuration
├── hardware-configuration.nix     # Auto-generated hardware config
├── packages.nix                   # Package management (system packages, fonts, shell config)
├── legion-hardware-nvidia-only.nix # NVIDIA-only hardware config (ACTIVE)
├── legion-hardware-hybrid.nix     # Hybrid mode config (NOT ACTIVE)
└── CLAUDE.md                      # This file
```

### Active Configuration Files

1. **configuration.nix**: Main system settings
   - Imports: hardware-configuration.nix, legion-hardware-nvidia-only.nix, packages.nix
   - System services, user accounts, networking, locale
   - Uses latest kernel: `boot.kernelPackages = pkgs.linuxPackages_latest`

2. **packages.nix**: Package and tool management
   - System packages (development tools, applications)
   - Font configuration
   - Shell configuration (bash init scripts)
   - Uses nixpkgs-unstable for bleeding-edge tools (Claude Code, Ghostty)

3. **legion-hardware-nvidia-only.nix**: NVIDIA-specific hardware configuration
   - Currently active (discrete graphics only mode)

## Installed Software & Tools

### Development Environment
- **IDEs**: JetBrains Rider, VS Code
- **.NET**: dotnet-sdk_10
- **Node.js**: nodejs_22, yarn
- **Nix Development**: nixd (LSP), nixpkgs-fmt

### Terminal & CLI Tools
- **Terminal**: Ghostty (bleeding edge, from unstable)
- **File Manager**: Yazi (with full optional dependencies)
  - Shell wrapper: `y` command (changes directory on exit)
  - Dependencies: ffmpeg, p7zip, jq, poppler-utils, fzf, zoxide, imagemagick
- **Editor**: Neovim (with NvChad build essentials)
- **Version Control**: git
- **AI Assistant**: Claude Code (from unstable)

### Build Tools
- gcc, gnumake, unzip
- ripgrep, fd (for file searching)

### Fonts
- JetBrains Mono Nerd Font (96 variants)
- Fira Code Nerd Font (18 variants)

## System Configuration Details

### User Account
- **Primary User**: `gor`
- **Groups**: networkmanager, wheel
- **Home Directory**: `/home/gor`

### System Settings
- **Hostname**: nixos
- **Timezone**: America/New_York
- **Locale**: en_US.UTF-8
- **Desktop Manager**: GNOME (via Wayland)
- **Display Manager**: GDM
- **Audio**: PipeWire (with ALSA and PulseAudio support)
- **Unfree Packages**: Enabled

### NixOS Version
- **State Version**: 25.11

## Important Preferences & Guidelines

### Configuration Philosophy
1. **Modular Structure**: Keep configuration files separated by purpose
   - Don't add everything to configuration.nix
   - Use packages.nix for package-related settings
   - Consider creating new module files for distinct concerns

2. **Nix-Native Solutions**: Always prefer NixOS configuration options over manual file editing
   - Use `programs.bash.interactiveShellInit` instead of editing ~/.bashrc
   - Use `fonts.packages` instead of manual font installation
   - Use system-level options that work without home-manager when possible

3. **Bleeding Edge**: Some tools come from nixpkgs-unstable
   - Claude Code
   - Ghostty terminal

### When Providing Help

1. **Hardware-Specific Considerations**:
   - Check nixos-hardware repository for Lenovo Legion best practices
   - Consider NVIDIA-specific configurations for Wayland
   - Remember: discrete graphics only (no hybrid mode)

2. **Firefox/Browser Issues**:
   - Hardware acceleration is force-enabled
   - Check about:support Decision Log for blocklists/failures first
   - VA-API NVDEC backend is in use

3. **Configuration Changes**:
   - Always maintain modular structure
   - Suggest which file to edit (usually packages.nix for new packages)
   - Provide complete, working Nix expressions
   - Remember to escape shell variables in Nix strings (use `''$` not `$`)

4. **Package Management**:
   - System packages go in packages.nix `environment.systemPackages`
   - Fonts go in packages.nix `fonts.packages`
   - Shell configuration goes in packages.nix `programs.bash.*`
   - Check if packages should come from stable or unstable

## Common Commands

```bash
# Rebuild system (apply configuration changes)
sudo nixos-rebuild switch

# Test configuration without changing boot default
sudo nixos-rebuild test

# Search for packages
nix search nixpkgs <package-name>

# Check system info
nixos-version

# Launch yazi with directory change on exit
y
```

## Known Issues & Notes

- System is newly configured (as of December 2025)
- Yazi rebuild may take time due to 7zz compilation from source (RAR support)
- Some GNOME configuration options have been renamed in recent NixOS versions (see warnings during rebuild)

## Quick Reference: File Editing

When asked to modify the system:
- **Add packages**: Edit `/etc/nixos/packages.nix` → `environment.systemPackages`
- **Add fonts**: Edit `/etc/nixos/packages.nix` → `fonts.packages`
- **Shell config**: Edit `/etc/nixos/packages.nix` → `programs.bash.*`
- **System services**: Edit `/etc/nixos/configuration.nix`
- **User settings**: Consider if it needs home-manager (currently NOT installed)

---

*This file helps Claude provide better, context-aware assistance. Update it as the system evolves.*
