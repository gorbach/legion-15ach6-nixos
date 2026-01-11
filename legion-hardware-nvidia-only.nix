# Lenovo Legion 15ACH6 hardware configuration
# Configured for Nvidia-only mode (AMD iGPU disabled in BIOS)
{ config, lib, pkgs, ... }:

{
  # Do NOT import nixos-hardware Legion profile as it's for hybrid graphics
  # We're running Nvidia-only mode

  # Enable Nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use the latest stable Nvidia driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # REQUIRED: Enable modesetting (crucial for Wayland and VA-API)
    modesetting.enable = true;

    # Power management (optional, helps with battery life)
    powerManagement.enable = true;

    # REQUIRED for driver >= 560: Use open source kernel modules
    # Recommended by Nvidia for RTX 3050 (Ampere architecture)
    # Set to false if you experience any issues
    open = true;

    # Disable PRIME since we're not using hybrid graphics
    prime.offload.enable = false;
  };

  # CRITICAL: Kernel parameter for sleep/suspend with Nvidia
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "modprobe.blacklist=simpledrm"
  ];

  # Enable OpenGL/Vulkan hardware acceleration with Nvidia VA-API support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Nvidia VA-API driver for hardware video acceleration
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Environment variables for Nvidia VA-API in Firefox
  environment.sessionVariables = {
    # Force Nvidia driver instead of AMD 'radeonsi'
    LIBVA_DRIVER_NAME = "nvidia";

    # REQUIRED for Nvidia to work with Firefox directly
    NVD_BACKEND = "direct";

    # Firefox sandbox often blocks Nvidia drivers
    MOZ_DISABLE_RDD_SANDBOX = "1";

    # Enable Wayland for GNOME (you're using GDM/GNOME)
    MOZ_ENABLE_WAYLAND = "1";
  };
}
