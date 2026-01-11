# Lenovo Legion 15ACH6 hardware configuration
# This file imports the nixos-hardware profile for optimal hardware support
{ config, lib, pkgs, ... }:

{
  imports = [
    # Official nixos-hardware configuration for Legion 15ACH6
    # Includes: AMD CPU/GPU, NVIDIA GPU with PRIME, HiDPI, thermal management, SSD optimizations
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/legion/15ach6"
  ];

  # Enable OpenGL/Vulkan hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Drivers for AMD (Integrated GPU - recommended for browser)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Environmental variables to force Firefox to behave
  environment.sessionVariables = {
    # This is often necessary for VA-API to work in Firefox
    MOZ_DISABLE_RDD_SANDBOX = "1";
    # Force usage of the AMD driver (usually 'radeonsi')
    LIBVA_DRIVER_NAME = "radeonsi";
  };
}
