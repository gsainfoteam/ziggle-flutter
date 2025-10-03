import 'package:hive_ce/hive.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';

class LanguageAdapter extends TypeAdapter<Language> {
  @override
  final int typeId = 3; // yaml에서 3이었으니까 여기서도 3으로 지정

  @override
  Language read(BinaryReader reader) {
    final index = reader.readByte();

    return Language.values[index];
  }

  @override
  void write(BinaryWriter writer, Language obj) {
    writer.writeByte(obj.index);
  }
}
