part of 'routes.dart';

@TypedGoRoute<SettingRoute>(path: '/setting', routes: [
  TypedGoRoute<InformationRoute>(path: 'information', routes: [
    TypedGoRoute<PackagesRoute>(path: 'package', routes: [
      TypedGoRoute<PackageLicensesRoute>(path: ':package'),
    ])
  ])
])
class SettingRoute extends GoRouteData {
  const SettingRoute();
  static final $parentNavigatorKey = rootNavigatorKey;
  @override
  Widget build(context, state) => const SettingPage();
}

class InformationRoute extends GoRouteData {
  const InformationRoute();
  static final $parentNavigatorKey = rootNavigatorKey;
  @override
  Widget build(context, state) => const InformationPage();
}

class PackagesRoute extends GoRouteData {
  const PackagesRoute();
  static final $parentNavigatorKey = rootNavigatorKey;
  @override
  Widget build(context, state) => const PackagesPage();
}

class PackageLicensesRoute extends GoRouteData {
  const PackageLicensesRoute(this.package, this.$extra);
  static final $parentNavigatorKey = rootNavigatorKey;
  factory PackageLicensesRoute.fromParagraph(
    String package,
    List<LicenseParagraph> paragraphs,
  ) =>
      PackageLicensesRoute(
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
