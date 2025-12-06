{ lib, ... }:
{
  # Minimal shared nixvim module for wiring
  config = {
    programs.nixvim = {
      config.enable = lib.mkDefault true;
    };
  };
}
