import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/global_widgets/section_header.dart';
import 'package:ziggle/app/modules/my/controller.dart';

class MyPage extends GetView<MyController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        actions: [
          SizedBox(
            height: 45,
            child: ZiggleButton(
              text: '로그아웃',
              color: Colors.transparent,
              onTap: controller.logout,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfile(),
            const Divider(),
            _buildMyArticles(),
            const Divider(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Palette.primaryColor,
        ),
        const SizedBox(height: 30),
        Obx(() => _buildInfoRow('이름', controller.name.value)),
        const SizedBox(height: 25),
        Obx(() => _buildInfoRow('학번', controller.studentId.value)),
        const SizedBox(height: 25),
        Obx(() => _buildInfoRow('메일', controller.email.value)),
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
          style: TextStyles.secondaryLabelStyle,
        ),
      ],
    );
  }

  Widget _buildMyArticles() => Column(
        children: ArticleType.profile
            .map(
              (e) => Column(
                children: [
                  SectionHeader(type: e, onTap: () => controller.goToList(e)),
                  const SizedBox(height: 12),
                  Obx(() {
                    final article = controller.articles.value?[e]?.article;
                    if (article == null) return const SizedBox.shrink();
                    return ArticleCard(
                      article: article,
                      direction: Axis.horizontal,
                      onTap: () => controller.goToDetail(article),
                    );
                  }),
                ],
              ).paddingSymmetric(horizontal: 20, vertical: 25),
            )
            .toList(),
      );

  Widget _buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZiggleButton(
            text: '개인정보처리방침',
            color: Colors.transparent,
            textStyle: TextStyles.link,
            padding: EdgeInsets.zero,
            onTap: controller.goToPrivacyPolicy,
          ),
          const SizedBox(height: 25),
          ZiggleButton(
            text: '이용약관',
            color: Colors.transparent,
            textStyle: TextStyles.link,
            padding: EdgeInsets.zero,
            onTap: controller.goToTermsOfService,
          ),
        ],
      ).paddingSymmetric(horizontal: 38, vertical: 35);
}
