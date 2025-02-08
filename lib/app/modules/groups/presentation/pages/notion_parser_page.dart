import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/groups/presentation/blocs/notion_bloc.dart';
import 'package:ziggle/app/modules/groups/presentation/pages/notion_page.dart';

@RoutePage()
class NotionParserPage extends StatelessWidget {
  const NotionParserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotionBloc>(),
      child: NotionPage(),
    );
  }
}
