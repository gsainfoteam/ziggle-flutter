import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/author_entity.dart';

part 'author_model.freezed.dart';
part 'author_model.g.dart';

@freezed
class AuthorModel with _$AuthorModel implements AuthorEntity {
  const factory AuthorModel({required String name, required String uuid}) =
      _AuthorModel;

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);
  factory AuthorModel.fromEntity(AuthorEntity entity) =>
      AuthorModel(name: entity.name, uuid: entity.uuid);
}
