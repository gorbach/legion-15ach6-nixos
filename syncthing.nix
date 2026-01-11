{ config, pkgs, ... }:

{
  # Syncthing - Continuous file synchronization
  services.syncthing = {
    enable = true;
    user = "gor";
    dataDir = "/home/gor/share/syncthing";
    configDir = "/home/gor/.config/syncthing";
    openDefaultPorts = true;  # Opens TCP/UDP ports for syncing with other devices
    guiAddress = "127.0.0.1:8384";  # Web GUI accessible at http://localhost:8384

    # Optional: Configure devices and folders declaratively
    # Or leave this commented to configure everything via the web GUI
    # settings = {
    #   devices = {
    #     "device-name" = {
    #       id = "DEVICE-ID-XXXXX";
    #     };
    #   };
    #   folders = {
    #     "Documents" = {
    #       path = "/home/gor/Documents";
    #       devices = [ "device-name" ];
    #     };
    #   };
    # };
  };
}
