import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_reaction.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

part 'analytics_event.freezed.dart';

@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  const AnalyticsEvent._();
  // 메인화면 이벤트
  const factory AnalyticsEvent.feed() = _$Feed;
  const factory AnalyticsEvent.category() = _$Category;
  const factory AnalyticsEvent.categoryType(NoticeType noticeType) =
      _$CategoryType;
  const factory AnalyticsEvent.list(NoticeType noticeType) = _$List;
  const factory AnalyticsEvent.profile() = _$Profile;
  const factory AnalyticsEvent.search(String? from) = _$Search;
  const factory AnalyticsEvent.write(String? from) = _$Write;
  const factory AnalyticsEvent.back(String from) = _$Back;

  // 공지 관련 이벤트
  const factory AnalyticsEvent.notice(int id, String? from) = _$Notice;
  const factory AnalyticsEvent.noticeReaction(
      int id, NoticeReaction noticeReaction, String from) = _$NoticeReaction;
  const factory AnalyticsEvent.noticeShare(int id, String from) = _$NoticeShare;
  const factory AnalyticsEvent.noticeCopy(int id) = _$NoticeCopy;
  const factory AnalyticsEvent.noticeEdit(int id) = _$NoticeEdit;
  const factory AnalyticsEvent.noticeDelete(int id) = _$NoticeDelete;
  const factory AnalyticsEvent.noticeSendNotification(int id) =
      _$NoticeSendNotification;

  // 공지 작성 이벤트
  const factory AnalyticsEvent.writeToggleLanguage(String lang) =
      _$WriteToggleLanguage;
  const factory AnalyticsEvent.writeAddPhoto() = _$WriteAddPhoto;
  const factory AnalyticsEvent.writeUseAiTranslation() =
      _$WriteUseAiTranslation;
  const factory AnalyticsEvent.writeAbortUseAiTranslation() =
      _$WriteAbortUseAiTranslation;
  const factory AnalyticsEvent.writeUndoUseAiTranslation() =
      _$WriteUndoUseAiTranslation;
  const factory AnalyticsEvent.writeConfig() = _$WriteConfig;
  const factory AnalyticsEvent.writeConfigChangeAccount() =
      _$WriteConfigChangeAccount;
  const factory AnalyticsEvent.writeConfigChangeAccountTo(int id) =
      _$WriteConfigChangeAccountTo;
  const factory AnalyticsEvent.writeConfigAddDeadline() =
      _$WriteConfigAddDeadline;
  const factory AnalyticsEvent.writeConfigSetDeadline() =
      _$WriteConfigSetDeadline;
  const factory AnalyticsEvent.writeConfigSetDeadlineCancel() =
      _$WriteConfigSetDeadlineCancel;
  const factory AnalyticsEvent.writeConfigChangeDeadline() =
      _$WriteConfigChangeDeadline;
  const factory AnalyticsEvent.writeConfigDeleteDeadline() =
      _$WriteConfigDeleteDeadline;
  const factory AnalyticsEvent.writeConfigCategory(NoticeType noticeType) =
      _$WriteConfigCategory;
  const factory AnalyticsEvent.writeConfigAddHashtag() =
      _$WriteConfigAddHashtag;
  const factory AnalyticsEvent.writeConfigDoneHashtag() =
      _$WriteConfigDoneHashtag;
  const factory AnalyticsEvent.writeConfigAddHashtagAutocomplete() =
      _$WriteConfigAddHashtagAutocomplete;
  const factory AnalyticsEvent.writeConfigAddHashtagDelete() =
      _$WriteConfigAddHashtagDelete;
  const factory AnalyticsEvent.writeConfigDeleteHashtag() =
      _$WriteConfigDeleteHashtag;
  const factory AnalyticsEvent.writeConfigPreview() = _$WriteConfigPreview;
  const factory AnalyticsEvent.writeConfigPublish() = _$WriteConfigPublish;
  const factory AnalyticsEvent.writeConfigPublishAgree(bool value) =
      _$WriteConfigPublishAgree;
  const factory AnalyticsEvent.writeConfigPublishUpload() =
      _$WriteConfigPublishUpload;

