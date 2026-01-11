# NuPhy Air Keyboard Configuration
{ config, lib, pkgs, ... }:

{
  # Make function keys default to F-keys instead of media keys
  boot.kernelParams = [ "hid_apple.fnmode=2" ];

  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';
}
