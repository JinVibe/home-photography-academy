# 실행 방법

## 1. 프로젝트 폴더로 이동

PowerShell에서 아래 명령을 실행합니다.

```powershell
cd "C:\Users\82108\Desktop\project set\home photography academy"
```

## 2. Flutter 설치 확인

```powershell
flutter --version
flutter doctor
```

`flutter doctor`에서 `No issues found`가 나오면 실행 준비가 끝난 상태입니다.

## 3. 연결된 기기 확인

```powershell
flutter devices
```

Android 폰으로 실행하려면 폰에서 개발자 옵션과 USB 디버깅을 켠 뒤 PC에 USB로 연결합니다.

## 4. 앱 실행

연결된 기기가 하나라면 아래 명령으로 바로 실행합니다.

```powershell
flutter run
```

기기가 여러 개라면 기기 ID를 확인한 뒤 지정해서 실행합니다.

```powershell
flutter run -d <device-id>
```

## 5. APK 빌드

디버그 APK를 만들려면 아래 명령을 실행합니다.

```powershell
flutter build apk --debug
```

생성된 APK 위치:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

## 6. APK 설치

Android 기기가 USB로 연결되어 있으면 아래 명령으로 설치할 수 있습니다.

```powershell
flutter install
```

## 참고

새 터미널을 열었는데 `flutter` 명령이 인식되지 않으면 PC를 재시작하거나, 현재 PowerShell에서 임시로 PATH를 추가합니다.

```powershell
$env:Path = $env:Path + ";C:\Users\82108\flutter\bin"
```
