abstract class AnalyticsRepository {
  logScreen(String screenName);

  logOpenPrivacyPolicy();
  logOpenTermsOfService();
  logOpenWithdrawal();
  logLoginAnonymous();
  logTryLogin();
  logLogin();
  logLoginCancel(String reason);
  logLogoutAnonymous();
  logLogout();

  logChangeImageCarousel(int page);
  logHideReminderTooltip();
  logTryReminder();
  logToggleReminder(bool set);
  logTryReport();
  logReport();
}
