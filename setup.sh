#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
    clear
    echo "This script MUST NOT be run as root."
    echo "Exiting..."
    sleep 3 && exit 1
fi

stow .

bat cache --build
