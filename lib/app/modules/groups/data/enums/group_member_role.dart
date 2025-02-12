import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/gen/strings.g.dart';

@JsonEnum(alwaysCreate: true)
enum GroupMemberRole {
  @JsonValue('admin')
  admin,

  @JsonValue('manager')
  manager,

  @JsonValue('member')
  member;

  int toInt() {
    switch (this) {
      case GroupMemberRole.admin:
        return 1;
      case GroupMemberRole.manager:
        return 2;
      case GroupMemberRole.member:
        return 3;
    }
  }
}

extension GroupMemberRoleX on GroupMemberRole {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case GroupMemberRole.admin:
        return context.t.group.memberCard.role.admin;
      case GroupMemberRole.manager:
        return context.t.group.memberCard.role.manager;
      case GroupMemberRole.member:
        return context.t.group.memberCard.role.member;
    }
  }
}
