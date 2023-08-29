#!/bin/bash

# Author: Sanskar

BASE_DIR=$(pwd)
user=$(whoami)
user_dir="$BASE_DIR/$user"
date=$(date +"%d %b %Y")
hostname=$(hostname)
mainIp=$(hostname -i)
uptime=$(uptime -p | sed 's/up //')
loadavg=$(awk '{print $1 "," $2 "," $3}' /proc/loadavg)
totalRam=$(free --mega | awk '/Mem:/ {print $2 " mb"}')
usedRam=$(free --mega | awk '/Mem:/ {print $3 " mb"}')

# Function to create user directory if not exists
create_user_dir() {
    if [ ! -d "$user_dir" ]; then
        mkdir -p "$user_dir"
    fi
}

# Function to write system info to file
write_system_info() {
    {
        echo "User: $user"
        echo "Date: $date"
        echo "Hostname: $hostname"
        echo "System Main IP: $mainIp"
        echo "Uptime: $uptime"
        echo "Load Average: $loadavg"
        echo "Total RAM: $totalRam"
        echo "Used RAM: $usedRam"
    } >"$user_dir/system_info.txt"
}

# Function to compress and clean up
compress_and_cleanup() {

    echo "Compressing and Cleaning Up..."
    start_time=$(date +%s)  # Record start time

    # Compress the user directory
    tar -czf "$user_dir.tar.gz" -C "$BASE_DIR" "$user"

    end_time=$(date +%s)  # Record end time
    completion_time=$((end_time - start_time))  # Calculate completion time in seconds

    # Remove the user directory
    rm -rf "$user_dir"

    echo "Task completion time: ${completion_time} seconds"
}

# Main script
main() {
    echo "Script to Gather System Information and Archive"
    create_user_dir
    write_system_info

    # Ask for user confirmation before proceeding
    read -p "Do you want to proceed? (y/N): " confirm
    if [ "$confirm" == "y" ]; then
        compress_and_cleanup
        echo "Successfully completed!"
    else
        echo "Operation cancelled."
    fi
}

main
