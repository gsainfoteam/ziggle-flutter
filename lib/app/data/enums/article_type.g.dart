// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleTypeAdapter extends TypeAdapter<ArticleType> {
  @override
  final int typeId = 1;

  @override
  ArticleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 4:
        return ArticleType.deadline;
      case 5:
        return ArticleType.hot;
      case 6:
        return ArticleType.my;
      case 7:
        return ArticleType.reminders;
      case 0:
        return ArticleType.recruit;
      case 1:
        return ArticleType.event;
      case 2:
        return ArticleType.general;
      case 3:
        return ArticleType.academic;
      default:
        return ArticleType.general;
    }
  }

  @override
  void write(BinaryWriter writer, ArticleType obj) {
    switch (obj) {
      case ArticleType.deadline:
        writer.writeByte(4);
        break;
      case ArticleType.hot:
        writer.writeByte(5);
        break;
      case ArticleType.my:
        writer.writeByte(6);
        break;
      case ArticleType.reminders:
        writer.writeByte(7);
        break;
      case ArticleType.recruit:
        writer.writeByte(0);
        break;
      case ArticleType.event:
        writer.writeByte(1);
        break;
      case ArticleType.general:
        writer.writeByte(2);
        break;
      case ArticleType.academic:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
