import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/notice/domain/enums/notice_type.dart';
import 'package:ziggle/app/values/palette.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.grayLight,
      appBar: ZiggleAppBar.main(
        onTapSearch: () {},
        onTapWrite: () {},
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
                                child: Container(
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
                                        category.$2.name,
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
