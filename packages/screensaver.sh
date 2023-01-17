#!/usr/bin/env bash

function _screensaver() {
    while true; do
      clear && \
      neofetch && \
      fortune | cowsay && \
      sleep 30
    done
}

_screensaver "$@"
