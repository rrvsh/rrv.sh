{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) toString;
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) port str;
  cfg = config.services.rrv-sh;
  package = pkgs.callPackage ../package.nix { };
in
{
  options.services.rrv-sh = {
    enable = mkEnableOption "";
    port = mkOption {
      type = port;
      default = 2309;
    };
    user = mkOption {
      type = str;
      default = "rrv-sh";
    };
    group = mkOption {
      type = str;
      default = "rrv-sh";
    };
  };
  config = mkIf cfg.enable {
    users.users.rrv-sh = mkIf (cfg.user == "rrv-sh") {
      inherit (cfg) group;
      isSystemUser = true;
      description = "rrv.sh server user";
    };
    users.groups.rrv-sh = mkIf (cfg.group == "rrv-sh") { };
    systemd.services.rrv-sh = {
      description = "the rrv.sh website";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = ''
          ${pkgs.caddy}/bin/caddy file-server \
            --root ${package} \
            --listen :${toString cfg.port}
        '';
      };
    };
  };
}
