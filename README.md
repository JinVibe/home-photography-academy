# 방구석 사진학원 MVP

게임화된 휴대폰 카메라 학습 앱의 Flutter Android MVP입니다.

## 포함된 화면

- 홈: 캐릭터 코치, 레벨, XP, 오늘의 추천 미션
- 미션: 카메라 기능별 촬영 과제 목록
- 성장: 완료 미션, XP, 배지
- 미션 상세: 바텀시트로 과제와 촬영 팁 표시

## 실행

Flutter SDK가 설치된 환경에서 실행합니다.

```bash
flutter pub get
flutter run
```

Android Gradle 래퍼 파일이 없다는 오류가 나오면 아래 명령으로 Android 플랫폼 파일을 보강한 뒤 다시 실행합니다.

```bash
flutter create --platforms=android .
flutter run
```
