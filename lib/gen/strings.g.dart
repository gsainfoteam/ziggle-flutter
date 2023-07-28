/// Generated file. Do not edit.
///
/// Original: assets/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 154 (77 per locale)


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
	late final _StringsProfileKo profile = _StringsProfileKo._(_root);
	late final _StringsSearchKo search = _StringsSearchKo._(_root);
	late final _StringsRootKo root = _StringsRootKo._(_root);
	late final _StringsLoginKo login = _StringsLoginKo._(_root);
	late final _StringsWriteKo write = _StringsWriteKo._(_root);
}

// Path: article
class _StringsArticleKo {
	_StringsArticleKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	late final _StringsArticleSectionKo section = _StringsArticleSectionKo._(_root);
	String get author => '글쓴이';
	String get views => '조회수';
	String get deadline => '마감일';
	String deadlineDelta({required Object n}) => '${n}일 남음';
	String get createdAt => '작성일';
	String get reminderDescription => '알림 설정하면\n마감일 n일 전에 알려줘요!';
	late final _StringsArticleReminderLoginKo reminderLogin = _StringsArticleReminderLoginKo._(_root);
	late final _StringsArticleReportKo report = _StringsArticleReportKo._(_root);
}

// Path: profile
class _StringsProfileKo {
	_StringsProfileKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get title => '마이페이지';
	String get logout => '로그아웃';
	String get name => '이름';
	String get studentId => '학번';
	String get mail => '메일';
	String others({required Object count}) => '외 ${count}개';
	String get privacyPolicy => '개인정보처리방침';
	String get termsOfService => '이용약관';
	String get withdrawal => '회원탈퇴';
}

// Path: search
class _StringsSearchKo {
	_StringsSearchKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get enter => '검색어를 입력해주세요';
	String get noResult => '검색 결과가 존재하지 않습니다.';
	String get queryHint => '검색어';
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
	String get notificationChannelDescription => '지글 알림';
}

// Path: login
class _StringsLoginKo {
	_StringsLoginKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	TextSpan promotion({required InlineSpanBuilder red}) => TextSpan(children: [
		red('지'),
		const TextSpan(text: '스트의 모든 공지를 한눈에'),
	]);
	String get login => 'GSA 통합 계정으로 로그인';
	String get withoutLogin => '로그인 없이 이용하기';
	TextSpan consent({required InlineSpanBuilder terms}) => TextSpan(children: [
		const TextSpan(text: 'GSA 통합 계정으로 로그인하면,\n'),
		terms('지글 이용약관'),
		const TextSpan(text: '에 동의하는 것으로 간주합니다.'),
	]);
}

