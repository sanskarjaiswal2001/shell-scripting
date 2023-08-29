#!/bin/bash

if [ $# -eq 1]; then
    echo "Please enter directory name"
    exit 1
fi

directory="$1"

if [ ! -d "$directory" ]; then
    echo "Directory $directory DOES NOT exists."
    exit 1
fi

find "$directory" -type f -name "*.sh" -printf "%f\n"
