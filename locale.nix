{ config, pkgs, ... }:

{
  # 1. System Language & Locales
  i18n.defaultLocale = "en_US.UTF-8";

  # Ensure the system generates the necessary locale data for Cyrillic support
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "uk_UA.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];

  # Optional: Keep the UI in English but use local formatting for dates/money
  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8"; # Or "uk_UA.UTF-8" if you want Ukrainian date formats
    LC_MONETARY = "uk_UA.UTF-8";
  };

  # 2. Keyboard Layouts
  # This sets the system-wide default (Login screen & X11/Wayland)
  services.xserver.xkb = {
    layout = "us,ua,ru";
    variant = ",,";
    options = "grp:alt_shift_toggle"; # Toggle with Alt + Shift
  };

  # 3. Console (TTY) Support
  # Makes sure you can type Ukrainian/Russian if the GUI fails to start
  console.useXkbConfig = true; 

  # 4. Cyrillic Font Support
  # Essential for professional rendering of UA/RU characters
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
  ];

  # 5. GNOME Input Sources Configuration
  # GNOME on Wayland manages input sources separately from XKB
  # This systemd service configures GNOME to show all keyboard layouts
  systemd.user.services.gnome-set-input-sources = {
    description = "Set GNOME input sources for keyboard layouts";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "set-input-sources" ''
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ua'), ('xkb', 'ru')]"
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']"
      '');
    };
  };
}
