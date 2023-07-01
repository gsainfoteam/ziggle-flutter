import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/my/controller.dart';

class MyPage extends GetView<MyController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        actions: const [ZiggleButton(text: '수정')],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfile(),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 30),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Palette.primaryColor,
        ),
        const SizedBox(height: 30),
        _buildInfoRow('이름', '심수연'),
        const SizedBox(height: 25),
        _buildInfoRow('학번', '20210000'),
        const SizedBox(height: 25),
        _buildInfoRow('메일', 'suyeonshim@gm.gist.ac.kr'),
        const SizedBox(height: 30),
      ],
    ).paddingSymmetric(horizontal: 38);
  }

  Widget _buildInfoRow(String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.label,
        ),
        Text(
          content,
          style: TextStyles.label.copyWith(color: Palette.secondaryText),
        ),
      ],
    );
  }
}
