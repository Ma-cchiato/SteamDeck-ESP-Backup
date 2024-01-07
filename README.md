# ESP Management Script

ko [한국어](README.ko.md)

This script is used to manage the ESP (EFI System Partition) of a Linux system. This script allows users to backup or restore ESP and recover boot list.

## Caution

- **Disclaimer**: This script is provided 'as is' and we will not be liable for any loss or damage resulting from its use. Users assume all risks associated with using the script, and should use it cautiously considering the possibility of loss of important data or damage to the system.
- When using the restore function, the backup file and hash.txt file must be located in the same directory.
- Boot list recovery can only be used during normal booting, not recovery mode.

## Function

- **ESP Backup**: Backs up the ESP of the current system.
- **ESP Restore**: Restore backed up ESP files.
- **Boot List Recovery**: Check SteamOS and Windows boot entries, repair boot list and reset boot order if necessary.

## How to use

1. **Check recovery mode**: When running the script, a dialog box will appear asking whether it was run in recovery mode. If running in recovery mode, select 'Yes'.

   ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/be3871a8-caf8-4421-9249-27286b85f8f4)

2. **Enter your sudo password**: If running in normal mode, a dialog box will appear asking you to enter your sudo password. Enter your sudo password and click 'OK'.

   ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/5508db94-7657-4034-a73f-3b7cf4164822)

3. **Select task**: Select one of Backup, Restore, and Repair Boot Order and click 'OK'. The next steps will follow depending on the action you selected.

   ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/413e8ed4-7dfd-4b88-b40b-3c8f74faa9ad)

- **Backup (ESP Backup)**
  - When you select Backup, all files in the /esp directory are backed up.
  - If a backup file already exists, you will be prompted to overwrite it. If you select 'Yes', the existing backup file will be deleted and a new backup file will be created.
  - When the backup is complete, you will see a completion notification. The backed up compressed file and compressed file name-hash.txt file are created.

    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/528c0798-fdbc-4fcf-8bd8-f42a58efe6e1)
    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/3746b1bb-f7bf-43a4-b09a-25df58211139)

- **Restore (ESP Restore)**
  - When you select Restore, a dialog box will appear allowing you to select the backup file.
  - Once you select a backup file, the hash value of the file will be verified and the restoration process will begin.
  - When the restore is complete, you will see a completion notification.

    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/07f5c853-4b55-4cf9-9c88-4cbe37f63dc3)

- **Repair Boot Order (Boot List Recovery)**
  - If you select Repair Boot List, you will be prompted to dual boot.
  - If dual booting, add SteamOS and Windows boot entries and set their order.
  - For a single OS, add only the SteamOS boot entry.
  - When the task is complete, you will see a completion notification.

    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/cf595afa-c993-441d-ad56-26e001fad52c)
    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/70a869c4-c8d0-4d62-8ef7-ddcb829b27d2)

## License

This script is released under the MIT License.
