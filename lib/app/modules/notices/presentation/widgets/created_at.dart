import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/date_time.dart';
import 'package:ziggle/app/values/palette.dart';

class CreatedAt extends StatefulWidget {
  const CreatedAt({super.key, required this.createdAt});

  final DateTime createdAt;

  @override
  State<CreatedAt> createState() => _CreatedAtState();
}

class _CreatedAtState extends State<CreatedAt> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.createdAt.getTimeAgo(context),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Palette.grayText,
      ),
    );
  }
}
