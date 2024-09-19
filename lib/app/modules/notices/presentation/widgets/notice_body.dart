import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/values/palette.dart';

class NoticeBody extends StatefulWidget {
  const NoticeBody({super.key, required this.body});

  final String body;

  @override
  State<NoticeBody> createState() => _NoticeBodyState();
}

class _NoticeBodyState extends State<NoticeBody> {
  double _height = 0;
  late bool _initial = Platform.isIOS;
  final _completer = Completer<void>();
  late final InAppWebViewController _controller;

  @override
  void didUpdateWidget(covariant NoticeBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    _completer.future.then((_) => _updateBody());
  }

  Future<void> _updateBody() async {
    final json = jsonEncode(_body);
    await _controller.callAsyncJavaScript(functionBody: '''
      content.innerHTML = $json;
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            supportZoom: false,
            disableVerticalScroll: true,
            disableHorizontalScroll: true,
          ),
          android: AndroidInAppWebViewOptions(
            builtInZoomControls: false,
          ),
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          if (_initial) {
            _initial = false;
            return NavigationActionPolicy.ALLOW;
          }
          final uri = navigationAction.request.url;
          if (uri != null) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          return NavigationActionPolicy.CANCEL;
        },
        onWebViewCreated: (controller) async {
          _controller = controller;
          controller.addJavaScriptHandler(
            handlerName: 'Resize',
            callback: (arguments) {
              if (!mounted) return;
              setState(() => _height = arguments.first.toDouble());
              if (!_completer.isCompleted) _completer.complete();
            },
          );
        },
        initialUserScripts: UnmodifiableListView([
          UserScript(
            source: '''
              const resizeObserver = new ResizeObserver((entries) =>
                window.flutter_inappwebview.callHandler('Resize', content.offsetHeight)
              );
              resizeObserver.observe(content);
            ''',
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
          ),
        ]),
        initialData: InAppWebViewInitialData(
          data: '''
            <!DOCTYPE html>
            <html>
              <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                  body {
                    margin: 0;
                    padding: 0;
                    font-family: sans-serif;
                    font-size: 1rem;
                    line-height: 1.5;
                    font-weight: 400;
                  }
                  #content {
                    overflow-x: hidden;
                    overflow-y: auto;
                  }
                  #content *[style*="width"] {
                    width: auto !important;
                    word-break: break-all;
                  }
                  p {
                    margin-top: 1rem;
                    margin-bottom: 1rem;
                  }
                  a {
                    color: #${Palette.grayText.hex};
                  }
                  img {
                    max-width: 100%;
                    height: auto;
                  }
                </style>
              </head>
              <body>
                <div id="content">
                  $_body
                </div>
              </body>
            </html>
          ''',
        ),
      ),
    );
  }

  String get _body => widget.body.replaceAll('src="//', 'src="https://');
}
