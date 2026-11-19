import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/route_entrance.dart';
import 'package:ziggle/app/values/palette.dart';

class NoticeBody extends StatefulWidget {
  const NoticeBody({super.key, required this.body});

  final String body;

  @override
  State<NoticeBody> createState() => _NoticeBodyState();
}

class _NoticeBodyState extends State<NoticeBody> {
  double _height = 1;
  final _completer = Completer<void>();
  late final InAppWebViewController _controller;

  /// The WebView is created only after the page has finished sliding in.
  /// Creating it starts a WKWebView on the platform thread (which runs Dart
  /// too), and a platform view on screen makes Flutter composite every frame
  /// around it, so both would make the route transition stutter. The body
  /// starts 1 pt tall until it has loaded anyway, so nothing visible is lost.
  bool _showWebView = false;
  Animation<double>? _entrance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_showWebView || _entrance != null) return;
    final entrance = RouteEntrance.of(context);
    if (entrance == null || entrance.status == AnimationStatus.completed) {
      _showWebView = true;
      return;
    }
    _entrance = entrance..addStatusListener(_onEntranceStatus);
  }

  void _onEntranceStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _entrance?.removeStatusListener(_onEntranceStatus);
    if (mounted) setState(() => _showWebView = true);
  }

  @override
  void dispose() {
    _entrance?.removeStatusListener(_onEntranceStatus);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NoticeBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 상세 API 응답, 반응 변경 등으로 부모가 다시 빌드될 때마다 본문을 다시 쓰면
    // WebView가 레이아웃과 이미지 로딩을 처음부터 다시 한다. 상세 화면으로
    // 전환되는 도중에 이 작업이 겹치면 애니메이션이 끊기므로, 본문이 실제로
    // 바뀐 경우에만 갱신한다.
    if (oldWidget.body == widget.body) return;
    _completer.future.then((_) {
      if (mounted) _updateBody();
    });
  }

  Future<void> _updateBody() async {
    final json = jsonEncode(_body);
    await _controller.callAsyncJavaScript(
      functionBody:
          '''
      content.innerHTML = $json;
    ''',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_showWebView) return SizedBox(height: _height);
    return SizedBox(
      height: _height,
      child: InAppWebView(
        initialSettings: InAppWebViewSettings(
          supportZoom: false,
          disableVerticalScroll: true,
          disableHorizontalScroll: true,
          builtInZoomControls: false,
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          if (navigationAction.request.url.toString() == 'about:blank') {
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
              final height = (arguments.first as num).toDouble();
              // 높이가 그대로면 Flutter 레이아웃을 다시 하지 않는다.
              if ((height - _height).abs() >= 0.5) {
                setState(() => _height = height);
              }
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
          data:
              '''
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
                    color: ${Palette.grayText.css};
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
