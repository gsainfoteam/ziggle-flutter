# 🔥 ziggle flutter

[getx_pattern](https://github.com/kauemurakami/getx_pattern)을
기반으로 아키텍쳐를 구성했습니다.

```
├── android: 안드로이드 관련
├── assets: 앱에서 사용 되는 스태틱 에셋들. pubspec.yaml 파일에서 앱에 포함할 에셋을 설정할 수 있다
│   ├── fonts
│   ├── icons
│   └── logo
├── build: 빌드 관련 폴더
├── debug-info: 빌드시 심볼이 저장 되는 폴더 (fastlane 사용시 여기에 저장)
├── ios: iOS 관련
│   └── fastlane: iOS 자동 배포
├── lib: dart 코드
│   ├── app
│   │   ├── core: 앱 전역적으로 사용되는 파일들이 위치
│   │   │   ├── theme
│   │   │   │   ├── app.dart: 앱에서 사용되는 ThemeData
│   │   │   │   └── text.dart: TextStyles 클래스
│   │   │   ├── utils
│   │   │   │   └── functions: 유틸 함수들
│   │   │   └── values
│   │   │       ├── colors.dart: Palette 클래스
│   │   │       ├── shadows.dart: 앱에서 사용되는 그림자들
│   │   │       └── strings.dart: api url등
│   │   ├── data
│   │   │   ├── enums
│   │   │   ├── model: freezed와 json_serializable을 사용한 모델들
│   │   │   └── provider
│   │   │       └── api.dart: retrofit 파일
│   │   ├── global_widgets: 앱에서 사용되는 위젯들이 위치
│   │   ├── modules
│   │   │   └── <module name>
│   │   │       ├── <local widget>.dart
│   │   │       ├── binding.dart: controller와 repository를 injection
│   │   │       ├── controller.dart: mvvm의 view model에 해당
│   │   │       ├── page.dart: mvvm의 view에 해당
│   │   │       └── repository.dart: mvvm의 model에 해당
│   │   └── routes: 새로운 페이지를 추가할 때 모듈을 추가하고 여기 있는 파일들을 수정
│   │       ├── pages.dart: 라우트 설정 파일 (path, binding, page)
│   │       └── routes.dart: 라우트 path 이름들이 위치
│   ├── gen: 자동 생성된 파일 -- 여기에서는 flutter_gen_runner가 생성한 파일이 위치
│   ├── app.dart
│   ├── binding.dart: initial binding 관리. getx service 등록 등
|   └── main.dart: 처음으로 실행되는 파일. main 함수가 위치. 앱 실행시 초기 작업 수행 (SDK 초기화 등)
├── analysis_options.yaml: lint 설정 파일. (자동 생성된 *.g.dart 파일을 무시함)
├── build.yaml: json_serializable이 snake case로 생성 시키기 위한 설정 파일
├── flutter_launcher_icons.yaml: 앱 아이콘 자동 생성 설정 파일 (dart run flutter_launcher_icons)
├── flutter_native_splash.yaml: 앱 스플래시 자동 생성 설정 파일 (dart run flutter_native_splash:create)
├── pubspec.lock
└── pubspec.yaml: package.json 같은 파일. 앱의 버전, 패키지들이 저장 됨
```

특별히 root 모듈은 home, search, write 모듈을 포함하고 있기 때문에
home, search, write 모듈은 binding.dart 파일이 없습니다.

build_runner를 사용하여 코드를 생성합니다.

```bash
dart run build_runner build
dart run build_runner watch
```

또는 watchexec를 사용해서 pubspec.lock 파일이 수정 될 때에
build_runner가 작동을 멈추지 않도록 할 수 있습니다.

```bash
apt install watchexec
brew install watchexec
watchexec -w ./pubspec.lock dart run build_runner watch
```
