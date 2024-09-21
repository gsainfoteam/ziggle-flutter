import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_select.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

enum GroupMemberRole {
  admin,
  manager,
  user;

  String toLocalizedString(BuildContext context) {
    switch (this) {
      case GroupMemberRole.admin:
        return context.t.common.memberCard.role.admin;
      case GroupMemberRole.manager:
        return context.t.common.memberCard.role.manager;
      case GroupMemberRole.user:
        return context.t.common.memberCard.role.user;
    }
  }
}

class GroupMemberCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onBanish;
  final bool editMode;
  final GroupMemberRole role;
  final ValueChanged<GroupMemberRole?>? onChanged;

  const GroupMemberCard.editMode({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    required this.onBanish,
    required this.onChanged,
  }) : editMode = true;

  const GroupMemberCard.viewMode({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  })  : editMode = false,
        onBanish = null,
        onChanged = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: editMode
          ? const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            )
          : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: ShapeDecoration(
        color: Palette.grayLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Palette.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Palette.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (editMode != true)
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    role.toLocalizedString(context),
                    style: const TextStyle(
                      color: Palette.grayText,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: editMode ? 10 : 0,
          ),
          if (editMode)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ZiggleSelect(
                      onChanged: onChanged,
                      value: role,
                      small: true,
                      hintText: context.t.common.memberCard.role.role,
                      entries: GroupMemberRole.values
                          .map((value) => ZiggleSelectEntry(
                              value: value,
                              label: value.toLocalizedString(context)))
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ZiggleButton.small(
                    onPressed: onBanish,
                    child: Text(context.t.common.memberCard.banish),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
