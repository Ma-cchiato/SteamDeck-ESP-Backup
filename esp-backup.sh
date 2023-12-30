#!/bin/bash

# 리커버리 부팅 여부 확인
zenity --question --title="리커버리 모드 확인" --text="리커버리 USB 진입 후 실행하셨습니까?" --width=300 --height=120
RECOVERY_MODE=$?

# 경로 및 파일명 정의
TODAY=$(date +%F)
BACKUP_DIR="/home/deck"
BACKUP_FILE="Backup_ESP-${TODAY}.zip"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"
HASH_FILE="${BACKUP_PATH}-hash.txt"
ESP_MOUNT="/esp"
REPAIR_DIR="/repair"

# 리커버리 모드일 경우
if [ $RECOVERY_MODE -eq 0 ]; then
    sudo steamos-readonly disable
    mkdir -p "$REPAIR_DIR"
    sudo mount /dev/nvme0n1p1 "$REPAIR_DIR"
    ESP_MOUNT="/repair"
else
    # sudo 비밀번호 입력
    SUDO_PASS=$(zenity --password --title="sudo 비밀번호 입력" --width=300 --height=120)
    if [ -z "$SUDO_PASS" ]; then
        zenity --error --text="sudo 비밀번호가 필요합니다." --width=300 --height=120
        exit 1
    fi
fi

# 비밀번호 유효성 검사
echo $SUDO_PASS | sudo -S ls / &> /dev/null
if [ $? -ne 0 ]; then
    zenity --error --text="sudo 비밀번호가 잘못되었습니다." --width=300 --height=120
    exit 1
fi

backup_esp() {
    if [ -f "$BACKUP_PATH" ]; then
        if zenity --question --text="백업 파일 ($BACKUP_FILE) 이 \n이미 존재합니다. 덮어쓰시겠습니까?" --width=300 --height=120; then
            # 기존 백업 파일 및 Hash 삭제
            sudo rm "$BACKUP_PATH"
            sudo rm "$HASH_FILE"
        else
            zenity --info --text="백업을 취소했습니다." --width=300 --height=120
            exit 0
        fi
    fi

    # 백업 파일 생성
    if echo $SUDO_PASS | sudo -S zip -r "$BACKUP_PATH" "$ESP_MOUNT"; then
        echo $SUDO_PASS | sudo -S sha256sum "$BACKUP_PATH" > "$HASH_FILE"
        zenity --info --text="백업이 완료되었습니다. \n$BACKUP_PATH" --width=300 --height=120
    else
        zenity --error --text="백업에 실패했습니다." --width=300 --height=120
        exit 1
    fi
}

# 복원 함수
restore_esp() {
    local restore_file=$(zenity --file-selection --title="복원할 ESP 백업 파일 선택" --width=300 --height=120)
    
    # 사용자가 파일을 선택하지 않았을 경우
    if [ -z "$restore_file" ]; then
        zenity --error --text="복원할 파일을 선택하지 않았습니다." --width=300 --height=120
        exit 1
    fi

    local restore_hash_file="${restore_file}-hash.txt"
    
    # 해시값 확인
    if [ -f "$restore_hash_file" ]; then
        local file_hash=$(sha256sum "$restore_file" | awk '{ print $1 }')
        local saved_hash=$(cat "$restore_hash_file" | awk '{ print $1 }')
        if [ "$file_hash" == "$saved_hash" ]; then
            if echo $SUDO_PASS | sudo -S unzip -o "$restore_file" -d "/"; then
                zenity --info --text="복원이 완료되었습니다." --width=300 --height=120
            else
                zenity --error --text="복원에 실패했습니다." --width=300 --height=120
                exit 1
            fi
        else
            zenity --error --text="해시 값이 일치하지 않습니다. 파일이 변조되었을 수 있습니다." --width=300 --height=120
            exit 1
        fi
    else
        zenity --error --text="해시 파일이 없습니다. 올바른 백업 파일을 선택했는지 확인하세요." --width=300 --height=120
        exit 1
    fi
}

