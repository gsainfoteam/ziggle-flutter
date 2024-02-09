import '../../../auth/domain/entities/user_entity.dart';

abstract class AnalyticsRepository {
  logChangeUser(UserEntity? user);
  logScreen(String screenName);

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

  logSearch(String value);

  logTrySubmitArticle();
  logSubmitArticleCancel(String reason);
  logSubmitArticle();
  logTrySelectImage();
  logSelectImage();
}
