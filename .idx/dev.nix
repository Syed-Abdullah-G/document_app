{pkgs}: {
  channel = "stable-23.11";
 
    env = {
    JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64";
  };

  packages = [
    pkgs.apt
    pkgs.sudo
    pkgs.nodePackages.firebase-tools
    pkgs.jdk17
    pkgs.unzip
    pkgs.envfs
  ];
  idx.extensions = [
    
  ];
  idx.previews = {
    previews = {
      web = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "web-server"
          "--web-hostname"
          "0.0.0.0"
          "--web-port"
          "$PORT"
        ];
        manager = "flutter";
      };
      android = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "android"
          "-d"
          "emulator-5554"
        ];
        manager = "flutter";
      };
    };
  };
}