abstract class AnalyticsRepository {
  logScreen(String screenName);

  logOpenTermsOfService();
  logLoginAnonymous();
  logTryLogin();
  logLogin();
  logLoginCancel(String reason);
}
