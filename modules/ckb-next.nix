{
  lib,
  config,
  # We assume that ckb-next overlay is already applied to pkgs.
  pkgs,
  ...
}:

let
  cfg = config.services.ckb-next;
  package = pkgs.ckb-next;
  package-experimental = pkgs.ckb-next-experimental;
in
{
  options.services.ckb-next = {
    enable = lib.mkOption {
      default = false;
      example = true;
      description = ''
        Corsair Keyboards and Mice Daemon
      '';
    };
    experimental = lib.mkOption {
      default = false;
      example = true;
      description = ''
        Enable support for experimental code. This means running the
        daemon with --enable-experimental, but also using a bleeding
        edge version of the software.
      '';
    };
  };

  config = {

    environment.systemPackages = lib.mkIf cfg.enable [
      (lib.mkIf (!cfg.experimental) package)
      (lib.mkIf cfg.experimental package-experimental)
    ];

    systemd.services.ckb-next = lib.mkIf cfg.enable {
      description = "Corsair Keyboards and Mice Daemon";
      path = lib.mkIf cfg.enable [
        (lib.mkIf (!cfg.experimental) package)
        (lib.mkIf cfg.experimental package-experimental)
      ];
      serviceConfig = {
        Environment = lib.mkIf cfg.experimental [
          "CKB_ARGS=--enable-experimental"
        ];
        ExecStart = [ "${package}/bin/ckb-next-daemon $CKB_ARGS" ];
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
    };

    services.udev.packages = lib.mkIf cfg.enable [
      (lib.mkIf (!cfg.experimental) package)
      (lib.mkIf cfg.experimental package-experimental)
    ];
  };
}