// 공지 수정 이벤트
  const factory AnalyticsEvent.noticeEditPublish(int id) = _$NoticeEditPublish;
  const factory AnalyticsEvent.noticeEditBody(int? id) = _$NoticeEditBody;
  const factory AnalyticsEvent.noticeEditBodyToggleLanguage(String lang) =
      _$NoticeEditBodyToggleLanguage;
  const factory AnalyticsEvent.noticeEditBodyUseAiTranslation() =
      _$NoticeEditBodyUseAiTranslation;
  const factory AnalyticsEvent.noticeEditBodyAbortUseAiTranslation() =
      _$NoticeEditBodyAbortUseAiTranslation;
  const factory AnalyticsEvent.noticeEditBodyUndoUseAiTranslation() =
      _$NoticeEditBodyUndoUseAiTranslation;
  const factory AnalyticsEvent.noticeEditEnglish(int id) = _$NoticeEditEnglish;
  const factory AnalyticsEvent.noticeEditAdditional(int? id) =
      _$NoticeEditAdditional;
  const factory AnalyticsEvent.noticeEditAdditionalToggleLanguage(String lang) =
      _$NoticeEditAdditionalToggleLanguage;
  const factory AnalyticsEvent.noticeEditAdditionalDone() =
      _$NoticeEditAdditionalDone;
  const factory AnalyticsEvent.noticeEditChangeDeadline(int? id) =
      _$NoticeEditChangeDeadline;
  const factory AnalyticsEvent.noticeEditSetDeadline() =
      _$NoticeEditSetDeadline;
  const factory AnalyticsEvent.noticeEditSetDeadlineCancel() =
      _$NoticeEditSetDeadlineCancel;
  const factory AnalyticsEvent.noticeEditPreview(int id) = _$NoticeEditPreview;

