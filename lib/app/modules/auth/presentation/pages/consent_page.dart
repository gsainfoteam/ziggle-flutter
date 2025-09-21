import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ConsentPage extends StatelessWidget {
  const ConsentPage({super.key, this.onResult});
  final Function(bool)? onResult;

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
