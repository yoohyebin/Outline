# 🏃🏻‍♀️ GPS Art 러닝 가이드 OUTLINE
<p align="center">
    <img width="500" alt="image" src="https://github.com/user-attachments/assets/90612b70-fe37-446f-ba3e-aca389237014">
</p>

<a href='https://apps.apple.com/kr/app/outline-%EC%95%84%EC%9B%83%EB%9D%BC%EC%9D%B8-gps-art-%EC%95%B1/id6471041315'><img alt='Available on the App Store' src='https://user-images.githubusercontent.com/67373938/227817078-7aab7bea-3af0-4930-b341-1a166a39501d.svg' height='50px'/></a> 
<a href='https://www.instagram.com/outline.run.kr/'><img alt='Available on the App Store' src='https://github.com/user-attachments/assets/a673db41-d851-4a60-afbd-2ebaed3607bb' height='50px'/></a> 

>**개발기간: 2023.09 ~ 진행 중**

## 📖 프로젝트 소개
- OUTLINE은 사용자의 러닝 경로를 GPS로 추적하여 나만의 아트를 만들 수 있는 앱입니다.
- 사용자는 제공된 코스를 선택하고, 지도에 표시된 가이드라인을 따라 달릴 수 있도록 안내받습니다.
- 러닝을 완료한 후에는 기록을 한눈에 확인하고, 인스타그램 스토리로 손쉽게 공유할 수 있습니다.

## ☺️ 멤버 소개
| **Helia** | **Tyler** | **Hain** | **Dana** | **Seze** |
| :------: |  :------: | :------: | :------: | :------: |
| iOS Developer | iOS Developer | iOS Developer | Designer | Project Manager |

---

## 🔧 Stacks 

