import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_select.dart';
import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupMemberCard extends StatelessWidget {
  final String name;
  final String? email;
  final VoidCallback? onBanish;
  final bool editMode;
  final GroupMemberRole? role;
  final String uuid;
  final String myUuid;
  final String presidentUuid;
  final ValueChanged<GroupMemberRole?>? onChanged;

  const GroupMemberCard.editMode({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    required this.onBanish,
    required this.onChanged,
    required this.uuid,
    required this.myUuid,
    required this.presidentUuid,
  }) : editMode = true;

  const GroupMemberCard.viewMode({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  })  : editMode = false,
        onBanish = null,
        onChanged = null,
        uuid = "3141592",
        myUuid = "1618033",
        presidentUuid = "2718281";

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
                  if (email != null)
                    Text(
                      email!,
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
                    role?.toLocalizedString(context) ?? '',
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
                    child: (uuid == presidentUuid)
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10) +
                                const EdgeInsets.only(left: 2),
                            decoration: const BoxDecoration(
                              border: Border.fromBorderSide(
                                BorderSide(
                                    color: Palette.grayBorder, strokeAlign: 1),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Palette.grayLight,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.t.group.memberCard.role.president,
                                  style: TextStyle(
                                    color: Palette.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ZiggleSelect(
                            onChanged: onChanged,
                            value: role,
                            small: true,
                            hintText: context.t.group.memberCard.role.role,
                            entries: (presidentUuid == myUuid
                                    ? GroupMemberRole.values
                                    : GroupMemberRole.values.where(
                                        (r) => r != GroupMemberRole.president))
                                .map((value) => ZiggleSelectEntry(
                                    value: value,
                                    label: value.toLocalizedString(context)))
                                .toList(),
                          ),
                  ),
                  if (uuid != presidentUuid) const SizedBox(width: 10),
                  if (uuid != presidentUuid)
                    ZiggleButton.small(
                      onPressed: onBanish,
                      child: Text(context.t.group.memberCard.banish),
                    )
                ],
              ),
            )
        ],
      ),
    );
  }
}
