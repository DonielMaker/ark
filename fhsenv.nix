{
    lib,
    buildFHSUserEnv,
    writeScript,
    ark-server,
    steamworks-sdk-redist,
}:

buildFHSUserEnv {
    name = "ark-dedicated-server";

    runScript = "junkyard-server-executable";

    targetPkgs = pkgs: [
        ark-server
        steamworks-sdk-redist
    ];

    inherit (ark-server) meta;
}
