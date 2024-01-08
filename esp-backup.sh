#!/bin/bash

# Prompt if running in recovery mode
zenity --question --title="Recovery mode prompt" --text="Are you running in recovery mode?" --width=320 --height=120
RECOVERY_MODE=$?

# Define path and file name
TODAY=$(date +%F)
BACKUP_DIR="/home/deck"
BACKUP_FILE="Backup_ESP-${TODAY}.zip"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"
HASH_FILE="${BACKUP_PATH}.sha256"
ESP_MOUNT="/esp"
REPAIR_DIR="/repair"

# In recovery mode
if [ $RECOVERY_MODE -eq 0 ]; then
    sudo steamos-readonly disable
    sudo mkdir -p "$REPAIR_DIR"
    sudo mount /dev/nvme0n1p1 "$REPAIR_DIR"
    ESP_MOUNT="/repair"
else
    # Enter sudo password
    SUDO_PASS=$(zenity --password --title="Enter sudo password" --width=320 --height=120)
    if [ -z "$SUDO_PASS" ]; then
        zenity --error --text="A sudo password is required." --width=320 --height=120
        exit 1
    fi
fi

# Password validation
echo $SUDO_PASS | sudo -S ls / &> /dev/null
if [ $? -ne 0 ]; then
    zenity --error --text="sudo password is incorrect." --width=320 --height=120
    exit 1
fi

backup_esp() {
    if [ -f "$BACKUP_PATH" ]; then
        if zenity --question --text="Backup file ($BACKUP_FILE)\nalready exists. Do you want to overwrite?" --width=320 --height=120; then
            # Delete existing backup files and hash file
            sudo rm "$BACKUP_PATH"
            sudo rm "$HASH_FILE"
        else
            zenity --info --text="Backup has been cancelled." --width=320 --height=120
            exit 0
        fi
    fi

    # Create backup file
    if echo $SUDO_PASS | sudo -S zip -r "$BACKUP_PATH" "$ESP_MOUNT"; then
        echo $SUDO_PASS | sudo -S sha256sum "$BACKUP_PATH" > "$HASH_FILE"
        zenity --info --text="Backup complete.\n$BACKUP_PATH" --width=320 --height=120
    else
        zenity --error --text="Backup failed." --width=320 --height=120
        exit 1
    fi
}

restore_esp() {
    local restore_file=$(zenity --file-selection --title="Select ESP backup file to restore" --width=320 --height=120)
    
    # If the user did not select a file
    if [ -z "$restore_file" ]; then
        zenity --error --text="You have not selected ESP backup file to restore." --width=320 --height=120
        exit 1
    fi

    local restore_hash_file="${restore_file}.sha256"
    
    # Check hash value
    if [ -f "$restore_hash_file" ]; then
        local file_hash=$(sha256sum "$restore_file" | awk '{ print $1 }')
        local saved_hash=$(awk '{ print $1 }' "$restore_hash_file")
        if [ "$file_hash" == "$saved_hash" ]; then
            if echo $SUDO_PASS | sudo -S unzip -o "$restore_file" -d "/"; then
                zenity --info --text="Restore complete." --width=320 --height=120
            else
                zenity --error --text="Restore failed." --width=320 --height=120
                exit 1
            fi
        else
            zenity --error --text="Hash values do not match. The file may have been tampered with." --width=320 --height=120
            exit 1
        fi
    else
        zenity --error --text="There is no hash file. Make sure you selected the correct backup file." --width=320 --height=120
        exit 1
    fi
}

repair_boot_order() {
    local steamos_entry=$(echo $SUDO_PASS | sudo -S efibootmgr | grep -i "SteamOS")
    local windows_entry=$(echo $SUDO_PASS | sudo -S efibootmgr | grep -i "Windows Boot Manager")
    local steamos_entry_number=$(echo "$steamos_entry" | awk '{print $1}' | sed 's/Boot//g' | sed 's/\*//g')
    local windows_entry_number=$(echo "$windows_entry" | awk '{print $1}' | sed 's/Boot//g' | sed 's/\*//g')
    if [ $RECOVERY_MODE -eq 0 ]; then
        zenity --error --text="You cannot proceed in recovery mode.\nPlease proceed after booting SteamOS." --width=320 --height=120
        exit 1
    else
        # Prompt if you're dual booting
        if zenity --question --text="Are you dual booting?" --width=320 --height=120; then
            # If a boot entry already exists, ensure the boot order is correct
            if [ -n "$windows_entry" ] && [ -n "$steamos_entry" ]; then
                local current_order=$(echo $SUDO_PASS | sudo -S efibootmgr | grep "^BootOrder" | cut -d ':' -f 2)
                if [[ $current_order == *"$steamos_entry_number"* && $current_order == *"$windows_entry_number"* ]]; then
                    if [[ $current_order != *"$steamos_entry_number"*"$windows_entry_number"* ]]; then
                        # Set SteamOS as priority
                        echo $SUDO_PASS | sudo -S efibootmgr --bootorder "$steamos_entry_number,$windows_entry_number"
                    else
                        zenity --info --text="The boot list already exists normally." --width=320 --height=120
                        return
                    fi
                fi
            fi
            
            # Add SteamOS boot entry
            if [ -z "$steamos_entry" ]; then
                #echo $SUDO_PASS | sudo -S efibootmgr -c -L "SteamOS" -l "\efi\steamos\steamcl.efi" -d /dev/nvme0n1p1
                steamos_entry_number=$(echo $SUDO_PASS | sudo -S efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "SteamOS" --loader "\EFI\steamos\steamcl.efi" | grep 'BootOrder' | awk '{print $2}')
            fi

            # Add Windows boot entry
            if [ -z "$windows_entry" ]; then
                #echo $SUDO_PASS | sudo -S efibootmgr -c -L "Windows Boot Manager" -l "\efi\Microsoft\Boot\bootmgfw.efi" -d /dev/nvme0n1p1
                windows_entry_number=$(echo $SUDO_PASS | sudo -S efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Windows Boot Manager" --loader "\EFI\Microsoft\Boot\bootmgfw.efi" | grep 'BootOrder' | awk '{print $2}')
            fi

            # Change boot order
            echo $SUDO_PASS | sudo -S efibootmgr --bootorder "$steamos_entry_number,$windows_entry_number"
        else
            # Single OS but boot entry already exists
            if [ -n "$steamos_entry" ]; then
                zenity --info --text="The boot list already exists normally." --width=320 --height=120
                return
            fi

            # Add SteamOS boot entry
            if [ -z "$steamos_entry" ]; then
                echo $SUDO_PASS | sudo -S efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "SteamOS" --loader "\EFI\steamos\steamcl.efi"
            fi
        fi
    fi

    zenity --info --text="Boot order has been updated." --width=320 --height=120
}



# Select task
choice=$(zenity --list --title="ESP Management" --column="Select task" "Backup" "Restore" "Repair Boot Order" --width=320 --height=220 --hide-header)

# Execute functions based on selected actions
case $choice in
    "Backup")
        backup_esp
        ;;
    "Restore")
        restore_esp
        ;;
    "Repair Boot Order")
        repair_boot_order
        ;;
    *)
        zenity --error --text="You did not select a correct option." --width=320 --height=120
        ;;
esac
