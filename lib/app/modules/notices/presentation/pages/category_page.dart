import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/toast.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

@RoutePage()
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.grayLight,
      appBar: ZiggleAppBar.main(
        onTapSearch: () => const SearchRoute().push(context),
        onTapWrite: () {
          if (UserBloc.userOrNull(context) == null) {
            return context.showToast(
              context.t.user.login.description,
            );
          }
          const NoticeWriteBodyRoute().push(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          children: NoticeType.categories
              .fold<List<List<NoticeType>>>(
                [],
                (previousValue, element) =>
                    previousValue.isEmpty || previousValue.last.length == 2
                        ? [
                            ...previousValue,
                            [element]
                          ]
                        : [...previousValue..last.add(element)],
              )
              .indexed
              .expand(
                (categories) => [
                  if (categories.$1 != 0) const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: categories.$2.indexed
                          .expand(
                            (category) => [
                              if (category.$1 != 0) const SizedBox(width: 10),
                              Expanded(
                                child: ZigglePressable(
                                  onPressed: () => ListRoute(type: category.$2)
                                      .push(context),
                                  decoration: BoxDecoration(
                                    color: category.$2.backgroundColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      category.$2.image.image(width: 100),
                                      const SizedBox(height: 10),
                                      Text(
                                        category.$2.getName(context),
                                        style: TextStyle(
                                          color: category.$2.textColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                          .toList(),
                    ),
                  ),
                ],
              )
              .toList(),
        ),
      ),
    );
  }
}