repair_boot_order() {
    local steamos_entry=$(echo $SUDO_PASS | sudo -S efibootmgr | grep -i "SteamOS")
    local windows_entry=$(echo $SUDO_PASS | sudo -S efibootmgr | grep -i "Windows Boot Manager")
    local steamos_entry_number=$(echo "$steamos_entry" | awk '{print $1}' | sed 's/Boot//g' | sed 's/\*//g')
    local windows_entry_number=$(echo "$windows_entry" | awk '{print $1}' | sed 's/Boot//g' | sed 's/\*//g')
    if [ $RECOVERY_MODE -eq 0 ]; then
        zenity --error --text="리커버리에서는 진행할 수 없습니다.\nSteamOS 부팅 후 진행해주세요." --width=300 --height=120
        exit 1
    else
    # 듀얼 부팅 여부 확인
    if zenity --question --text="듀얼 부팅을 사용하고 있습니까?" --width=300 --height=120; then
        # 이미 부트 항목이 존재하는 경우 부팅 순서가 올바른지 확인
        if [ ! -z "$windows_entry" ] && [ ! -z "$steamos_entry" ]; then
            local current_order=$(echo $SUDO_PASS | sudo -S efibootmgr | grep "^BootOrder" | cut -d ':' -f 2)
            if [[ $current_order == *"$steamos_entry_number"* && $current_order == *"$windows_entry_number"* ]]; then
                if [[ $current_order != *"$steamos_entry_number"*"$windows_entry_number"* ]]; then
                    # SteamOS를 우선 순위로 설정
                    echo $SUDO_PASS | sudo -S efibootmgr --bootorder "$steamos_entry_number,$windows_entry_number"
                else
                    zenity --info --text="부팅 목록이 이미 정상적으로 존재합니다." --width=300 --height=120
                    return
                fi
            fi
        fi
        
        # SteamOS 부트 항목 추가
        if [ -z "$steamos_entry" ]; then
            #echo $SUDO_PASS | sudo -S efibootmgr -c -L "SteamOS" -l "\efi\steamos\steamcl.efi" -d /dev/nvme0n1p1
            steamos_entry_number=$(echo $SUDO_PASS | sudo -S efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "SteamOS" --loader "\EFI\steamos\steamcl.efi" | grep 'BootOrder' | awk '{print $2}')
        fi

        # Windows 부트 항목 추가
        if [ -z "$windows_entry" ]; then
            #echo $SUDO_PASS | sudo -S efibootmgr -c -L "Windows Boot Manager" -l "\efi\Microsoft\Boot\bootmgfw.efi" -d /dev/nvme0n1p1
            windows_entry_number=$(echo $SUDO_PASS | sudo -S efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Windows Boot Manager" --loader "\EFI\Microsoft\Boot\bootmgfw.efi" | grep 'BootOrder' | awk '{print $2}')
        fi

        # 부트 순서 변경
        echo $SUDO_PASS | sudo -S efibootmgr --bootorder "$steamos_entry_number,$windows_entry_number"
    else
        # 단일 OS이지만 이미 부트 항목이 존재하는 경우
        if [ ! -z "$steamos_entry" ]; then
            zenity --info --text="부팅 목록이 이미 정상적으로 존재합니다." --width=300 --height=120
            return
        fi

        # SteamOS 부트 항목 추가
        if [ -z "$steamos_entry" ]; then
            echo $SUDO_PASS | sudo -S efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "SteamOS" --loader "\EFI\steamos\steamcl.efi"
        fi
    fi
    fi

    zenity --info --text="부팅 순서가 업데이트되었습니다." --width=300 --height=120
}



# 작업 선택
choice=$(zenity --list --title="ESP 관리" --column="작업 선택" "Backup" "Restore" "Repair Boot Order" --width=300 --height=220 --hide-header)

# 선택된 작업에 따라 함수 실행
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
        zenity --error --text="올바른 옵션을 선택하지 않았습니다." --width=300 --height=120
        ;;
esac
