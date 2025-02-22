{
    lib,
    stdenv,
    fetchSteam,
}:

stdenv.mkDerivation rec {
    name = "ark";
    version = "0.0.1";
    src = fetchSteam {
        inherit name;
        appId = "346110";
        depotId = "1318680";
        manifestId = "8060274748931292766";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    # Skip phases that don't apply to prebuilt binaries.
    dontBuild = true;
    dontConfigure = true;
    dontFixup = true;

    installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r $src $out

        # You may need to fix permissions on the main executable.
        chmod +x $out/some_server_executable

        runHook postInstall
    '';

    meta = with lib; {
        description = "ark dedicated server";
        homepage = "https://steamdb.info/app/346110/";
        changelog = "https://store.steampowered.com/news/app/346110?updates=true";
        sourceProvenance = with sourceTypes; [
            binaryNativeCode # Steam games are always going to contain some native binary component.
            binaryBytecode # e.g. Unity games using C#
        ];
        license = licenses.unfree;
        platforms = ["x86_64-linux"];
    };
}
