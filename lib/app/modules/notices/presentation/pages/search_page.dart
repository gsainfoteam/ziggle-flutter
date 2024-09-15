import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    const count = 10;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoSearchTextField(
                    prefixIcon: Assets.icons.search.svg(width: 20),
                    placeholder: context.t.notice.search.hint,
                    suffixIcon: const Icon(Icons.cancel),
                    onChanged: (v) => setState(() => _keyword = v),
                  ),
                ),
                const SizedBox(width: 10),
                ZiggleButton.text(
                  onPressed: () => context.pop(),
                  child: Text(
                    context.t.common.cancel,
                    style: const TextStyle(color: Palette.grayText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _keyword.isEmpty
          ? Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Assets.icons.search.svg(
                    width: 65,
                    height: 65,
                    colorFilter: const ColorFilter.mode(
                      Palette.gray,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    context.t.notice.search.description,
                    style: const TextStyle(
                      color: Palette.grayText,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.only(left: 16),
                decoration: index != count - 1
                    ? null
                    : const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0x5B3C3C43), width: 0.33),
                        ),
                      ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0x5B3C3C43), width: 0.33),
                    ),
                  ),
                  child: ZigglePressable(
                    onPressed: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'title',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Palette.black,
                          ),
                        ),
                        Text(
                          '인포팀, 하루전',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Palette.grayText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
