#!/usr/bin/env bash
# Builds and installs the app that the Maestro E2E flows drive.
#
#   scripts/e2e/app.sh build android|ios
#   scripts/e2e/app.sh install android|ios [device]
#
# The E2E app is a debug build that calls the staging API explicitly
# (ZIGGLE_API_CHANNEL=staging). iOS simulators only run debug builds, so both
# platforms use the same mode. Debug builds use the mock analytics, so test
# runs send no Amplitude or Firebase Analytics events.
#
# Run `dart run slang` and `dart run build_runner build` first, and put a .env
# without analytics keys in the project root (see .maestro/README.md).
set -euo pipefail

cd "$(dirname "$0")/../.."

action="${1:-}"
platform="${2:-}"
device="${3:-}"
dart_defines=(--dart-define=ZIGGLE_API_CHANNEL=staging)
apk=build/app/outputs/flutter-apk/app-debug.apk
ios_app=build/ios/iphonesimulator/Runner.app

case "$action/$platform" in
  build/android)
    flutter build apk --debug "${dart_defines[@]}"
    echo "$apk"
    ;;
  build/ios)
    flutter build ios --simulator --debug "${dart_defines[@]}"
    echo "$ios_app"
    ;;
  install/android)
    adb_args=()
    [[ -n "$device" ]] && adb_args=(-s "$device")
    adb ${adb_args[@]+"${adb_args[@]}"} install -r "$apk"
    # A debug build is not signed with the key in assetlinks.json, so the
    # domain fails verification. Turn on link handling for it as a user
    # would in the settings, so https://ziggle.gistory.me/app links open the
    # app instead of the browser. Clearing the app data keeps this.
    adb ${adb_args[@]+"${adb_args[@]}"} shell pm set-app-links-user-selection \
      --user 0 --package me.gistory.ziggle true ziggle.gistory.me
    ;;
  install/ios)
    xcrun simctl install "${device:-booted}" "$ios_app"
    ;;
  *)
    echo "usage: $0 build|install android|ios [device]" >&2
    exit 64
    ;;
esac
