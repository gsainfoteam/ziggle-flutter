# Maestro E2E 테스트

Android 에뮬레이터와 iOS 시뮬레이터에서 공지를 읽고 쓰는 사용자 행동을 스테이징 API로 검증합니다. 단위·위젯 테스트는 `flutter test`로 PR마다 실행하고, 여기의 시나리오는 기기가 필요한 경우에만 실행합니다.

## 시나리오

| 파일 | 태그 | 사용자 행동 | 통과 기준 |
|---|---|---|---|
| `01_read_notice.yaml` | core | 로그인하고 피드에서 공지 읽기 | 스테이징 계정으로 로그인한 뒤 준비한 공지를 열면 제목과 본문이 보입니다. 뒤로 한 번 가면 피드로 돌아옵니다. |
| `02_publish_notice.yaml` | core | 공지를 게시하고 다시 읽기 | 실행마다 고유한 제목과 본문으로 게시합니다. 피드를 새로 조회해 다시 열었을 때 입력한 내용이 그대로 보입니다. |
| `03_open_link_cold.yaml` | core | 앱이 꺼진 상태에서 공지 링크 열기 | 로그인 상태로 앱을 종료한 뒤 OS가 `/app?redirect=…` 링크를 엽니다. 공지가 한 번 열리고 뒤로 한 번 가면 홈이 보입니다. |
| `04_restore_draft.yaml` | extended | 임시 저장한 글 이어 쓰기 | 제목과 본문을 임시 저장하고 앱을 종료합니다. 다시 실행해 작성 화면에 들어가면 두 필드가 모두 복원됩니다. |
| `05_reaction.yaml` | extended | 피드와 상세에서 불 반응 추가·취소 | 피드에서 불을 누르면 상세에도 내 반응이 표시되고 개수가 1 늘어납니다. 상세에서 취소하고 피드를 새로고침하면 원래 개수로 돌아옵니다. |
| `06_share.yaml` | extended | 피드와 상세에서 공유하기 | 두 위치에서 각각 공유 버튼을 누르면 OS 공유 창이 열리고, 취소하면 원래 보던 화면으로 돌아옵니다. |

각 시나리오는 단독으로 실행할 수 있습니다. 시나리오마다 앱 데이터를 지우고 로그인부터 시작합니다. 여러 시나리오가 함께 쓰는 단계는 `shared/`에 두고 `runFlow`로 불러옵니다.

- `launch_signed_in.yaml`: 앱 데이터를 지우고 실행한 뒤 로그인합니다.
- `login.yaml`: IdP 로그인 화면과 동의 화면을 거쳐 피드까지 이동합니다.
- `open_notice_from_feed.yaml`: 피드에서 `NOTICE_ID` 공지를 찾아 상세를 엽니다.

앱의 요소는 문구 대신 `Semantics(identifier: …)`로 찾습니다. 예를 들어 피드 카드는 `notice.card.<id>`, 상세의 불 반응은 `notice.detail.reaction.like`입니다. 따라서 기기 언어와 관계없이 같은 시나리오가 동작합니다. 시스템 알림창과 IdP 웹 화면은 기기 언어를 따르므로, 해당 문구를 영어와 한국어 정규식으로 함께 찾습니다.

## 테스트 데이터

`scripts/e2e/run.sh`는 시나리오를 실행하기 전에 `scripts/e2e/fixtures.dart`로 스테이징에 테스트 공지를 만듭니다. 읽기·링크·반응·공유 시나리오는 실행 ID가 들어간 각자의 공지를 사용하므로, Android와 iOS를 동시에 실행해도 반응 수나 제목이 섞이지 않습니다. 게시 시나리오는 앱에서 직접 공지를 만듭니다.

테스트 공지의 제목은 모두 `[E2E]`로 시작합니다. 실행이 끝나면 성공 여부와 관계없이 이번 실행의 공지와 1시간 이상 남아 있는 `[E2E]` 공지를 삭제합니다. 백엔드는 공지를 생성하면 일정 시간 뒤에 전체 푸시를 보내고, 그 전에 공지가 삭제되면 푸시를 취소합니다. 따라서 정리 단계는 시나리오가 끝난 직후에 실행됩니다.

## 준비

