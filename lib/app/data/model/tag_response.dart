import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_response.freezed.dart';
part 'tag_response.g.dart';

@freezed
class TagResponse with _$TagResponse {
  const factory TagResponse({
    required int id,
    required String name,
  }) = _TagResponse;

  factory TagResponse.fromJson(Map<String, dynamic> json) =>
      _$TagResponseFromJson(json);
}
