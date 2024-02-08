part of 'routes.dart';

@TypedGoRoute<SettingRoute>(
  path: '/setting',
  routes: [
    TypedGoRoute<AboutRoute>(
      path: 'about',
      routes: [
        TypedGoRoute<PackagesRoute>(
          path: 'license',
          routes: [TypedGoRoute<LicenseRoute>(path: ':package')],
        ),
      ],
    ),
  ],
)
class SettingRoute extends GoRouteData {
  const SettingRoute();
  @override
  Widget build(context, state) => const SettingPage();
}

class AboutRoute extends GoRouteData {
  const AboutRoute();
  @override
  Widget build(context, state) => const AboutPage();
}

class PackagesRoute extends GoRouteData {
  const PackagesRoute();
  @override
  Widget build(context, state) => const PackagesPage();
}

class LicenseRoute extends GoRouteData {
  const LicenseRoute(this.package, this.$extra);
  factory LicenseRoute.fromParagraph(
    String package,
    List<LicenseParagraph> paragraphs,
  ) =>
      LicenseRoute(
        package,
        paragraphs
            .map((e) => {'text': e.text, 'indent': e.indent})
            .toList(growable: false),
      );

  final String package;
  final List<Map<String, dynamic>> $extra;
  List<LicenseParagraph> get paragraphs => $extra
      .map((e) => LicenseParagraph(e['text'], e['indent']))
      .toList(growable: false);

  @override
  Widget build(context, state) => PackageLicensesPage(
        package: package,
        licenses: paragraphs,
      );
}