- E2E 앱: 스테이징 API를 명시적으로 사용하는 디버그 빌드입니다(`--dart-define=ZIGGLE_API_CHANNEL=staging`). iOS 시뮬레이터는 디버그 빌드만 실행할 수 있으므로 두 OS 모두 디버그 빌드를 사용합니다. 디버그 빌드는 테스트용 분석 저장소를 사용하므로 Amplitude와 Firebase Analytics에 이벤트를 보내지 않습니다.
- `.env`: 저장소 변수 `DOTENV`의 내용과 같습니다. 분석 키는 넣지 않습니다.
- 테스트 계정: `E2E_IDP_EMAIL`, `E2E_IDP_PASSWORD`에 IdP 테스트 계정을 넣습니다. 이 계정은 한 번 이상 앱에서 로그인해서 지글에 동의한 상태여야 합니다. CI에서는 같은 이름의 저장소 secret을 사용합니다.
- 도구: Flutter(`.fvmrc`의 버전), [Maestro CLI](https://docs.maestro.dev/getting-started/installing-maestro) 2.12.1, Android SDK 또는 Xcode가 필요합니다.

## 로컬 실행

기기를 하나 켜고 아래 명령을 실행합니다. CI도 같은 스크립트를 사용합니다.

```sh
dart run slang && dart run build_runner build

# Android 에뮬레이터
scripts/e2e/app.sh build android
scripts/e2e/app.sh install android
scripts/e2e/run.sh --include-tags core

# iOS 시뮬레이터
scripts/e2e/app.sh build ios
scripts/e2e/app.sh install ios <udid>
scripts/e2e/run.sh --device <udid> .maestro/flows/05_reaction.yaml
```

Android에서 `app.sh install`은 디버그 빌드가 `ziggle.gistory.me` 링크를 열 수 있도록 링크 처리를 켭니다. 디버그 빌드는 `assetlinks.json`에 등록된 키로 서명되지 않아 도메인 인증에 실패하기 때문입니다. 기기가 여러 대 연결되어 있다면 `--device`로 기기를 지정해야 합니다.

결과는 실행마다 `build/e2e/<실행 ID>`에 저장되고, `E2E_OUTPUT_DIR`을 지정하면 그 경로에 저장됩니다. `junit.xml`에는 시나리오별 결과가 기록되고, `debug/<시나리오>/`에는 단계별 스크린샷과 화면 계층, Maestro 로그, 기기 로그가 저장됩니다. Maestro는 입력한 문자열을 로그에 남기므로, `run.sh`는 실행이 끝나면 결과 파일에서 비밀번호를 지웁니다.

## CI

`.github/workflows/e2e.yml`이 Android(API 35 에뮬레이터)와 iOS(macos-15-intel의 최신 iPhone 시뮬레이터)에서 시나리오를 실행합니다.

iOS는 메모리가 14GB인 Intel 러너에서 실행합니다. 메모리가 7GB인 arm64 러너(macos-26)에서는 iOS 26 시뮬레이터와 Maestro가 메모리를 모두 차지했습니다. 그래서 호스트가 실행 파일을 디스크에서 계속 다시 읽었고, 시뮬레이터가 새 프로세스를 시작하는 데 몇 분씩 걸려 시나리오가 시간 초과로 실패했습니다(#734). 실행 요약의 마지막 줄에 호스트 메모리와 swap 사용량이 표시되므로, swap을 사용했다면 같은 원인을 먼저 의심합니다. GitHub는 마지막 Intel 이미지인 macos-15-intel을 2027년 가을에 종료하므로, 그 전에 메모리가 더 큰 러너로 옮겨야 합니다.

| 시점 | 실행 방법 | 범위 |
|---|---|---|
| 내부 배포 전 | `upload.yml`이 `development`에 push된 커밋으로 호출합니다. 두 OS에서 모두 통과해야 Play 내부 트랙과 TestFlight 업로드를 시작합니다. 저장소 변수 `E2E_GATE`가 `true`일 때만 동작합니다. | core(1~3) |
| PR 리뷰 중 | 기기 확인이 필요할 때 Actions에서 `E2E (Maestro)`를 수동으로 실행합니다. PR의 head SHA, OS, 시나리오를 선택합니다. PR 커밋마다 자동으로 실행하지는 않습니다. | core 또는 선택한 시나리오 |
| 스토어 출시 후보 | 릴리스를 발행하기 전에 후보 커밋으로 `suite=release`를 수동 실행합니다. | 전체(1~6) |

같은 커밋·OS·환경에서 이미 통과한 시나리오는 다시 실행하지 않고 그 결과를 재사용합니다. 환경은 워크플로의 `E2E_ENVIRONMENT` 값으로 구분하므로, 기기 이미지나 스테이징 구성이 바뀌면 이 값을 올립니다. 각 실행의 요약에는 시나리오별 결과와 소요 시간이 표시되고, 결과 파일은 7일 동안 아티팩트로 보관됩니다.
