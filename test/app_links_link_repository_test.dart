import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ziggle/app/modules/core/data/repositories/app_links_link_repository.dart';

/// Android's `LinkActivityTest` checks `LinkActivity.appPath` with the same
/// file, so both apps open the same links.
const _fixture = 'test/fixtures/app_links.tsv';

void main() {
  final cases = File(_fixture)
      .readAsLinesSync()
      .where((line) => line.isNotEmpty && !line.startsWith('#'))
      .map((line) => line.split('\t'));

  for (final [link, expected] in cases) {
    final path = expected == '-' ? null : expected;
    test('$link opens ${path ?? 'nothing'}', () {
      expect(AppLinksLinkRepository.toAppPath(Uri.tryParse(link)), path);
    });
  }
}
