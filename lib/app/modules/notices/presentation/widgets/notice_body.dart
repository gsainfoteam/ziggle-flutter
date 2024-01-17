import 'package:flutter/material.dart';

class NoticeBody extends StatefulWidget {
  const NoticeBody({super.key, required this.body});

  final String body;

  @override
  State<NoticeBody> createState() => _NoticeBodyState();
}

class _NoticeBodyState extends State<NoticeBody> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.body);
  }
}