// Path: write
class _StringsWriteKo {
	_StringsWriteKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	late final _StringsWriteTitleKo title = _StringsWriteTitleKo._(_root);
	late final _StringsWriteDeadlineKo deadline = _StringsWriteDeadlineKo._(_root);
	late final _StringsWriteTypeKo type = _StringsWriteTypeKo._(_root);
	late final _StringsWriteTagsKo tags = _StringsWriteTagsKo._(_root);
	late final _StringsWriteBodyKo body = _StringsWriteBodyKo._(_root);
	late final _StringsWriteImagesKo images = _StringsWriteImagesKo._(_root);
	String get preview => '공지 미리보기';
	String get submit => '공지 제출하기';
	String get warning => '공지 제출 시 수정이 불가능합니다.';
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

// Path: article.reminderLogin
class _StringsArticleReminderLoginKo {
	_StringsArticleReminderLoginKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get title => '로그인하면 알림 설정이 가능해요';
	String get description => '로그인하고 n일 전에 마감일 알림을 받으세요!';
}

// Path: article.report
class _StringsArticleReportKo {
	_StringsArticleReportKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get action => '공지 신고하기';
	String get title => '이 공지를 신고하시겠습니까?';
	String get description => '신고가 접수되면 관리자가 이 공지를 살펴보고 조치를 취할 것입니다.';
	String get yes => '네';
	String get no => '아니오';
}

// Path: write.title
class _StringsWriteTitleKo {
	_StringsWriteTitleKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get placeholder => '제목을 입력하세요';
	late final _StringsWriteTitleErrorKo error = _StringsWriteTitleErrorKo._(_root);
}

// Path: write.deadline
class _StringsWriteDeadlineKo {
	_StringsWriteDeadlineKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get label => '마감일 설정';
}

// Path: write.type
class _StringsWriteTypeKo {
	_StringsWriteTypeKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get label => '분류';
	late final _StringsWriteTypeErrorKo error = _StringsWriteTypeErrorKo._(_root);
}

// Path: write.tags
class _StringsWriteTagsKo {
	_StringsWriteTagsKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get label => '태그 설정';
	String get placeholder => '태그를 입력하세요 (띄어쓰기로 구분)';
}

// Path: write.body
class _StringsWriteBodyKo {
	_StringsWriteBodyKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get label => '본문 내용 입력';
	String get placeholder => '본문 내용을 입력하세요\n마크다운 문법을 지원합니다';
	late final _StringsWriteBodyErrorKo error = _StringsWriteBodyErrorKo._(_root);
}

// Path: write.images
class _StringsWriteImagesKo {
	_StringsWriteImagesKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get label => '사진 첨부';
	String get description => '첨부된 사진 중 첫 번째 사진이 대표 사진으로 설정됩니다.';
	String get action => '폰에서 사진 선택하기...';
}

// Path: write.title.error
class _StringsWriteTitleErrorKo {
	_StringsWriteTitleErrorKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get title => '제목을 입력해주세요';
	String get description => '제목을 입력하지 않으면 공지를 제출할 수 없습니다.';
}

// Path: write.type.error
class _StringsWriteTypeErrorKo {
	_StringsWriteTypeErrorKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get title => '분류를 선택해주세요';
	String get description => '분류를 선택하지 않으면 공지를 제출할 수 없습니다.';
}

// Path: write.body.error
class _StringsWriteBodyErrorKo {
	_StringsWriteBodyErrorKo._(this._root);

	final _StringsKo _root; // ignore: unused_field

