import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// [BoxFit.cover]로 [width] x [height] 픽셀 영역을 채우는 데 필요한 크기로만
/// [imageProvider]를 디코딩한다.
///
/// [ResizeImage]는 가로나 세로 중 하나만 지정하거나 영역 안에 맞추는(fit) 방식만
/// 지원해서, cover로 그릴 때 이미지 비율에 따라 해상도가 모자랄 수 있다. 이
/// provider는 원본 비율을 유지한 채 두 변이 모두 영역 이상이 되는 가장 작은
/// 크기로 디코딩하고, 원본보다 크게 늘리지는 않는다.
///
/// 캐시 키에 크기가 포함되므로 같은 이미지를 원본 크기로 쓰는 화면(공지 상세
/// 등)의 캐시와 섞이지 않는다.
class CoverResizeImage extends ImageProvider<CoverResizeImageKey> {
  const CoverResizeImage(
    this.imageProvider, {
    required this.width,
    required this.height,
  });

  final ImageProvider imageProvider;

  /// 채울 영역의 물리 픽셀 크기.
  final int width;
  final int height;

  @override
  Future<CoverResizeImageKey> obtainKey(ImageConfiguration configuration) {
    // 캐시된 이미지가 다음 프레임까지 비어 보이지 않도록, 내부 provider가
    // 키를 동기적으로 주면 이쪽도 동기적으로 돌려준다. (ResizeImage와 같은 방식)
    Completer<CoverResizeImageKey>? completer;
    SynchronousFuture<CoverResizeImageKey>? result;
    imageProvider.obtainKey(configuration).then((key) {
      final resized = CoverResizeImageKey._(key, width, height);
      if (completer == null) {
        result = SynchronousFuture(resized);
      } else {
        completer.complete(resized);
      }
    });
    if (result != null) return result!;
    completer = Completer<CoverResizeImageKey>();
    return completer.future;
  }

  @override
  ImageStreamCompleter loadImage(
    CoverResizeImageKey key,
    ImageDecoderCallback decode,
  ) {
    Future<ui.Codec> decodeCover(
      ui.ImmutableBuffer buffer, {
      ui.TargetImageSizeCallback? getTargetSize,
    }) => decode(
      buffer,
      getTargetSize: (intrinsicWidth, intrinsicHeight) {
        final scale = coverScale(
          intrinsicWidth: intrinsicWidth,
          intrinsicHeight: intrinsicHeight,
          width: width,
          height: height,
        );
        if (scale >= 1) return const ui.TargetImageSize();
        return ui.TargetImageSize(
          width: (intrinsicWidth * scale).ceil(),
          height: (intrinsicHeight * scale).ceil(),
        );
      },
    );
    final completer = imageProvider.loadImage(
      key._providerCacheKey,
      decodeCover,
    );
    // 로드에 실패하면 이 키로 등록된 캐시 항목도 지운다. 남겨 두면 같은 크기의
    // 카드가 실패한 completer를 계속 재사용해서 다시 로드하지 않는다.
    // 오류가 동기적으로 나면 캐시가 아직 키를 등록하기 전일 수 있으므로
    // microtask에서 지운다. (ResizeImage와 같은 방식)
    completer.addEphemeralErrorListener((_, _) {
      scheduleMicrotask(() => PaintingBinding.instance.imageCache.evict(key));
    });
    return completer;
  }

  /// 원본을 [width] x [height] 영역에 cover로 맞출 때의 배율.
  @visibleForTesting
  static double coverScale({
    required int intrinsicWidth,
    required int intrinsicHeight,
    required int width,
    required int height,
  }) => max(width / intrinsicWidth, height / intrinsicHeight);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CoverResizeImage')}'
      '($imageProvider, ${width}x$height)';
}

@immutable
class CoverResizeImageKey {
  const CoverResizeImageKey._(
    this._providerCacheKey,
    this._width,
    this._height,
  );

  final Object _providerCacheKey;
  final int _width;
  final int _height;

  @override
  bool operator ==(Object other) =>
      other is CoverResizeImageKey &&
      other._providerCacheKey == _providerCacheKey &&
      other._width == _width &&
      other._height == _height;

  @override
  int get hashCode => Object.hash(_providerCacheKey, _width, _height);
}
