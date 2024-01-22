import 'package:flutter/material.dart';

import '../../domain/enums/notice_type.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key, required this.type});

  final NoticeType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.label),
      ),
    );
  }
}
