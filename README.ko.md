# ESP 관리 스크립트

en [English](README.md)

이 스크립트는 리눅스 시스템의 ESP(EFI System Partition)를 관리하기 위해 사용됩니다. 사용자는 이 스크립트를 통해 ESP를 백업하거나 복원할 수 있으며, 부팅 목록을 복구할 수 있습니다.

## 주의사항

- **면책 조항**: 이 스크립트는 '있는 그대로' 제공되며, 사용으로 인한 어떠한 손실이나 손상에 대해 책임을 지지 않습니다. 사용자는 스크립트 사용에 따른 모든 위험을 감수해야 하며, 중요한 데이터의 손실이나 시스템 손상의 가능성을 고려하여 신중히 사용해야 합니다.
- 복원 기능을 사용할 때 백업 파일과 해시 파일은 동일한 디렉터리에 있어야 합니다.
- 부팅 목록 복구는 리커버리 모드가 아닌 일반 부팅시에만 사용이 가능합니다.

## 기능

- **ESP 백업**: 현재 시스템의 ESP를 백업합니다.
- **ESP 복원**: 백업된 ESP 파일을 복원합니다.
- **부팅 목록 복구**: SteamOS 및 Windows 부팅 항목을 확인하고, 필요한 경우 부팅 목록을 복구하고 부팅 순서를 재설정합니다.

## 사용 방법

1. **리커버리 모드 확인**: 스크립트 실행 시, 리커버리 모드에서 실행했는지를 묻는 대화 상자가 나타납니다. 리커버리 모드에서 실행했다면 'Yes'를 선택합니다.

   ![1](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/13984cc6-f9fc-4d50-b607-c68becbee2c3)

2. **sudo 비밀번호 입력**: 일반 모드에서 실행하는 경우, sudo 비밀번호 입력을 요구하는 대화 상자가 나타납니다. sudo 비밀번호를 입력하고 'OK'를 클릭합니다.

   ![2](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/57de381c-5b6c-40c4-becc-839d3dd24e47)

3. **작업 선택**: Backup, Restore, Repair Boot Order 중 하나를 선택 후 'OK'를 클릭합니다. 선택한 작업에 따라 다음 단계가 진행됩니다.

   ![3](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/cfc752d1-21ca-4a2c-ad86-0bee0eff0be2)

- **Backup (ESP 백업)**
  - 백업 선택 시, /esp 디렉토리의 모든 파일을 백업합니다.
  - 기존에 백업 파일이 존재하는 경우 덮어쓸지 여부를 묻는 메시지가 표시됩니다. 'Yes'를 선택하면 기존 백업 파일이 삭제되고 새 백업 파일이 생성됩니다.
  - 백업이 완료되면 완료 알림이 표시됩니다. 압축된 백업 파일과 해시 파일이 생성됩니다.

    ![4](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/9534d789-8b98-4b60-8e4d-e3c302b01e21)
    ![5](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/05557290-753d-48c3-919d-93f005c151b0)

- **Restore (ESP 복원)**
  - 복원을 선택하면, 백업 파일을 선택할 수 있는 대화 상자가 나타납니다.
  - 백업 파일을 선택하면, 파일의 해시값을 확인하고 복원 프로세스가 시작됩니다.
  - 복원이 완료되면 완료 알림이 표시됩니다.

    ![6](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/1e03f1e0-37d1-4b10-8ea2-d7ecc6030f84)

- **Repair Boot Order (부팅 목록 복구)**
  - 부팅 목록 복구를 선택하면, 듀얼 부팅이 있는지 묻습니다.
  - 듀얼 부팅인 경우, SteamOS와 Windows 부트 항목을 추가하고 순서를 설정합니다.
  - 단일 OS인 경우, SteamOS 부트 항목만 추가합니다.
  - 작업이 완료되면 완료 알림이 표시됩니다.

    ![7](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/a64b1638-9e28-4158-8eec-121a0808b79f)
    ![8](https://github.com/Ma-cchiato/SteamDeck-ESP-Backup/assets/122413511/79d2b85d-5ff6-47a2-afb6-6e88852f7f9e)

## 라이선스

이 스크립트는 MIT 라이선스 하에 배포됩니다.
