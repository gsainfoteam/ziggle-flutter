import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/data/provider/db.dart';

class ArticleRepository {
  final ApiProvider _provider;
  final DbProvider _dbProvider;

  ArticleRepository(this._provider, this._dbProvider);

  Future<ArticleResponse> getArticleById(int id) => _provider.getNotice(id);
  Future setReminder(int id) => _provider.setReminder(id);
  Future cancelReminder(int id) => _provider.cancelReminder(id);

  static const _shouldShowReminderKey = 'show_reminder_tooltip';

  bool get shouldShowReminderTooltip => _dbProvider.getSetting(
        _shouldShowReminderKey,
        defaultValue: true,
      );

  Future<void> hideReminderTooltip() async {
    await _dbProvider.setSetting(_shouldShowReminderKey, false);
  }
}
