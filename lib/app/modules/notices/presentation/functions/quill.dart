import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';

Document documentFromHtml(String html) =>
    Document.fromDelta(HtmlToDelta().convert(html));
