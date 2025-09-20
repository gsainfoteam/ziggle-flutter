import 'package:hive_ce/hive.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/notices/data/models/notice_write_draft_model.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/user/data/models/setting_model.dart';

@GenerateAdapters([
  AdapterSpec<SettingModel>(),
  AdapterSpec<NoticeWriteDraftModel>(),
  AdapterSpec<Language>(),
  AdapterSpec<NoticeType>(),
])
part 'hive_adapters.g.dart';
