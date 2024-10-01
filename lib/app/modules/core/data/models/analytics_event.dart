import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_reaction.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

part 'analytics_event.freezed.dart';
part 'analytics_event.g.dart';

@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  const AnalyticsEvent._();
  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEventFromJson(json);

  // 메인화면 이벤트
  const factory AnalyticsEvent.feed() = _Feed;
  const factory AnalyticsEvent.category() = _Category;
  const factory AnalyticsEvent.categoryType(NoticeType noticeType) =
      _CategoryType;
  const factory AnalyticsEvent.list(NoticeType noticeType) = _List;
  const factory AnalyticsEvent.profile() = _Profile;
  const factory AnalyticsEvent.search([PageSource? from]) = _Search;
  const factory AnalyticsEvent.write([PageSource? from]) = _Write;
  const factory AnalyticsEvent.back(PageSource from) = _Back;

  // 공지 관련 이벤트
  const factory AnalyticsEvent.notice(int id, PageSource? from) = _Notice;
  const factory AnalyticsEvent.noticeReaction(
      int id, NoticeReaction noticeReaction, PageSource from) = _NoticeReaction;
  const factory AnalyticsEvent.noticeShare(int id, PageSource from) =
      _NoticeShare;
  const factory AnalyticsEvent.noticeCopy(int id) = _NoticeCopy;
  const factory AnalyticsEvent.noticeEdit(int id) = _NoticeEdit;
  const factory AnalyticsEvent.noticeDelete(int id) = _NoticeDelete;
  const factory AnalyticsEvent.noticeSendNotification(int id) =
      _NoticeSendNotification;

  // 공지 작성 이벤트
  const factory AnalyticsEvent.writeToggleLanguage(String lang) =
      _WriteToggleLanguage;
  const factory AnalyticsEvent.writeAddPhoto() = _WriteAddPhoto;
  const factory AnalyticsEvent.writeUseAiTranslation() = _WriteUseAiTranslation;
  const factory AnalyticsEvent.writeAbortUseAiTranslation() =
      _WriteAbortUseAiTranslation;
  const factory AnalyticsEvent.writeUndoUseAiTranslation() =
      _WriteUndoUseAiTranslation;
  const factory AnalyticsEvent.writeConfig() = _WriteConfig;
  const factory AnalyticsEvent.writeConfigChangeAccount() =
      _WriteConfigChangeAccount;
  const factory AnalyticsEvent.writeConfigChangeAccountTo(int id) =
      _WriteConfigChangeAccountTo;
  const factory AnalyticsEvent.writeConfigAddDeadline() =
      _WriteConfigAddDeadline;
  const factory AnalyticsEvent.writeConfigSetDeadline() =
      _WriteConfigSetDeadline;
  const factory AnalyticsEvent.writeConfigSetDeadlineCancel() =
      _WriteConfigSetDeadlineCancel;
  const factory AnalyticsEvent.writeConfigChangeDeadline() =
      _WriteConfigChangeDeadline;
  const factory AnalyticsEvent.writeConfigDeleteDeadline() =
      _WriteConfigDeleteDeadline;
  const factory AnalyticsEvent.writeConfigCategory(NoticeType noticeType) =
      _WriteConfigCategory;
  const factory AnalyticsEvent.writeConfigAddHashtag() = _WriteConfigAddHashtag;
  const factory AnalyticsEvent.writeConfigDoneHashtag() =
      _WriteConfigDoneHashtag;
  const factory AnalyticsEvent.writeConfigAddHashtagAutocomplete() =
      _WriteConfigAddHashtagAutocomplete;
  const factory AnalyticsEvent.writeConfigAddHashtagDelete() =
      _WriteConfigAddHashtagDelete;
  const factory AnalyticsEvent.writeConfigDeleteHashtag() =
      _WriteConfigDeleteHashtag;
  const factory AnalyticsEvent.writeConfigPreview() = _WriteConfigPreview;
  const factory AnalyticsEvent.writeConfigPublish() = _WriteConfigPublish;
  const factory AnalyticsEvent.writeConfigPublishAgree(bool value) =
      _WriteConfigPublishAgree;
  const factory AnalyticsEvent.writeConfigPublishUpload() =
      _WriteConfigPublishUpload;

// 공지 수정 이벤트
  const factory AnalyticsEvent.noticeEditPublish(int id) = _NoticeEditPublish;
  const factory AnalyticsEvent.noticeEditBody(int? id) = _NoticeEditBody;
  const factory AnalyticsEvent.noticeEditBodyToggleLanguage(String lang) =
      _NoticeEditBodyToggleLanguage;
  const factory AnalyticsEvent.noticeEditBodyUseAiTranslation() =
      _NoticeEditBodyUseAiTranslation;
  const factory AnalyticsEvent.noticeEditBodyAbortUseAiTranslation() =
      _NoticeEditBodyAbortUseAiTranslation;
  const factory AnalyticsEvent.noticeEditBodyUndoUseAiTranslation() =
      _NoticeEditBodyUndoUseAiTranslation;
  const factory AnalyticsEvent.noticeEditEnglish(int id) = _NoticeEditEnglish;
  const factory AnalyticsEvent.noticeEditAdditional(int? id) =
      _NoticeEditAdditional;
  const factory AnalyticsEvent.noticeEditAdditionalToggleLanguage(String lang) =
      _NoticeEditAdditionalToggleLanguage;
  const factory AnalyticsEvent.noticeEditAdditionalDone() =
      _NoticeEditAdditionalDone;
  const factory AnalyticsEvent.noticeEditChangeDeadline(int? id) =
      _NoticeEditChangeDeadline;
  const factory AnalyticsEvent.noticeEditSetDeadline() = _NoticeEditSetDeadline;
  const factory AnalyticsEvent.noticeEditSetDeadlineCancel() =
      _NoticeEditSetDeadlineCancel;
  const factory AnalyticsEvent.noticeEditPreview(int id) = _NoticeEditPreview;

// 프로필 페이지 이벤트
  const factory AnalyticsEvent.profileSetting() = _ProfileSetting;
  const factory AnalyticsEvent.profileMyNotices() = _ProfileMyNotices;
  const factory AnalyticsEvent.profileFeedback() = _ProfileFeedback;
  const factory AnalyticsEvent.profileLogout(PageSource from) = _ProfileLogout;
  const factory AnalyticsEvent.profileWithdraw(PageSource from) =
      _ProfileWithdraw;
  const factory AnalyticsEvent.profileLogin(PageSource from) = _ProfileLogin;
  const factory AnalyticsEvent.profileSettingEnableNotification() =
      _ProfileSettingEnableNotification;
  const factory AnalyticsEvent.profileSettingLanguage(String lang) =
      _ProfileSettingLanguage;
  const factory AnalyticsEvent.profileSettingInformation() =
      _ProfileSettingInformation;
  const factory AnalyticsEvent.profileSettingInformationTos() =
      _ProfileSettingInformationTos;
  const factory AnalyticsEvent.profileSettingInformationPrivacy() =
      _ProfileSettingInformationPrivacy;
  const factory AnalyticsEvent.profileSettingInformationLicense() =
      _ProfileSettingInformationLicense;

  Map<String, Object> get parameters {
    final json = toJson();
    json.remove('runtimeType');
    json.removeWhere((key, value) => value == null);
    return json.cast<String, Object>();
  }

  String get name {
    final json = toJson();
    return camelToSnake(json['runtimeType']);
  }

  String camelToSnake(String text) {
    return text.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (Match match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}
