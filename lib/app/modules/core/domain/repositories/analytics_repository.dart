import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

import '../../../auth/domain/entities/user_entity.dart';

abstract class AnalyticsRepository {
  logChangeUser(UserEntity? user);
  logScreen(String screenName);

  logOpenFeedback();
  logOpenPrivacyPolicy();
  logOpenTermsOfService();
  logOpenWithdrawal();
  logTryLogin();
  logLogin();
  logLoginCancel(String reason);
  logLogout();

  logTryReminder();
  logToggleReminder(bool set);
  logTryReport();
  logReport();

  logSearch(String value, NoticeType type);

  logTrySubmitArticle();
  logSubmitArticleCancel(String reason);
  logSubmitArticle();
  logTrySelectImage();
  logSelectImage();
}
