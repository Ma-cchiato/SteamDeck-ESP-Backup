# ESP Management Script

ko [한국어](README.ko.md)

This script is used to manage the ESP (EFI System Partition) of a Linux system. This script allows users to backup or restore ESP and recover boot list.

## Caution

- **Disclaimer**: This script is provided 'as is' and we will not be liable for any loss or damage resulting from its use. Users assume all risks associated with using the script, and should use it cautiously considering the possibility of loss of important data or damage to the system.
- When using the restore function, the backup file and hash file must be located in the same directory.
- Boot list recovery can only be used during normal booting, not recovery mode.

## Function

- **ESP Backup**: Backup the ESP of the current system.
- **ESP Restore**: Restore backed up ESP files.
- **Boot List Recovery**: Check SteamOS and Windows boot entries, repair boot list and reset boot order if necessary.

## How to use

1. **Check recovery mode**: When running the script, a dialog box will appear asking whether it was run in recovery mode. If running in recovery mode, select 'Yes'.

   ![1](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/9b5c9426-96b0-40c4-81e5-5deb24c7c90e)

2. **Enter your sudo password**: If running in normal mode, a dialog box will appear asking you to enter your sudo password. Enter your sudo password and click 'OK'.

   ![2](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/57de381c-5b6c-40c4-becc-839d3dd24e47)

3. **Select task**: Select one of Backup, Restore, and Repair Boot Order and click 'OK'. The next steps will follow depending on the action you selected.

   ![3](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/cfc752d1-21ca-4a2c-ad86-0bee0eff0be2)

- **Backup (ESP Backup)**
  - When you select Backup, all files in the /esp directory are backed up.
  - If a backup file already exists, you will be prompted to overwrite it. If you select 'Yes', the existing backup file will be deleted and a new backup file will be created.
  - When the backup is complete, you will see a completion notification. The compressed backup file and hash file are created.

    ![4](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/9534d789-8b98-4b60-8e4d-e3c302b01e21)
    ![5](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/05557290-753d-48c3-919d-93f005c151b0)

- **Restore (ESP Restore)**
  - When you select Restore, a dialog box will appear allowing you to select the backup file.
  - Once you select a backup file, the hash value of the file will be verified and the restoration process will begin.
  - When the restore is complete, you will see a completion notification.

    ![6](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/1e03f1e0-37d1-4b10-8ea2-d7ecc6030f84)

- **Repair Boot Order (Boot List Recovery)**
  - If you select Repair Boot List, you will be asked if you're dual booting.
  - If dual booting, add SteamOS and Windows boot entries and set their order.
  - For a single OS, add only the SteamOS boot entry.
  - When the task is complete, you will see a completion notification.

    ![7](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/191485cc-738c-4af1-802f-ba6c269b4780)
    ![8](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/79d2b85d-5ff6-47a2-afb6-6e88852f7f9e)

## License

This script is released under the MIT License.
