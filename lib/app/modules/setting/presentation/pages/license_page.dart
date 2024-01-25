import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PackageLicensesPage extends StatelessWidget {
  const PackageLicensesPage({
    super.key,
    required this.package,
    required this.licenses,
  });

  final String package;
  final List<LicenseParagraph> licenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(package)),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final license in licenses)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: 16.0 * max(license.indent, 0),
                      ),
                      child: Text(
                        license.text,
                        textAlign:
                            license.indent == LicenseParagraph.centeredIndent
                                ? TextAlign.center
                                : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
