{
    self,
    steam-fetcher,
}:

{
    config,
    pkgs,
    lib,
    ...
}:

let
    cfg = config.services.ark;
in

{
    config.nixpkgs.overlays = [self.overlays.default steam-fetcher.overlays.default];

    options.services.ark = {
        enable = lib.mkEnableOption (lib.mdDoc "Ark Dedicated Server");

        # port = lib.mkOption {
        #     type = lib.types.port;
        #     default = 9001;
        #     description = lib.mdDoc "The port on which to listen for incoming connections.";
        # };

        openFirewall = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = lib.mdDoc "Whether to open ports in the firewall.";
        };

    # Any options you want to expose for the game server, which will vary from game to game.
    };

    config = {
        users = {
            users.ark = {
                isSystemUser = true;
                group = "ark";
                home = "/home/ark/";
            };
            groups.ark = {};
        };

        systemd.services.ark = {
            description = "ark dedicated server";
            requires = ["network.target"];
            after = ["network.target"];
            wantedBy = ["multi-user.target"];

            serviceConfig = {
                Type = "exec";
                User = "ark";
                ExecStart = "${pkgs.ark-server}/junkyard-server-executable";
            };
        };

        networking.firewall = lib.mkIf cfg.openFirewall {
            allowedUDPPorts = [
                7777
                7778
                27015
            ];
        };
    };
}
