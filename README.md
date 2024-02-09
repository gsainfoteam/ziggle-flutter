# 🔥 ziggle flutter

[bloc](https://bloclibrary.dev/)을 기반으로 아키텍쳐를 구성했습니다.

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