	// Translations
	String get title => '본문 내용을 입력해주세요';
	String get description => '본문 내용을 입력하지 않으면 공지를 제출할 수 없습니다.';
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
	@override late final _StringsSearchEn search = _StringsSearchEn._(_root);
	@override late final _StringsProfileEn profile = _StringsProfileEn._(_root);
	@override late final _StringsRootEn root = _StringsRootEn._(_root);
	@override late final _StringsArticleEn article = _StringsArticleEn._(_root);
	@override late final _StringsLoginEn login = _StringsLoginEn._(_root);
	@override late final _StringsWriteEn write = _StringsWriteEn._(_root);
}

// Path: search
class _StringsSearchEn implements _StringsSearchKo {
	_StringsSearchEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get enter => 'Please enter a search term';
	@override String get noResult => 'No results found';
	@override String get queryHint => 'Search term';
}

// Path: profile
class _StringsProfileEn implements _StringsProfileKo {
	_StringsProfileEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'My Page';
	@override String get logout => 'Logout';
	@override String get name => 'Name';
	@override String get studentId => 'Student ID';
	@override String get mail => 'Mail';
	@override String others({required Object count}) => 'and ${count} others';
	@override String get privacyPolicy => 'Privacy Policy';
	@override String get termsOfService => 'Terms of Service';
	@override String get withdrawal => 'Withdrawal';
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
	@override String get notificationChannelDescription => 'ziggle notification';
}

// Path: article
class _StringsArticleEn implements _StringsArticleKo {
	_StringsArticleEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override late final _StringsArticleSectionEn section = _StringsArticleSectionEn._(_root);
	@override String get author => 'Author';
	@override String get views => 'Views';
	@override String get deadline => 'Deadline';
	@override String deadlineDelta({required Object n}) => '${n} days left';
	@override String get createdAt => 'Created At';
	@override String get reminderDescription => 'If you set a reminder,\nI\'ll let you know n days before the deadline!';
	@override late final _StringsArticleReminderLoginEn reminderLogin = _StringsArticleReminderLoginEn._(_root);
	@override late final _StringsArticleReportEn report = _StringsArticleReportEn._(_root);
}

// Path: login
class _StringsLoginEn implements _StringsLoginKo {
	_StringsLoginEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override TextSpan promotion({required InlineSpanBuilder red}) => TextSpan(children: [
		const TextSpan(text: 'All of '),
		red('G'),
		const TextSpan(text: 'IST\'s announcements at a glance'),
	]);
	@override String get login => 'Login with GSA unified account';
	@override String get withoutLogin => 'Use without login';
	@override TextSpan consent({required InlineSpanBuilder terms}) => TextSpan(children: [
		const TextSpan(text: 'By logging in with your GSA unified account,\nyou are deemed to have agreed to the '),
		terms('지글 이용약관'),
		const TextSpan(text: '.'),
	]);
}

// Path: write
class _StringsWriteEn implements _StringsWriteKo {
	_StringsWriteEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override late final _StringsWriteTitleEn title = _StringsWriteTitleEn._(_root);
	@override late final _StringsWriteDeadlineEn deadline = _StringsWriteDeadlineEn._(_root);
	@override late final _StringsWriteTypeEn type = _StringsWriteTypeEn._(_root);
	@override late final _StringsWriteTagsEn tags = _StringsWriteTagsEn._(_root);
	@override late final _StringsWriteBodyEn body = _StringsWriteBodyEn._(_root);
	@override late final _StringsWriteImagesEn images = _StringsWriteImagesEn._(_root);
	@override String get preview => 'Preview notice';
	@override String get submit => 'Submit notice';
	@override String get warning => 'You cannot edit notice after submitting.';
}

// Path: article.section
class _StringsArticleSectionEn implements _StringsArticleSectionKo {
	_StringsArticleSectionEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String title({required ArticleType type}) {
		switch (type) {
			case ArticleType.deadline:
				return 'Deadline';
			case ArticleType.hot:
				return 'Hot';
			case ArticleType.my:
				return 'My';
			case ArticleType.reminders:
				return 'Reminders';
			case ArticleType.recruit:
				return 'Recruit';
			case ArticleType.event:
				return 'Event';
			case ArticleType.general:
				return 'General';
			case ArticleType.academic:
				return 'Academic';
		}
	}
	@override String description({required ArticleType type}) {
		switch (type) {
			case ArticleType.deadline:
				return 'Articles that are about to expire within a week';
			case ArticleType.hot:
				return 'Articles that have been viewed more than 150 times in the last week';
			case ArticleType.my:
				return 'Articles that I wrote';
			case ArticleType.reminders:
				return 'Articles that I set reminders';
			case ArticleType.recruit:
				return 'Opportunities always open to you';
			case ArticleType.event:
				return 'GIST is hot today';
			case ArticleType.general:
				return 'Things GISTers have to do';
			case ArticleType.academic:
				return 'Things GISTers have to do';
		}
	}
	@override String shortTitle({required ArticleType type}) {
		switch (type) {
			case ArticleType.deadline:
				return 'Deadline';
			case ArticleType.hot:
				return 'Hot';
			case ArticleType.my:
				return 'My';
			case ArticleType.reminders:
				return 'Reminders';
			case ArticleType.recruit:
				return 'Recruit';
			case ArticleType.event:
				return 'Event';
			case ArticleType.general:
				return 'General';
			case ArticleType.academic:
				return 'Academic';
		}
	}
}

// Path: article.reminderLogin
class _StringsArticleReminderLoginEn implements _StringsArticleReminderLoginKo {
	_StringsArticleReminderLoginEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'You can set reminders if you log in';
	@override String get description => 'Log in and get a deadline reminder n days in advance!';
}

// Path: article.report
class _StringsArticleReportEn implements _StringsArticleReportKo {
	_StringsArticleReportEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get action => 'Report Notice';
	@override String get title => 'Do you want to report this notice?';
	@override String get description => 'Once reported, the administrator will review this notice and take action.';
	@override String get yes => 'Report';
	@override String get no => 'Cancel';
}

// Path: write.title
class _StringsWriteTitleEn implements _StringsWriteTitleKo {
	_StringsWriteTitleEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Enter title';
	@override late final _StringsWriteTitleErrorEn error = _StringsWriteTitleErrorEn._(_root);
}

// Path: write.deadline
class _StringsWriteDeadlineEn implements _StringsWriteDeadlineKo {
	_StringsWriteDeadlineEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Set deadline';
}

// Path: write.type
class _StringsWriteTypeEn implements _StringsWriteTypeKo {
	_StringsWriteTypeEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Type';
	@override late final _StringsWriteTypeErrorEn error = _StringsWriteTypeErrorEn._(_root);
}

// Path: write.tags
class _StringsWriteTagsEn implements _StringsWriteTagsKo {
	_StringsWriteTagsEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Set tags';
	@override String get placeholder => 'Enter tags (separated by space)';
}

// Path: write.body
class _StringsWriteBodyEn implements _StringsWriteBodyKo {
	_StringsWriteBodyEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Enter body';
	@override String get placeholder => 'Enter body\nMarkdown syntax is supported';
	@override late final _StringsWriteBodyErrorEn error = _StringsWriteBodyErrorEn._(_root);
}

// Path: write.images
class _StringsWriteImagesEn implements _StringsWriteImagesKo {
	_StringsWriteImagesEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get label => 'Attach images';
	@override String get description => 'The first image will be set as the representative image.';
	@override String get action => 'Select images from phone...';
}

// Path: write.title.error
class _StringsWriteTitleErrorEn implements _StringsWriteTitleErrorKo {
	_StringsWriteTitleErrorEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Please enter title';
	@override String get description => 'You cannot submit notice without title.';
}

// Path: write.type.error
class _StringsWriteTypeErrorEn implements _StringsWriteTypeErrorKo {
	_StringsWriteTypeErrorEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Please select type';
	@override String get description => 'You cannot submit notice without type.';
}

// Path: write.body.error
class _StringsWriteBodyErrorEn implements _StringsWriteBodyErrorKo {
	_StringsWriteBodyErrorEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Please enter body';
	@override String get description => 'You cannot submit notice without body.';
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
			case 'article.author': return '글쓴이';
			case 'article.views': return '조회수';
			case 'article.deadline': return '마감일';
			case 'article.deadlineDelta': return ({required Object n}) => '${n}일 남음';
			case 'article.createdAt': return '작성일';
			case 'article.reminderDescription': return '알림 설정하면\n마감일 n일 전에 알려줘요!';
			case 'article.reminderLogin.title': return '로그인하면 알림 설정이 가능해요';
			case 'article.reminderLogin.description': return '로그인하고 n일 전에 마감일 알림을 받으세요!';
			case 'article.report.action': return '공지 신고하기';
			case 'article.report.title': return '이 공지를 신고하시겠습니까?';
			case 'article.report.description': return '신고가 접수되면 관리자가 이 공지를 살펴보고 조치를 취할 것입니다.';
			case 'article.report.yes': return '네';
			case 'article.report.no': return '아니오';
			case 'profile.title': return '마이페이지';
			case 'profile.logout': return '로그아웃';
			case 'profile.name': return '이름';
			case 'profile.studentId': return '학번';
			case 'profile.mail': return '메일';
			case 'profile.others': return ({required Object count}) => '외 ${count}개';
			case 'profile.privacyPolicy': return '개인정보처리방침';
			case 'profile.termsOfService': return '이용약관';
			case 'profile.withdrawal': return '회원탈퇴';
			case 'search.enter': return '검색어를 입력해주세요';
			case 'search.noResult': return '검색 결과가 존재하지 않습니다.';
			case 'search.queryHint': return '검색어';
			case 'root.login': return '로그인';
			case 'root.main': return '메인';
			case 'root.search': return '검색';
			case 'root.write': return '작성';
			case 'root.notificationChannelDescription': return '지글 알림';
			case 'login.promotion': return ({required InlineSpanBuilder red}) => TextSpan(children: [
				red('지'),
				const TextSpan(text: '스트의 모든 공지를 한눈에'),
			]);
			case 'login.login': return 'GSA 통합 계정으로 로그인';
			case 'login.withoutLogin': return '로그인 없이 이용하기';
			case 'login.consent': return ({required InlineSpanBuilder terms}) => TextSpan(children: [
				const TextSpan(text: 'GSA 통합 계정으로 로그인하면,\n'),
				terms('지글 이용약관'),
				const TextSpan(text: '에 동의하는 것으로 간주합니다.'),
			]);
			case 'write.title.placeholder': return '제목을 입력하세요';
			case 'write.title.error.title': return '제목을 입력해주세요';
			case 'write.title.error.description': return '제목을 입력하지 않으면 공지를 제출할 수 없습니다.';
			case 'write.deadline.label': return '마감일 설정';
			case 'write.type.label': return '분류';
			case 'write.type.error.title': return '분류를 선택해주세요';
			case 'write.type.error.description': return '분류를 선택하지 않으면 공지를 제출할 수 없습니다.';
			case 'write.tags.label': return '태그 설정';
			case 'write.tags.placeholder': return '태그를 입력하세요 (띄어쓰기로 구분)';
			case 'write.body.label': return '본문 내용 입력';
			case 'write.body.placeholder': return '본문 내용을 입력하세요\n마크다운 문법을 지원합니다';
			case 'write.body.error.title': return '본문 내용을 입력해주세요';
			case 'write.body.error.description': return '본문 내용을 입력하지 않으면 공지를 제출할 수 없습니다.';
			case 'write.images.label': return '사진 첨부';
			case 'write.images.description': return '첨부된 사진 중 첫 번째 사진이 대표 사진으로 설정됩니다.';
			case 'write.images.action': return '폰에서 사진 선택하기...';
			case 'write.preview': return '공지 미리보기';
			case 'write.submit': return '공지 제출하기';
			case 'write.warning': return '공지 제출 시 수정이 불가능합니다.';
			default: return null;
		}
	}
}

