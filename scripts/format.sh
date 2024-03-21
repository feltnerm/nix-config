#!/usr/bin/env bash

nix develop --command alejandra .
nix develop --command statix check .
