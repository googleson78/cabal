{ pkgs ? import ./nixpkgs.nix { } }:

with pkgs;
mkShell {
  TMPDIR = "/tmp";

  # Set UTF-8 local so that run-tests can parse GHC's unicode output.
  LANG = "C.UTF-8";

  buildInputs = [
    bazel_5
    stack
    python39
    hyperfine
  ];

  shellHook = ''
    # Add nix config flags to .bazelrc.local.
    #
    BAZELRC_LOCAL=".bazelrc.local"
    if [ ! -e "$BAZELRC_LOCAL" ]
    then
      echo "[!] It looks like you are using a Nix-based system."
      echo "In order to build this project, you need to add the two"
      echo "following host_platform entries to your .bazelrc.local file:"
      echo
      echo "build --host_platform=@io_tweag_rules_nixpkgs//nixpkgs/platforms:host"
      echo "run --host_platform=@io_tweag_rules_nixpkgs//nixpkgs/platforms:host"
    fi
  '';
}
