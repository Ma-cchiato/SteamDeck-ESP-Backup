# ESP 관리 스크립트

en [English](README.md)

이 스크립트는 리눅스 시스템의 ESP(EFI System Partition)를 관리하기 위해 사용됩니다. 사용자는 이 스크립트를 통해 ESP를 백업하거나 복원할 수 있으며, 부팅 목록을 복구할 수 있습니다.

## 주의사항

- **면책 조항**: 이 스크립트는 '있는 그대로' 제공되며, 사용으로 인한 어떠한 손실이나 손상에 대해 책임을 지지 않습니다. 사용자는 스크립트 사용에 따른 모든 위험을 감수해야 하며, 중요한 데이터의 손실이나 시스템 손상의 가능성을 고려하여 신중히 사용해야 합니다.
- 복원 기능을 사용할 때는 백업 파일과 hash.txt 파일은 같은 디렉토리에 위치해있어야 합니다.
- 부팅 목록 복구는 리커버리 모드가 아닌 일반 부팅시에만 사용이 가능합니다.

## 기능

- **ESP 백업**: 현재 시스템의 ESP를 백업합니다.
- **ESP 복원**: 백업된 ESP 파일을 복원합니다.
- **부팅 목록 복구**: SteamOS 및 Windows 부팅 항목을 확인하고, 필요한 경우 부팅 목록을 복구하고 부팅 순서를 재설정합니다.

## 사용 방법

1. **리커버리 모드 확인**: 스크립트 실행 시, 리커버리 모드에서 실행했는지를 묻는 대화 상자가 나타납니다. 리커버리 모드에서 실행했다면 'Yes'를 선택합니다.

   ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/be3871a8-caf8-4421-9249-27286b85f8f4)

2. **sudo 비밀번호 입력**: 일반 모드에서 실행하는 경우, sudo 비밀번호 입력을 요구하는 대화 상자가 나타납니다. sudo 비밀번호를 입력하고 'OK'를 클릭합니다.

   ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/5508db94-7657-4034-a73f-3b7cf4164822)

3. **작업 선택**: Backup, Restore, Repair Boot Order 중 하나를 선택 후 'OK'를 클릭합니다. 선택한 작업에 따라 다음 단계가 진행됩니다.

   ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/413e8ed4-7dfd-4b88-b40b-3c8f74faa9ad)

- **Backup (ESP 백업)**
  - 백업 선택 시, /esp 디렉토리의 모든 파일을 백업합니다.
  - 기존에 백업 파일이 존재하는 경우 덮어쓸지 여부를 묻는 메시지가 표시됩니다. 'Yes'를 선택하면 기존 백업 파일이 삭제되고 새 백업 파일이 생성됩니다.
  - 백업이 완료되면 완료 알림이 표시됩니다. 백업된 압축 파일과 압축파일명-hash.txt 파일이 생성됩니다.

    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/528c0798-fdbc-4fcf-8bd8-f42a58efe6e1)
    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/3746b1bb-f7bf-43a4-b09a-25df58211139)

- **Restore (ESP 복원)**
  - 복원을 선택하면, 백업 파일을 선택할 수 있는 대화 상자가 나타납니다.
  - 백업 파일을 선택하면, 파일의 해시값을 확인하고 복원 프로세스가 시작됩니다.
  - 복원이 완료되면 완료 알림이 표시됩니다.

    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/07f5c853-4b55-4cf9-9c88-4cbe37f63dc3)

- **Repair Boot Order (부팅 목록 복구)**
  - 부팅 목록 복구를 선택하면, 듀얼 부팅 여부를 묻는 메시지가 나타납니다.
  - 듀얼 부팅인 경우, SteamOS와 Windows 부트 항목을 추가하고 순서를 설정합니다.
  - 단일 OS인 경우, SteamOS 부트 항목만 추가합니다.
  - 작업이 완료되면 완료 알림이 표시됩니다.

    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/cf595afa-c993-441d-ad56-26e001fad52c)
    ![image](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/70a869c4-c8d0-4d62-8ef7-ddcb829b27d2)

## 라이선스

이 스크립트는 MIT 라이선스 하에 배포됩니다.
