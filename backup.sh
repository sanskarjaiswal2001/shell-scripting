#!/bin/bash
# Author: Sanskar

if [ $# -ne 2 ]; then
    echo "Usage: $0 <backup|restore> <source|backup_path>"
    exit 1
fi
operation="$1"
source="$2"

if [ "$operation" == "backup" ]; then
    destination="$source-backup"
    mkdir -p "$destination"
    touch "$destination/backup.log"
    # Allow custom backup filename
    read -p "Enter backup filename (default: backup_$(date +%Y%m%d%H%M%S)): " custom_filename

    backup_file="${custom_filename:-backup_$(date +%Y%m%d%H%M%S)}.tar.gz.enc"
    backup_destination="$destination/$backup_file"

    # Exclusion list
    read -p "Enter a space-separated list of files/directories to exclude (optional): " exclusion_list

    if [ -n "$exclusion_list" ]; then
        mkdir -p "$destination"
        tar czf - "$source" --exclude={$exclusion_list} | openssl enc -e -aes256 -pbkdf2 -out "$backup_destination" &
        echo -n "Performing backup..."

    else
        tar czf - "$source" | openssl enc -e -aes256 -pbkdf2 -out "$backup_destination" &
        echo "Performing backup..."
    fi

    if [ $? -eq 0 ]; then
        echo -e "\nBackup of $source completed successfully. Encrypted backup saved at $backup_destination"
        echo "$backup_file : $(date +%Y/%m/%d-%H:%M:%S) completed " >>"$destination/backup.log"
    else
        echo -e "\nBackup failed."
        echo "$backup_file : $(date +%Y/%m/%d-%H:%M:%S) failed " >>"$destination/backup.log"
    fi
elif [ "$operation" == "restore" ]; then
    backup_name=$(basename "$2" | cut -d'.' -f1)
    encrypted_backup=$2
    if [ -z "$encrypted_backup" ]; then
        echo "No encrypted backup found in $backup_path"
        exit 1
    else
        echo -n "Restoring backup..."
        openssl enc -d -aes256 -pbkdf2 -in "$encrypted_backup" -out "$backup_name.tar.gz" &

        if [ $? -eq 0 ]; then
            echo -e "\nBackup decrypted successfully. Decrypted backup saved as $backup_name.tar.gz"
            sudo tar -xvf $backup_name.tar.gz
            if [ $? -eq 0 ]; then
                echo "Backup restored successfully."
                rm -rf $backup_name.tar.gz
            else
                echo "Backup restoration failed."
            fi
        else
            echo -e "\nDecryption failed."
        fi
    fi
fi
