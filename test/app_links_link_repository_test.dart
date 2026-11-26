import 'package:flutter_test/flutter_test.dart';
import 'package:ziggle/app/modules/core/data/repositories/app_links_link_repository.dart';

String? path(String link) =>
    AppLinksLinkRepository.toAppPath(Uri.tryParse(link));

void main() {
  group('a shared notice link', () {
    test('opens the notice', () {
      expect(path('https://ziggle.gistory.me/notice/123'), '/notice/123');
    });

    test('ignores a trailing slash, query and fragment', () {
      expect(path('https://ziggle.gistory.me/notice/123/'), '/notice/123');
      expect(
        path('https://ziggle.gistory.me/notice/123?utm_source=x#top'),
        '/notice/123',
      );
    });

    // Android's `LinkActivity.normalize` decodes the same escapes.
    test('decodes escaped unreserved characters in the path', () {
      expect(path('https://ziggle.gistory.me/notice/%31%32%33'), '/notice/123');
      expect(path('https://ziggle.gistory.me/notice/123%2F'), isNull);
    });

    test('accepts the host in any case', () {
      expect(path('https://Ziggle.Gistory.me/notice/123'), '/notice/123');
    });
  });

  group('an /app redirect link', () {
    test('opens a redirect path', () {
      expect(
        path('https://ziggle.gistory.me/app?redirect=/notice/123'),
        '/notice/123',
      );
    });

    test('opens a full redirect URL from the web app banner', () {
      final redirect = Uri.encodeComponent(
        'https://ziggle.gistory.me/notice/123',
      );
      expect(
        path('https://ziggle.gistory.me/app?redirect=$redirect'),
        '/notice/123',
      );
    });

    test('ignores a redirect to another site', () {
      final redirect = Uri.encodeComponent('https://example.com/notice/123');
      expect(path('https://ziggle.gistory.me/app?redirect=$redirect'), isNull);
      expect(
        path('https://ziggle.gistory.me/app?redirect=//example.com/notice/1'),
        isNull,
      );
    });

    test('ignores a missing redirect', () {
      expect(path('https://ziggle.gistory.me/app'), isNull);
      expect(path('https://ziggle.gistory.me/app/'), isNull);
    });
  });

  group('ignores', () {
    for (final link in [
      'https://ziggle.gistory.me/',
      'https://ziggle.gistory.me/home',
      'https://ziggle.gistory.me/notice',
      'https://ziggle.gistory.me/notice/abc',
      'https://ziggle.gistory.me/notice/123/edit',
      'https://ziggle.gistory.me/app?redirect=/home',
      'https://example.com/notice/123',
      'http://ziggle.gistory.me/notice/123',
      'ziggle-idp-login-redirect://callback?code=x',
      '::not a url',
    ]) {
      test(link, () => expect(path(link), isNull));
    }
  });
}