// 프로필 페이지 이벤트
  const factory AnalyticsEvent.profileSetting() = _$ProfileSetting;
  const factory AnalyticsEvent.profileMyNotices() = _$ProfileMyNotices;
  const factory AnalyticsEvent.profileFeedback() = _$ProfileFeedback;
  const factory AnalyticsEvent.profileLogout(String from) = _$ProfileLogout;
  const factory AnalyticsEvent.profileWithdraw(String from) = _$ProfileWithdraw;
  const factory AnalyticsEvent.profileLogin(String from) = _$ProfileLogin;
  const factory AnalyticsEvent.profileSettingEnableNotification() =
      _$ProfileSettingEnableNotification;
  const factory AnalyticsEvent.profileSettingLanguage(String lang) =
      _$ProfileSettingLanguage;
  const factory AnalyticsEvent.profileSettingInformation() =
      _$ProfileSettingInformation;
  const factory AnalyticsEvent.profileSettingInformationTos() =
      _$ProfileSettingInformationTos;
  const factory AnalyticsEvent.profileSettingInformationPrivacy() =
      _$ProfileSettingInformationPrivacy;
  const factory AnalyticsEvent.profileSettingInformationLicense() =
      _$ProfileSettingInformationLicense;

  String get name => map(
        feed: (_) => '_feed',
        category: (_) => '_category',
        categoryType: (event) => '_category_type',
        list: (event) => '_list',
        profile: (_) => '_profile',
        search: (event) => '_search',
        write: (event) => '_write',
        back: (event) => '_back',
        notice: (event) => '_notice',
        noticeReaction: (event) => '_notice_reaction',
        noticeShare: (event) => '_notice_share',
        noticeCopy: (event) => '_notice_copy',
        noticeEdit: (event) => '_notice_edit',
        noticeDelete: (event) => '_notice_delete',
        noticeSendNotification: (event) => '_notice_send_notification',
        writeToggleLanguage: (event) => '_write_toggle_language',
        writeAddPhoto: (_) => '_write_add_photo',
        writeUseAiTranslation: (_) => '_write_use_ai_translation',
        writeAbortUseAiTranslation: (_) => '_write_abort_use_ai_translation',
        writeUndoUseAiTranslation: (_) => '_write_undo_use_ai_translation',
        writeConfig: (_) => '_write_config',
        writeConfigChangeAccount: (_) => '_write_config_change_account',
        writeConfigChangeAccountTo: (event) =>
            '_write_config_change_account_to',
        writeConfigAddDeadline: (_) => '_write_config_add_deadline',
        writeConfigSetDeadline: (_) => '_write_config_set_deadline',
        writeConfigSetDeadlineCancel: (_) =>
            '_write_config_set_deadline_cancel',
        writeConfigChangeDeadline: (_) => '_write_config_change_deadline',
        writeConfigDeleteDeadline: (_) => '_write_config_delete_deadline',
        writeConfigCategory: (event) => '_write_config_category',
        writeConfigAddHashtag: (_) => '_write_config_add_hashtag',
        writeConfigDoneHashtag: (_) => '_write_config_done_hashtag',
        writeConfigAddHashtagAutocomplete: (_) =>
            '_write_config_add_hashtag_autocomplete',
        writeConfigAddHashtagDelete: (_) => '_write_config_add_hashtag_delete',
        writeConfigDeleteHashtag: (_) => '_write_config_delete_hashtag',
        writeConfigPreview: (_) => '_write_config_preview',
        writeConfigPublish: (_) => '_write_config_publish',
        writeConfigPublishAgree: (_) => '_write_config_publish_agree',
        writeConfigPublishUpload: (_) => '_write_config_publish_upload',
        noticeEditPublish: (event) => '_notice_edit_publish',
        noticeEditBody: (event) => '_notice_edit_body',
        noticeEditBodyToggleLanguage: (event) =>
            '_notice_edit_body_toggle_language',
        noticeEditBodyUseAiTranslation: (_) =>
            '_notice_edit_body_use_ai_translation',
        noticeEditBodyAbortUseAiTranslation: (_) =>
            '_notice_edit_body_abort_use_ai_translation',
        noticeEditBodyUndoUseAiTranslation: (_) =>
            '_notice_edit_body_undo_use_ai_translation',
        noticeEditEnglish: (event) => '_notice_edit_english',
        noticeEditAdditional: (event) => '_notice_edit_additional',
        noticeEditAdditionalToggleLanguage: (event) =>
            '_notice_edit_additional_toggle_language',
        noticeEditAdditionalDone: (_) => '_notice_edit_additional_done',
        noticeEditChangeDeadline: (event) => '_notice_edit_change_deadline',
        noticeEditSetDeadline: (_) => '_notice_edit_set_deadline',
        noticeEditSetDeadlineCancel: (_) => '_notice_edit_set_deadline_cancel',
        noticeEditPreview: (event) => '_notice_edit_preview',
        profileSetting: (_) => '_profile_setting',
        profileMyNotices: (_) => '_profile_my_notices',
        profileFeedback: (_) => '_profile_feedback',
        profileLogout: (event) => '_profile_logout',
        profileWithdraw: (event) => '_profile_withdraw',
        profileLogin: (event) => '_profile_login',
        profileSettingEnableNotification: (_) =>
            '_profile_setting_enable_notification',
        profileSettingLanguage: (event) => '_profile_setting_language',
        profileSettingInformation: (_) => '_profile_setting_information',
        profileSettingInformationTos: (_) => '_profile_setting_information_tos',
        profileSettingInformationPrivacy: (_) =>
            '_profile_setting_information_privacy',
        profileSettingInformationLicense: (_) =>
            '_profile_setting_information_license',
      );

  Map<String, Object>? get parameters => map(
        feed: (_) => {},
        category: (_) => {},
        categoryType: (event) => {
          'type': event.noticeType,
        },
        list: (event) => {
          'type': event.noticeType,
        },
        profile: (_) => {},
        search: (event) => {
          'from': event.from ?? 'unknown',
        },
        write: (event) => {
          'from': event.from ?? 'unknown',
        },
        back: (event) => {
          'from': event.from,
        },
        notice: (event) => {
          'id': event.id,
          'from': event.from ?? 'unknown',
        },
        noticeReaction: (event) => {
          'id': event.id,
          'reaction': event.noticeReaction,
          'from': event.from,
        },
        noticeShare: (event) => {
          'id': event.id,
          'from': event.from,
        },
        noticeCopy: (event) => {
          'id': event.id,
        },
        noticeEdit: (event) => {
          'id': event.id,
        },
        noticeDelete: (event) => {
          'id': event.id,
        },
        noticeSendNotification: (event) => {
          'id': event.id,
        },
        writeToggleLanguage: (event) => {
          'lang': event.lang,
        },
        writeAddPhoto: (_) => {},
        writeUseAiTranslation: (_) => {},
        writeAbortUseAiTranslation: (_) => {},
        writeUndoUseAiTranslation: (_) => {},
        writeConfig: (_) => {},
        writeConfigChangeAccount: (_) => {},
        writeConfigChangeAccountTo: (event) => {
          'id': event.id,
        },
        writeConfigAddDeadline: (_) => {},
        writeConfigSetDeadline: (_) => {},
        writeConfigSetDeadlineCancel: (_) => {},
        writeConfigChangeDeadline: (_) => {},
        writeConfigDeleteDeadline: (_) => {},
        writeConfigCategory: (event) => {
          'type': event.noticeType,
        },
        writeConfigAddHashtag: (_) => {},
        writeConfigDoneHashtag: (_) => {},
        writeConfigAddHashtagAutocomplete: (_) => {},
        writeConfigAddHashtagDelete: (_) => {},
        writeConfigDeleteHashtag: (_) => {},
        writeConfigPreview: (_) => {},
        writeConfigPublish: (_) => {},
        writeConfigPublishAgree: (event) => {
          'value': event.value,
        },
        writeConfigPublishUpload: (_) => {},
        noticeEditPublish: (event) => {
          'id': event.id,
        },
        noticeEditBody: (event) => {
          'id': event.id ?? -1,
        },
        noticeEditBodyToggleLanguage: (event) => {
          'lang': event.lang,
        },
        noticeEditBodyUseAiTranslation: (_) => {},
        noticeEditBodyAbortUseAiTranslation: (_) => {},
        noticeEditBodyUndoUseAiTranslation: (_) => {},
        noticeEditEnglish: (event) => {
          'id': event.id,
        },
        noticeEditAdditional: (event) => {
          'id': event.id ?? -1,
        },
        noticeEditAdditionalToggleLanguage: (event) => {
          'lang': event.lang,
        },
        noticeEditAdditionalDone: (_) => {},
        noticeEditChangeDeadline: (event) => {
          'id': event.id ?? -1,
        },
        noticeEditSetDeadline: (_) => {},
        noticeEditSetDeadlineCancel: (_) => {},
        noticeEditPreview: (event) => {
          'id': event.id,
        },
        profileSetting: (_) => {},
        profileMyNotices: (_) => {},
        profileFeedback: (_) => {},
        profileLogout: (event) => {
          'from': event.from,
        },
        profileWithdraw: (event) => {
          'from': event.from,
        },
        profileLogin: (event) => {
          'from': event.from,
        },
        profileSettingEnableNotification: (_) => {},
        profileSettingLanguage: (event) => {
          'lang': event.lang,
        },
        profileSettingInformation: (_) => {},
        profileSettingInformationTos: (_) => {},
        profileSettingInformationPrivacy: (_) => {},
        profileSettingInformationLicense: (_) => {},
      );
}
