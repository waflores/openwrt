{
  description = "A Nix-flake-based C/C++ development environment";
  nixConfig.bash-prompt-suffix = "devshell-env> ";
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-compat,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "mips-linux"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config = {
                permittedInsecurePackages = [
                  "python-2.7.18.8"
                ];
                hardeningDisable = [ "all" ];
              };
            };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default =
            pkgs.mkShell.override
              {
                # Override stdenv in order to change compiler:
                stdenv = pkgs.gcc7Stdenv;
              }
              {
                packages = with pkgs; [
                  clang-tools
                  cmake
                  codespell
                  conan
                  cppcheck
                  doxygen
                  gdb
                  glibcLocalesUtf8
                  gtest
                  lcov
                  ncurses5
                  nix-output-monitor
                  nixpkgs-fmt
                  python2
                  perl
                  starship
                  vcpkg
                  vcpkg-tool
                  pkg-config
                  pam
                  libpam-wrapper
                  gnutls.dev
                  openldap.dev
                  libidn2.dev
                  libcap.dev
                  xz.dev
                  net-snmp.dev
                  jansson
                ];
              };
        }
      );
    };
}
