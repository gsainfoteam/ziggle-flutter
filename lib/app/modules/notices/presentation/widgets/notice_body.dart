import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
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
  bool _initial = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: InAppWebView(
        initialSettings: InAppWebViewSettings(
          builtInZoomControls: false,
          supportZoom: false,
          disableVerticalScroll: true,
          disableHorizontalScroll: true,
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          if (_initial) {
            _initial = false;
            return NavigationActionPolicy.ALLOW;
          }
          final uri = navigationAction.request.url?.uriValue;
          if (uri != null) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          return NavigationActionPolicy.CANCEL;
        },
        onWebViewCreated: (controller) async {
          controller.addJavaScriptHandler(
            handlerName: 'Resize',
            callback: (arguments) => setState(
              () => _height = arguments.first.toDouble(),
            ),
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
                    font-family: Pretendard;
                    font-size: 1rem;
                    line-height: 1.5;
                    font-weight: 400;
                  }
                  #content {
                    overflow: auto;
                    user-select: none;
                    -webkit-user-select: none;
                  }
                  p {
                    margin-top: 1rem;
                    margin-bottom: 1rem;
                  }
                  a {
                    color: ${Palette.textGreyDark.toHex()};
                  }
                  img {
                    max-width: 100%;
                    height: auto;
                  }
                </style>
              </head>
              <body>
                <div id="content">
                  ${widget.body.replaceAll('src="//', 'src="https://')}
                </div>
              </body>
            </html>
          ''',
        ),
      ),
    );
  }
}
