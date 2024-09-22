import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

extension QuillControllerX on QuillController {
  String get html =>
      QuillDeltaToHtmlConverter(document.toDelta().toJson()).convert();
  set html(String html) {
    document = Document.fromDelta(HtmlToDelta().convert(html));
  }
}
