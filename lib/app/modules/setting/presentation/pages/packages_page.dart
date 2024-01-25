import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/gen/strings.g.dart';

class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.setting.openSourceLicenses),
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
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                title: Text(item.key),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => LicenseRoute.fromParagraph(item.key, item.value)
                    .push(context),
              );
            },
          );
        },
      ),
    );
  }
}
