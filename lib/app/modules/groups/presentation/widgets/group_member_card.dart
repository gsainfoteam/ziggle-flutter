import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_select.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

enum GroupMemberRole { admin, manager, user }

class GroupMemberCard extends StatelessWidget {
  const GroupMemberCard({
    super.key,
    required this.name,
    required this.email,
    this.onPressed,
    required this.role,
    this.editMode = false,
  });

  final String name;
  final String email;
  final VoidCallback? onPressed;
  final GroupMemberRole? role;
  final bool editMode;

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
                    '$role',
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
                      value: role,
                      hintText: context.t.common.memberCard.role.role,
                      entries: [
                        ZiggleSelectEntry(
                          value: GroupMemberRole.admin,
                          label: context.t.common.memberCard.role.admin,
                        ),
                        ZiggleSelectEntry(
                          value: GroupMemberRole.manager,
                          label: context.t.common.memberCard.role.manager,
                        ),
                        ZiggleSelectEntry(
                          value: GroupMemberRole.user,
                          label: context.t.common.memberCard.role.user,
                        )
                      ],
                      small: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ZiggleButton.small(
                    onPressed: onPressed,
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
