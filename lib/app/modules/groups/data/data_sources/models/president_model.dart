import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/domain/entities/president_entity.dart';

part 'president_model.freezed.dart';
part 'president_model.g.dart';

@freezed
class PresidentModel with _$PresidentModel implements PresidentEntity {
  const PresidentModel._();

  const factory PresidentModel({
    required String uuid,
    String? name,
    String? email,
    DateTime? createdAt,
  }) = _GroupPresidentModel;

  factory PresidentModel.fromJson(Map<String, dynamic> json) =>
      _$PresidentModelFromJson(json);
}
