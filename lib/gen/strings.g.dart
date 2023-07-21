/// Generated file. Do not edit.
///
/// Original: assets/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 38 (19 per locale)
///
/// Built on 2023-07-21 at 10:17 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.ko;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.ko) // set locale
/// - Locale locale = AppLocale.ko.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.ko) // locale check
enum AppLocale with BaseAppLocale<AppLocale, _StringsKo> {
	ko(languageCode: 'ko', build: _StringsKo.build),
	en(languageCode: 'en', build: _StringsEn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, _StringsKo> build;

	/// Gets current instance managed by [LocaleSettings].
	_StringsKo get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
_StringsKo get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class Translations {
	Translations._(); // no constructor

	static _StringsKo of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsKo>(context).translations;
}

/// The provider for method B
class TranslationProvider extends BaseTranslationProvider<AppLocale, _StringsKo> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, _StringsKo> of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsKo>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	_StringsKo get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, _StringsKo> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, _StringsKo> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class _StringsKo implements BaseTranslations<AppLocale, _StringsKo> {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsKo.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ko,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ko>.
	@override final TranslationMetadata<AppLocale, _StringsKo> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final _StringsKo _root = this; // ignore: unused_field

	// Translations
	late final _StringsArticleKo article = _StringsArticleKo._(_root);
	late final _StringsRootKo root = _StringsRootKo._(_root);
	late final _StringsLoginKo login = _StringsLoginKo._(_root);
}

// Path: article
class _StringsArticleKo {
	_StringsArticleKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	late final _StringsArticleSectionKo section = _StringsArticleSectionKo._(_root);
}

// Path: root
class _StringsRootKo {
	_StringsRootKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get login => '로그인';
	String get main => '메인';
	String get search => '검색';
	String get write => '작성';
}

// Path: login
class _StringsLoginKo {
	_StringsLoginKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get promotion => '지스트의 모든 공지를 한눈에';
	String get login => 'GSA 통합 계정으로 로그인';
	String get withoutLogin => '로그인 없이 이용하기';
}

// Path: article.section
class _StringsArticleSectionKo {
	_StringsArticleSectionKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String title({required ArticleType type}) {
		switch (type) {
			case ArticleType.deadline:
				return '기한 임박';
			case ArticleType.hot:
				return '요즘 끓는 공지';
			case ArticleType.my:
				return '내가 쓴 공지';
			case ArticleType.reminders:
				return '리마인더 설정한 공지';
			case ArticleType.recruit:
				return '모집';
			case ArticleType.event:
				return '행사';
			case ArticleType.general:
				return '일반';
			case ArticleType.academic:
				return '학사공지';
		}
	}
	String description({required ArticleType type}) {
		switch (type) {
			case ArticleType.deadline:
				return '마감 시간이 일주일도 안 남은 공지를\n모아서 보여 드려요';
			case ArticleType.hot:
				return '지난 일주일 동안 조회수가 150이 넘은 공지들이\n여기서 지글지글 끓고 있어요';
			case ArticleType.my:
				return '내가 쓴 공지들을 모아서 보여 드려요';
			case ArticleType.reminders:
				return '알림을 설정한 공지들을 모아서 보여 드려요';
			case ArticleType.recruit:
				return '언제나 여러분께 열린 기회';
			case ArticleType.event:
				return '지스트는 오늘도 뜨겁습니다';
			case ArticleType.general:
				return '지스트인들이 해야 하는 일들';
			case ArticleType.academic:
				return '지스트인이 해야 하는 일들';
		}
	}
	String shortTitle({required ArticleType type}) {
		switch (type) {
			case ArticleType.deadline:
				return '기한 임박';
			case ArticleType.hot:
				return '요즘 끓는 공지';
			case ArticleType.my:
				return '내가 쓴 공지';
			case ArticleType.reminders:
				return '리마인더 설정한 공지';
			case ArticleType.recruit:
				return '모집';
			case ArticleType.event:
				return '행사';
			case ArticleType.general:
				return '일반';
			case ArticleType.academic:
				return '학사';
		}
	}
}

// Path: <root>
class _StringsEn implements _StringsKo {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, _StringsKo> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsEn _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsRootEn root = _StringsRootEn._(_root);
	@override late final _StringsLoginEn login = _StringsLoginEn._(_root);
}

// Path: root
class _StringsRootEn implements _StringsRootKo {
	_StringsRootEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get login => 'login';
	@override String get main => 'main';
	@override String get search => 'search';
	@override String get write => 'write';
}

// Path: login
class _StringsLoginEn implements _StringsLoginKo {
	_StringsLoginEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get promotion => 'All of GIST\'s announcements at a glance';
	@override String get login => 'Login with GSA unified account';
	@override String get withoutLogin => 'Use without login';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on _StringsKo {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'article.section.title': return ({required ArticleType type}) {
				switch (type) {
					case ArticleType.deadline:
						return '기한 임박';
					case ArticleType.hot:
						return '요즘 끓는 공지';
					case ArticleType.my:
						return '내가 쓴 공지';
					case ArticleType.reminders:
						return '리마인더 설정한 공지';
					case ArticleType.recruit:
						return '모집';
					case ArticleType.event:
						return '행사';
					case ArticleType.general:
						return '일반';
					case ArticleType.academic:
						return '학사공지';
				}
			};
			case 'article.section.description': return ({required ArticleType type}) {
				switch (type) {
					case ArticleType.deadline:
						return '마감 시간이 일주일도 안 남은 공지를\n모아서 보여 드려요';
					case ArticleType.hot:
						return '지난 일주일 동안 조회수가 150이 넘은 공지들이\n여기서 지글지글 끓고 있어요';
					case ArticleType.my:
						return '내가 쓴 공지들을 모아서 보여 드려요';
					case ArticleType.reminders:
						return '알림을 설정한 공지들을 모아서 보여 드려요';
					case ArticleType.recruit:
						return '언제나 여러분께 열린 기회';
					case ArticleType.event:
						return '지스트는 오늘도 뜨겁습니다';
					case ArticleType.general:
						return '지스트인들이 해야 하는 일들';
					case ArticleType.academic:
						return '지스트인이 해야 하는 일들';
				}
			};
			case 'article.section.shortTitle': return ({required ArticleType type}) {
				switch (type) {
					case ArticleType.deadline:
						return '기한 임박';
					case ArticleType.hot:
						return '요즘 끓는 공지';
					case ArticleType.my:
						return '내가 쓴 공지';
					case ArticleType.reminders:
						return '리마인더 설정한 공지';
					case ArticleType.recruit:
						return '모집';
					case ArticleType.event:
						return '행사';
					case ArticleType.general:
						return '일반';
					case ArticleType.academic:
						return '학사';
				}
			};
			case 'root.login': return '로그인';
			case 'root.main': return '메인';
			case 'root.search': return '검색';
			case 'root.write': return '작성';
			case 'login.promotion': return '지스트의 모든 공지를 한눈에';
			case 'login.login': return 'GSA 통합 계정으로 로그인';
			case 'login.withoutLogin': return '로그인 없이 이용하기';
			default: return null;
		}
	}
}

extension on _StringsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'root.login': return 'login';
			case 'root.main': return 'main';
			case 'root.search': return 'search';
			case 'root.write': return 'write';
			case 'login.promotion': return 'All of GIST\'s announcements at a glance';
			case 'login.login': return 'Login with GSA unified account';
			case 'login.withoutLogin': return 'Use without login';
			default: return null;
		}
	}
}
