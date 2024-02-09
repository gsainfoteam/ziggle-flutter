import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/domain/entities/user_entity.dart';

import '../../domain/repositories/analytics_repository.dart';

@Injectable(as: AnalyticsRepository)
@dev
class MockAnalyticsRepository implements AnalyticsRepository {
  @override
  logChangeUser(UserEntity? user) {}

  void _log(String name, [Map<String, dynamic>? parameters]) =>
      debugPrint('Analytics: $name $parameters');

  @override
  logScreen(String screenName) => _log(screenName);
  @override
  logOpenTermsOfService() => _log('open terms of service');
  @override
  logLogin() => _log('login');
  @override
  logLoginCancel(String reason) => _log('login cancel', {'reason': reason});
  @override
  logTryLogin() => _log('try login');
  @override
  logLogout() => _log('logout');
  @override
  logToggleReminder(bool set) => _log('toggle reminder', {'set': set});
  @override
  logTryReminder() => _log('try reminder');
  @override
  logReport() => _log('report');
  @override
  logTryReport() => _log('try report');
  @override
  logOpenPrivacyPolicy() => _log('open privacy policy');
  @override
  logOpenWithdrawal() => _log('open withdrawal');
  @override
  logSearch(String value) => _log('search', {'query': value});
  @override
  logSubmitArticle() => _log('submit article');
  @override
  logSubmitArticleCancel(String reason) =>
      _log('submit article cancel', {'reason': reason});
  @override
  logTrySubmitArticle() => _log('try submit article');
  @override
  logSelectImage() => _log('select image');
  @override
  logTrySelectImage() => _log('try select image');
}