extension on _StringsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'search.enter': return 'Please enter a search term';
			case 'search.noResult': return 'No results found';
			case 'search.queryHint': return 'Search term';
			case 'profile.title': return 'My Page';
			case 'profile.logout': return 'Logout';
			case 'profile.name': return 'Name';
			case 'profile.studentId': return 'Student ID';
			case 'profile.mail': return 'Mail';
			case 'profile.others': return ({required Object count}) => 'and ${count} others';
			case 'profile.privacyPolicy': return 'Privacy Policy';
			case 'profile.termsOfService': return 'Terms of Service';
			case 'profile.withdrawal': return 'Withdrawal';
			case 'root.login': return 'login';
			case 'root.main': return 'main';
			case 'root.search': return 'search';
			case 'root.write': return 'write';
			case 'root.notificationChannelDescription': return 'ziggle notification';
			case 'article.section.title': return ({required ArticleType type}) {
				switch (type) {
					case ArticleType.deadline:
						return 'Deadline';
					case ArticleType.hot:
						return 'Hot';
					case ArticleType.my:
						return 'My';
					case ArticleType.reminders:
						return 'Reminders';
					case ArticleType.recruit:
						return 'Recruit';
					case ArticleType.event:
						return 'Event';
					case ArticleType.general:
						return 'General';
					case ArticleType.academic:
						return 'Academic';
				}
			};
			case 'article.section.description': return ({required ArticleType type}) {
				switch (type) {
					case ArticleType.deadline:
						return 'Articles that are about to expire within a week';
					case ArticleType.hot:
						return 'Articles that have been viewed more than 150 times in the last week';
					case ArticleType.my:
						return 'Articles that I wrote';
					case ArticleType.reminders:
						return 'Articles that I set reminders';
					case ArticleType.recruit:
						return 'Opportunities always open to you';
					case ArticleType.event:
						return 'GIST is hot today';
					case ArticleType.general:
						return 'Things GISTers have to do';
					case ArticleType.academic:
						return 'Things GISTers have to do';
				}
			};
			case 'article.section.shortTitle': return ({required ArticleType type}) {
				switch (type) {
					case ArticleType.deadline:
						return 'Deadline';
					case ArticleType.hot:
						return 'Hot';
					case ArticleType.my:
						return 'My';
					case ArticleType.reminders:
						return 'Reminders';
					case ArticleType.recruit:
						return 'Recruit';
					case ArticleType.event:
						return 'Event';
					case ArticleType.general:
						return 'General';
					case ArticleType.academic:
						return 'Academic';
				}
			};
			case 'article.author': return 'Author';
			case 'article.views': return 'Views';
			case 'article.deadline': return 'Deadline';
			case 'article.deadlineDelta': return ({required Object n}) => '${n} days left';
			case 'article.createdAt': return 'Created At';
			case 'article.reminderDescription': return 'If you set a reminder,\nI\'ll let you know n days before the deadline!';
			case 'article.reminderLogin.title': return 'You can set reminders if you log in';
			case 'article.reminderLogin.description': return 'Log in and get a deadline reminder n days in advance!';
			case 'article.report.action': return 'Report Notice';
			case 'article.report.title': return 'Do you want to report this notice?';
			case 'article.report.description': return 'Once reported, the administrator will review this notice and take action.';
			case 'article.report.yes': return 'Report';
			case 'article.report.no': return 'Cancel';
			case 'login.promotion': return ({required InlineSpanBuilder red}) => TextSpan(children: [
				const TextSpan(text: 'All of '),
				red('G'),
				const TextSpan(text: 'IST\'s announcements at a glance'),
			]);
			case 'login.login': return 'Login with GSA unified account';
			case 'login.withoutLogin': return 'Use without login';
			case 'login.consent': return ({required InlineSpanBuilder terms}) => TextSpan(children: [
				const TextSpan(text: 'By logging in with your GSA unified account,\nyou are deemed to have agreed to the '),
				terms('지글 이용약관'),
				const TextSpan(text: '.'),
			]);
			case 'write.title.placeholder': return 'Enter title';
			case 'write.title.error.title': return 'Please enter title';
			case 'write.title.error.description': return 'You cannot submit notice without title.';
			case 'write.deadline.label': return 'Set deadline';
			case 'write.type.label': return 'Type';
			case 'write.type.error.title': return 'Please select type';
			case 'write.type.error.description': return 'You cannot submit notice without type.';
			case 'write.tags.label': return 'Set tags';
			case 'write.tags.placeholder': return 'Enter tags (separated by space)';
			case 'write.body.label': return 'Enter body';
			case 'write.body.placeholder': return 'Enter body\nMarkdown syntax is supported';
			case 'write.body.error.title': return 'Please enter body';
			case 'write.body.error.description': return 'You cannot submit notice without body.';
			case 'write.images.label': return 'Attach images';
			case 'write.images.description': return 'The first image will be set as the representative image.';
			case 'write.images.action': return 'Select images from phone...';
			case 'write.preview': return 'Preview notice';
			case 'write.submit': return 'Submit notice';
			case 'write.warning': return 'You cannot edit notice after submitting.';
			default: return null;
		}
	}
}
