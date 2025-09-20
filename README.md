# 🔥 ziggle flutter

본 프로젝트는 Flutter 3.32 버전을 기반으로 작성되었습니다.

[bloc](https://bloclibrary.dev/)을 기반으로 아키텍쳐를 구성했습니다.

```
├── android: 안드로이드 관련
│   └── fastlane: 안드로이드 자동 배포
├── assets: 앱에서 사용 되는 스태틱 에셋들. pubspec.yaml 파일에서 앱에 포함할 에셋을 설정할 수 있다
│   ├── fonts: 라이센스도 같이 추가
│   ├── i18n: 번역 파일 - 영어를 기본(base)으로 하여 다른 언어(ko)를 추가
│   ├── icons: svg 아이콘들
│   ├── images: x2.0, x3.0, x4.0 등의 해상도에 맞게 이미지를 추가
│   └── logo: 앱 내 로고, 스플래시 등에 쓰임
├── ios: iOS 관련
│   └── fastlane: iOS 자동 배포
├── lib: dart 코드
│   ├── app
│   │   ├── di: dependency injection
│   │   │   └── module.dart: @injectable, @singleton 등의 어노테이션으로만 주입할 수 없는 복잡한 의존성을 주입
│   │   ├── modules
│   │   │   ├── core: 공통적으로 사용되는 파일들
│   │   │   └── <module name>: 도메인별로 사용되는 파일들
│   │   │       ├── data
│   │   │       │   ├── data_sources: 데이터를 가져오는 곳
│   │   │       │   │   └── remote: api; retrofit을 사용
│   │   │       │   ├── enums
│   │   │       │   ├── models: entity를 implement하며 json_serializable, freezed를 사용
│   │   │       │   └── repositories: domain에서 선언한 abstract class를 implement
│   │   │       ├── domain
│   │   │       │   ├── entities: 순수한 dart object
│   │   │       │   ├── enums
│   │   │       │   └── repositories: 행위를 정의한 abstract class
│   │   │       └── presentation
│   │   │       │   ├── bloc: 비즈니스 로직을 담당하는 파일들
│   │   │       │   ├── cubit: Cubit형태의 Bloc
│   │   │       │   ├── pages: 화면을 구성하는 파일들
│   │   │       │   └── widgets: 화면을 구성하는 작은 파일들
│   │   └── router: 새로운 페이지를 추가할 때 여기 있는 파일들을 수정
│   │   │   └── routes.dart: 메인 라우트 파일. part로 다른 서브 라우트들을 가져옴.
│   │   ├── modules
│   │   │   ├── emojis.dart: 커스텀 이모지 (TossFace에서 가져온) 선언
│   │   │   ├── fonts.dart: 다이나믹 폰트 설정 (Pretendard)
│   │   │   ├── palette.dart: 앱에서 사용되는 색상들
│   │   │   ├── strings.dart: 앱에서 사용되는 문자열들
│   │   │   └── theme.dart: 앱의 테마 설정. 머티리얼 위젯의 설정을 한번에 변경 가능
│   │   └── app.dart: 글로벌한 Provider, Listener 설정
│   ├── gen: 자동 생성된 파일 -- 여기에서는 flutter_gen_runner가 생성한 파일이 위치
│   ├── app_bloc_observer.dart -- bloc의 상태 변화를 모니터링 (콘솔에서 `!transition`을 입력하여 무시 가능)
|   └── main.dart: 처음으로 실행되는 파일. main 함수가 위치. 앱 실행시 초기 작업 수행 (SDK 초기화 등)
├── analysis_options.yaml: lint 설정 파일. (자동 생성된 *.g.dart 파일을 무시함)
├── build.yaml: json_serializable이 snake case로 생성 시키기 위한 설정 파일
├── flutter_launcher_icons.yaml: 앱 아이콘 자동 생성 설정 파일 (dart run flutter_launcher_icons)
├── flutter_native_splash.yaml: 앱 스플래시 자동 생성 설정 파일 (dart run flutter_native_splash:create)
├── pubspec.lock
├── pubspec.yaml: package.json 같은 파일. 앱의 버전, 패키지들이 저장 됨
└── slang.yaml: 번역을 위한 설정 파일.
```

## 실행법

slang을 사용하여 번역 파일을 생성하고, build_runner를 사용하여 코드를 생성합니다.

```bash
dart run slang
dart run slang watch
dart run build_runner build
dart run build_runner watch
```

또는 watchexec를 사용해서 pubspec.lock 파일이 수정 될 때에
build_runner가 작동을 멈추지 않도록 할 수 있습니다.

```bash
# ubuntu
apt install watchexec
# mac
brew install watchexec
watchexec -w ./pubspec.lock dart run build_runner watch
watchexec -r -w ./build.yaml dart run slang watch
```

IOS 앱 빌드를 위해선 flutterfire_cli가 설치되어야 합니다.

```bash
dart pub global activate flutterfire_cli
```