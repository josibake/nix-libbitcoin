{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.libbitcoin-server;
  defaultPackage =
    pkgs.libbitcoin-server
    or pkgs.libbitcoinPackages.libbitcoin-server
    or (pkgs.callPackage ../../pkgs/libbitcoin {}).libbitcoin-server;
  settingsOptions = import ./libbitcoin-server-settings.nix {inherit lib;};

  formatValue = value:
    if lib.isBool value
    then lib.boolToString value
    else if lib.isPath value
    then toString value
    else toString value;

  renderKey = key: value:
    if value == null
    then []
    else if lib.isList value
    then map (item: "${key} = ${formatValue item}") value
    else ["${key} = ${formatValue value}"];

  renderSection = name: values: let
    lines = lib.concatLists (lib.mapAttrsToList renderKey values);
  in
    lib.optionalString (lines != []) ''
      [${name}]
      ${lib.concatStringsSep "\n" lines}
    '';

  generatedConfig = pkgs.writeText "bs.cfg" ''
    ${lib.concatStringsSep "\n\n" (lib.mapAttrsToList renderSection cfg.settings)}
    ${cfg.extraConfig}
  '';

  configFile =
    if cfg.configFile == null
    then generatedConfig
    else cfg.configFile;
in {
  options.services.libbitcoin-server = {
    enable = lib.mkEnableOption "libbitcoin-server";

    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPackage;
      defaultText = lib.literalExpression "pkgs.libbitcoin-server";
      description = "libbitcoin-server package to run.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "libbitcoin-server";
      description = "User account under which libbitcoin-server runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "libbitcoin-server";
      description = "Group under which libbitcoin-server runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/libbitcoin-server";
      description = "Directory for the libbitcoin blockchain database.";
    };

    logDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/log/libbitcoin-server";
      description = "Directory for libbitcoin-server log files.";
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a complete bs configuration file. When set, settings and extraConfig are ignored.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = settingsOptions;
      };
      default = {};
      example = {
        database.path = "/var/lib/libbitcoin-server/blockchain";
        inbound.bind = ["0.0.0.0:8333"];
        log.path = "/var/log/libbitcoin-server";
      };
      description = "Typed libbitcoin-server settings rendered as sections and keys.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Raw configuration appended to the generated bs configuration.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the Bitcoin P2P port in the firewall.";
    };

    p2pPort = lib.mkOption {
      type = lib.types.port;
      default = 8333;
      description = "Bitcoin P2P port to open when openFirewall is enabled.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.libbitcoin-server.settings = lib.mkIf (cfg.configFile == null) {
      database.path = lib.mkDefault "${cfg.dataDir}/blockchain";
      log.path = lib.mkDefault cfg.logDir;
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
    };

    users.groups.${cfg.group} = {};

    systemd.services.libbitcoin-server = {
      description = "libbitcoin-server";
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config ${configFile}";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "libbitcoin-server";
        LogsDirectory = "libbitcoin-server";
        RuntimeDirectory = "libbitcoin-server";
        Restart = "on-failure";
        RestartSec = "30s";
        LimitNOFILE = 1048576;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = [cfg.dataDir cfg.logDir];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.p2pPort];
  };
}
