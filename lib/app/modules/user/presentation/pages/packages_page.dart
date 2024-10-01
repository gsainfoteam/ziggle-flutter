import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: context.t.common.back,
        from: PageSource.unknown,
        title: Text(context.t.user.setting.information.openSourceLicense),
      ),
      body: FutureBuilder(
        future: LicenseRegistry.licenses.fold(
          <String, List<LicenseParagraph>>{},
          (previous, element) {
            if (element.packages.isEmpty) {
              return previous;
            }
            for (final package in element.packages) {
              if (!previous.containsKey(package)) {
                previous[package] = element.paragraphs.toList();
              } else {
                previous[package]!.addAll(element.paragraphs);
              }
            }
            return previous;
          },
        ).then(
          (value) =>
              value.entries.sortedBy((a) => a.key.toLowerCase()).toList(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }
          final data = snapshot.data!;
          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (context, index) =>
                Container(height: 1, color: Palette.grayBorder),
            itemBuilder: (context, index) {
              final item = data[index];
              return ZigglePressable(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(item.key)),
                      Assets.icons.chevronRight.svg(),
                    ],
                  ),
                ),
                onPressed: () => PackageLicensesRoute(
                  package: item.key,
                  licenses: item.value,
                ).push(context),
              );
            },
          );
        },
      ),
    );
  }
}
