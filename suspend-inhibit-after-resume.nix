# Workaround for "resume -> immediate suspend again" loops.
# Adds a short grace period after resume where suspend is blocked.
{ config, pkgs, ... }:

let
  inhibitSeconds = 60;
  systemdInhibit = "${config.systemd.package}/bin/systemd-inhibit";
  sleep = "${pkgs.coreutils}/bin/sleep";
in
{
  systemd.services.inhibit-suspend-after-resume = {
    description = "Temporarily inhibit suspend after resume";

    # post-resume.target is triggered after waking from suspend/hibernate
    # (see existing post-resume.service in this system).
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${systemdInhibit} --what=sleep --mode=block --why=post-resume-grace ${sleep} ${toString inhibitSeconds}";
    };
  };
}
