import 'package:ziggle/app/data/enums/notice_my.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/provider/api.dart';

class ProfileArticleData {
  ArticleSummaryResponse? my;
  ArticleSummaryResponse? reminders;
  int myCount;
  int remindersCount;

  ProfileArticleData({
    this.my,
    this.reminders,
    this.myCount = 0,
    this.remindersCount = 0,
  });
}

class MyRepository {
  final ApiProvider _provider;

  MyRepository(this._provider);

  Future<ProfileArticleData> getArticles() async {
    return ProfileArticleData(
      my: (await _provider.getNotices(limit: 1, my: NoticeMy.own))
          .elementAtOrNull(0),
      reminders: (await _provider.getNotices(limit: 1, my: NoticeMy.reminders))
          .elementAtOrNull(0),
    );
  }
}
