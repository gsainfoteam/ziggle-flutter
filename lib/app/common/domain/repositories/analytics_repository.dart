abstract class AnalyticsRepository {
  logScreen(String screenName);

  logOpenTermsOfService();
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
