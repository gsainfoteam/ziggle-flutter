import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_role_permission.g.dart';

@JsonEnum(alwaysCreate: true)
enum GroupRolePermission {
  @JsonValue('MEMBER_UPDATE')
  memberUpdate,

  @JsonValue('MEMBER_DELETE')
  memberDelete,

  @JsonValue('ROLE_CREATE')
  roleCreate,

  @JsonValue('ROLE_UPDATE')
  roleUpdate,

  @JsonValue('ROLE_DELETE')
  roleDelete,

  @JsonValue('ROLE_GRANT')
  roleGrant,

  @JsonValue('ROLE_REVOKE')
  roleRevoke,

  @JsonValue('GROUP_UPDATE')
  groupUpdate,

  @JsonValue('GROUP_DELETE')
  groupDelete,
}

extension GroupRolePermissionJson on GroupRolePermission {
  static GroupRolePermission fromJson(String json) =>
      _$GroupRolePermissionEnumMap.entries
          .firstWhere((e) => e.value == json)
          .key;

  String toJson() => _$GroupRolePermissionEnumMap[this]!;
}
