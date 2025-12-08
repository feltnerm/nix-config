/**
    This file describes my network topology and devices so they can be rendered by [nix-topology](https://github.com/oddlama/nix-topology/).

  TODO work in progress
*/
{ inputs, ... }:
{

  imports = [
    inputs.nix-topology.flakeModule
  ];

  perSystem = _: {
    topology = {
      modules = [
        (
          { config, ... }:
          let
            inherit (config.lib.topology)
              mkInternet
              mkRouter
              mkSwitch
              mkConnection
              ;
          in
          {
            nodes.internet = mkInternet {
              connections = mkConnection "router" "wan1";
            };
            nodes.router = mkRouter "dream-machine" {
              info = "UniFi OS UDM";
              interfaceGroups = [
                [
                  "eth1"
                  "eth2"
                  "eth3"
                  "eth4"
                ]
                [ "wan1" ]
              ];
              connections.eth1 = mkConnection "switch1" "eth1";
              interfaces.eth1 = {
                addresses = [ "192.168.1.1" ];
                network = "home";
              };
            };

            nodes.switch1 = mkSwitch "Basement Switch" {
              info = "NETGEAR ProSafe GS105Ev2";
              interfaceGroups = [
                [
                  "eth1"
                  "eth2"
                  "eth3"
                  "eth4"
                  "eth5"
                ]
              ];
              connections.eth2 = mkConnection "reddevil-windows" "eth0";
            };

            networks = {
              home = {
                name = "pala";
                cidrv4 = "192.168.1.0/24";
              };
            };

            nodes.reddevil-windows = {
              deviceType = "desktop";
              hardware.info = "Microsoft Windows 11";
              interfaces.eth0 = { };
            };
          }
        )
      ];
    };
  };
}