### Environment
![Xcode](https://img.shields.io/badge/Xcode-147EFB?style=for-the-badge&logo=Xcode&logoColor=white)
![Github](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=GitHub&logoColor=white)  
![Firebase](https://img.shields.io/badge/firebase-DD2C00?style=for-the-badge&logo=firebase)

### Development
![Swift](https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0086c8?style=for-the-badge&logo=Swift&logoColor=white)

### Communication
![Notion](https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=Notion&logoColor=white)
![Discord](https://img.shields.io/badge/discord-5865F2?style=for-the-badge&logo=discord&logoColor=white)
![JIRA](https://img.shields.io/badge/jira-0052CC?style=for-the-badge&logo=jirasoftware&logoColor=white)

### Platform
- **iOS**
- **WatchOS**

<br>

### Framework
**MapKit**
- 지도 프레임워크입니다.
- 지도 상에서 사용자의 이동 경로를 추적하는 데 사용되었습니다.

**HealthKit**
- 건강 및 피트니스 데이터를 수집하고 관리하는 프레임워크입니다.
- 사용자의 건강 데이터를 측정하고 관리하여 러닝 데이터를 기록하는 데 사용되었습니다.

**CoreMotion**
- iOS 및 watchOS 기기에서 센서 데이터를 수집하고 처리하는 프레임워크입니다.
- 사용자의 움직임을 추적하여 러닝 경로를 보다 정확하게 기록하는 데 사용되었습니다.

**ActivityKit**
- 실시간으로 업데이트되는 라이브 액티비티를 생성할 수 있게 해주는 프레임워크입니다.
-  사용자의 실시간 러닝 정보를 잠금화면에 표시하는 데 사용되었습니다.
---
## ⭐ Main Feature
### GPS Art 러닝
- 사용자는 제공된 코스를 선택해 가이드라인을 따라 러닝하며, 러닝 중 실시간으로 경로와 완성도를 확인할 수 있습니다.
- 러닝이 끝나면 거리, 시간, 칼로리, 심박수, 패이스 등의 데이터를 확인하고, 완성도 점수를 받을 수 있습니다.
- 코스 내 핫스팟 정보를 제공하여 주변 환경을 즐기면서 달릴 수 있습니다.

### 자유 러닝
- 사용자는 자유 러닝을 선택하여 자유럽게 러닝할 수 있습니다.

### 러닝 모아보기
- 완료된 러닝 기록은 카드 형태로 정리되며, 최신순, 오래된 순, 점수 순으로 정렬할 수 있습니다.

### 인스타 공유
- 사용자는 완료한 러닝 기록을 인스타그램에 공유할 수 있습니다.
- 배경 이미지를 촬영하거나 선택하여 러닝 기록을 더욱 개성 있게 꾸밀 수 있습니다.
- 4가지의 다양한 공유 방식이 제공되어, 사용자가 원하는 스타일로 러닝 기록을 공유할 수 있습니다.
  
## 🐈‍⬛ Git Branch
[Git 전략](https://github.com/yoohyebin/Outline/wiki)

## 📂 Project Structure

```
├─ .swiftlint.yml
├─ GoogleService-Info.plist
│
├─ Shared
│  ├─ Manager
│  │  ├─ LocationManager.swift
│  │  ├─ PathManager.swift
│  │  └─ ScoreManager.swift
│  └─ Model
│     ├─ GPSArtCourse.swift
│     ├─ MirroringModel.swift
│     └─ RunningRecord.swift
│
├─ Outline
│  ├─ Info.plist
│  ├─ Outline.entitlements
│  ├─ Resource
│  │  ├─ Color.xcassets
│  │  ├─ Font
│  │  ├─ Image
│  │  └─ KML
│  │  
│  ├─ Source
│  │  ├─ ContentView.swift
│  │  ├─ Manager
│  │  │  ├─ ConnectivityManager.swift
│  │  │  ├─ CourseDataUploadManager.swift
│  │  │  ├─ HapticManager.swift
│  │  │  ├─ HealthKitManager.swift
│  │  │  ├─ KMLParserManager.swift
│  │  │  ├─ MotionManager.swift
│  │  │  ├─ RunningDataManager.swift
│  │  │  └─ RunningStartManager.swift
│  │  ├─ Model
│  │  │  ├─ Auth
│  │  │  │  ├─ AppleAuthModel.swift
│  │  │  │  ├─ AuthModel.swift
│  │  │  │  └─ KakaoAuthModel.swift
│  │  │  ├─ CardModel.swift
│  │  │  ├─ Course
│  │  │  │  ├─ CourseCategoryModelType.swift
│  │  │  │  └─ CourseModel.swift
│  │  │  ├─ Place.swift
│  │  │  ├─ RunningAttributes.swift
│  │  │  ├─ Score
│  │  │  │  ├─ CourseScoreModel.swift
│  │  │  │  └─ CourseScoreModelType.swift
│  │  │  ├─ ShareModel.swift
│  │  │  ├─ TabModel.swift
│  │  │  ├─ UserData
│  │  │  │  ├─ PersistentController.swift
│  │  │  │  └─ UserDataModel.swift
│  │  │  └─ UserInfo
│  │  │     ├─ UserInfoModel.swift
│  │  │     └─ UserInfoModelType.swift
│  │  ├─ Utils
│  │  │  ├─ Component
│  │  │  │  ├─ ButtonStyle.swift
│  │  │  │  ├─ Card
│  │  │  │  │  ├─ BigCard.swift
│  │  │  │  │  ├─ BigCardBackside.swift
│  │  │  │  │  ├─ BigCardFrontside.swift
│  │  │  │  │  └─ ScoreShimmer.swift
│  │  │  │  ├─ CardBorder.swift
│  │  │  │  ├─ CompleteButton.swift
│  │  │  │  ├─ Confetti
│  │  │  │  │  ├─ Confetti.swift
│  │  │  │  │  ├─ ConfettiShapes.swift
│  │  │  │  │  └─ ConfettiView.swift
│  │  │  │  ├─ CountDown.swift
│  │  │  │  ├─ GuideToFreeRunningSheet.swift
│  │  │  │  ├─ NeedLoginSheet.swift
│  │  │  │  ├─ PermissionSheet.swift
│  │  │  │  ├─ PreferenceKey.swift
│  │  │  │  ├─ RunningFinishPopUp.swift
│  │  │  │  ├─ RunningPopup.swift
│  │  │  │  ├─ ScoreStar.swift
│  │  │  │  ├─ Shimmer.swift
│  │  │  │  ├─ SlideToUnlock.swift
│  │  │  │  └─ UnderlineButton.swift
│  │  │  └─ Extension
│  │  │     ├─ ArrayExtension.swift
│  │  │     ├─ CoordinateExtension.swift
│  │  │     ├─ DateExtention.swift
│  │  │     ├─ DoubleExtension.swift
│  │  │     ├─ FontExtension.swift
│  │  │     └─ ViewExtension.swift
│  │  ├─ View
│  │  │  ├─ FininshRunning
│  │  │  │  ├─ FinishRunningMapView.swift
│  │  │  │  └─ FinishRunningView.swift
│  │  │  ├─ FreeRunning
│  │  │  │  ├─ FreeRunningHomeView.swift
│  │  │  │  └─ FreeRunningMapView.swift
│  │  │  ├─ GPSArtHome
│  │  │  │  ├─ BigCardView.swift
│  │  │  │  ├─ CardDetailInformationMapView.swift
│  │  │  │  ├─ CardDetailInformationView.swift
│  │  │  │  ├─ CardDetailMap.swift
│  │  │  │  ├─ CardDetailMapView.swift
│  │  │  │  ├─ CardDetailView.swift
│  │  │  │  ├─ CategoryScrollView.swift
│  │  │  │  ├─ GPSArtHomeHeader.swift
│  │  │  │  ├─ GPSArtHomeView.swift
│  │  │  │  ├─ MapInfoView.swift
│  │  │  │  └─ RankingScrollView.swift
│  │  │  ├─ LookAround
│  │  │  │  └─ LookAroundView.swift
│  │  │  ├─ Mirroring
│  │  │  │  ├─ MirroringMapView.swift
│  │  │  │  ├─ MirroringMetricsView.swift
│  │  │  │  ├─ MirroringNavigationView.swift
│  │  │  │  ├─ MirroringView.swift
│  │  │  │  └─ Mirroringsheet.swift
│  │  │  ├─ Onboarding
│  │  │  │  ├─ HealthAuthView.swift
│  │  │  │  ├─ InputNicknameView.swift
│  │  │  │  ├─ InputUserInfoView.swift
│  │  │  │  ├─ LoginView.swift
│  │  │  │  └─ NotificationAuthView.swift
│  │  │  ├─ Profile
│  │  │  │  ├─ ProfileHealthInfoView.swift
│  │  │  │  ├─ ProfileUserInfoView.swift
│  │  │  │  ├─ ProfileView.swift
│  │  │  │  └─ ProfileVoiceView.swift
│  │  │  ├─ Record
│  │  │  │  ├─ MapSnapshotImageView.swift
│  │  │  │  ├─ RecordCardView.swift
│  │  │  │  ├─ RecordDetailView.swift
│  │  │  │  ├─ RecordEmptyRunningView.swift
│  │  │  │  ├─ RecordGridView.swift
│  │  │  │  ├─ RecordHeaderView.swift
│  │  │  │  ├─ RecordListHeaderView.swift
│  │  │  │  ├─ RecordListView.swift
│  │  │  │  ├─ RecordLookAroundView.swift
│  │  │  │  └─ RecordView.swift
│  │  │  ├─ Running
│  │  │  │  ├─ CourseGuideView.swift
│  │  │  │  ├─ FirstRunningGuideView.swift
│  │  │  │  ├─ RunningMapView.swift
│  │  │  │  ├─ RunningMetricsView.swift
│  │  │  │  ├─ RunningNavigationView.swift
│  │  │  │  ├─ RunningView.swift
│  │  │  │  └─ TransparentBlurView.swift
│  │  │  ├─ Share
│  │  │  │  ├─ ShareMapView.swift
│  │  │  │  ├─ ShareView+Camera.swift
│  │  │  │  ├─ ShareView+Extension.swift
│  │  │  │  └─ ShareView.swift
│  │  │  ├─ Tab
│  │  │  │  ├─ HomeTabView.swift
│  │  │  │  └─ TabBar.swift
│  │  │  └─ TestView
│  │  │     ├─ MapSnapshotTestView.swift
│  │  │     └─ PathManagerTestView.swift
│  │  └─ ViewModel
│  │     ├─ FinishRunningViewModel.swift
│  │     ├─ GPSArtHomeViewModel.swift
│  │     ├─ HealthAuthViewModel.swift
│  │     ├─ InputNicknameViewModel.swift
│  │     ├─ InputUserInfoViewModel.swift
│  │     ├─ Login
│  │     │  └─ LoginViewModel.swift
│  │     ├─ ProfileUserInfoViewModel.swift
│  │     ├─ ProfileViewModel.swift
│  │     ├─ RecordViewModel.swift
│  │     ├─ RunningMapViewModel.swift
│  │     └─ ShareViewModel.swift
│  └─ UserCoreDataModel.xcdatamodeld
│     └─ UserCoreDataModel.xcdatamodel
│        └─ contents
│ 
├─ Outline Watch
│  ├─ Info.plist
│  ├─ Resource
│  │  ├─ Font
│  │  ├─ Image
│  │  └─ WatchColor.xcassets
│  │
│  └─ Source
│     ├─ ContentWatchView.swift
│     ├─ DesignSystem
│     │  ├─ Component
│     │  │  ├─ Confetti
│     │  │  │  ├─ Confetti.swift
│     │  │  │  ├─ ConfettiShapes.swift
│     │  │  │  └─ ConfettiWatchView.swift
│     │  │  ├─ ControlButton.swift
│     │  │  ├─ ElapsedTime.swift
│     │  │  ├─ EndRunningSheet.swift
│     │  │  ├─ FinalImage.swift
│     │  │  ├─ PermissionSheet.swift
│     │  │  └─ TwoButtonSheet.swift
│     │  └─ Extension
│     │     ├─ ArrayExtension.swift
│     │     ├─ CoordinateExtension.swift
│     │     ├─ DoubleExtension.swift
│     │     └─ FontExtension.swift
│     ├─ Manager
│     │  ├─ ConnectivityManager.swift
│     │  ├─ WatchRunningManager.swift
│     │  └─ WatchWorkoutManager.swift
│     ├─ View
│     │  ├─ CountDownView.swift
│     │  ├─ CourseDetailView.swift
│     │  ├─ CourseListWatchView.swift
│     │  ├─ EmptyContentView.swift
│     │  ├─ FinishWatchView.swift
│     │  ├─ Mirroring
│     │  │  ├─ MirroringControlsView.swift
│     │  │  ├─ MirroringMapWatchView.swift
│     │  │  ├─ MirroringMetricsView.swift
│     │  │  ├─ MirroringNavigationWatchView.swift
│     │  │  └─ MirroringTabWatchView.swift
│     │  ├─ Running
│     │  │  ├─ ControlsView.swift
│     │  │  ├─ MapWatchView.swift
│     │  │  ├─ MetricsView.swift
│     │  │  ├─ NavigationTabView.swift
│     │  │  └─ TabWatchView.swift
│     │  └─ SummaryView.swift
│     └─ ViewModel
│        └─ CourseListWatchViewModel.swift
│
└─ OutlineLiveActivity
   ├─ AppIntent.swift
   ├─ Assets.xcassets
   │  ├─ AccentColor.colorset
   │  │  └─ Contents.json
   │  ├─ AppIcon.appiconset
   │  │  └─ Contents.json
   │  ├─ Contents.json
   │  └─ WidgetBackground.colorset
   │     └─ Contents.json
   ├─ Info.plist
   ├─ OutlineLiveActivity.swift
   └─ OutlineLiveActivityBundle.swift
```
---

## 👩🏻‍💻 Role
- 서비스 기획
- UI 및 인터랙션 구현
- Map 기능 개발
 - 사용자의 이동경로 추적
 - 가이드라인 표시
 - 경로 보정을 위한 Smoothing Algorithm 구현
- 인스타 공유 기능 구현

## 💡 Learnings and Insights
- Daily Scrum과 주간 회고를 통해 팀원들과 진행 상황을 공유하고 효과적으로 소통할 수 있었습니다.
- 프로젝트의 구조를 체계적으로 설계하는 방법을 배웠습니다.
- 코드 리뷰를 통해 팀원들과 코드 스타일을 통일하고, 더 효율적인 코드 작성 방법을 익힐 수 있었습니다.
