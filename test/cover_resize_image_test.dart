import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ziggle/app/modules/common/presentation/utils/cover_resize_image.dart';

/// Fails every load, like a thumbnail requested while offline.
class _FailingImage extends ImageProvider<_FailingImage> {
  int loads = 0;

  @override
  Future<_FailingImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(_FailingImage key, ImageDecoderCallback _) {
    loads++;
    return OneFrameImageStreamCompleter(
      Future<ImageInfo>.error(Exception('offline')),
    );
  }
}

Future<void> _resolveAndFail(ImageProvider provider) async {
  final stream = provider.resolve(ImageConfiguration.empty);
  stream.addListener(ImageStreamListener((_, _) {}, onError: (_, _) {}));
  // Let the load fail and the eviction microtask run.
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() => PaintingBinding.instance.imageCache.clear());

  test('a failed load is retried for the same size', () async {
    final inner = _FailingImage();
    final image = CoverResizeImage(inner, width: 100, height: 100);

    await _resolveAndFail(image);
    await _resolveAndFail(image);

    expect(inner.loads, 3);
  });

  test('coverScale fills both sides of the box', () {
    expect(
      CoverResizeImage.coverScale(
        intrinsicWidth: 400,
        intrinsicHeight: 200,
        width: 100,
        height: 100,
      ),
      0.5,
    );
  });
}
