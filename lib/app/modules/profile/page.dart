import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/global_widgets/article_card.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/global_widgets/section_header.dart';
import 'package:ziggle/app/modules/profile/controller.dart';
import 'package:ziggle/gen/strings.g.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.profile.title),
        actions: [
          SizedBox(
            height: 45,
            child: ZiggleButton(
              text: t.profile.logout,
              color: Colors.transparent,
              onTap: controller.logout,
            ),
          )
        ],
      ),
      body: RefreshIndicator.adaptive(
        key: controller.refreshIndicatorKey,
        onRefresh: controller.load,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfile(),
              const Divider(),
              _buildMyArticles(),
              Obx(() =>
                  controller.articles.value?.values.any((e) => e.count > 0) ??
                          false
                      ? const Divider()
                      : const SizedBox.shrink()),
              _buildFooter(),
            ],
          ),
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
        Obx(() => _buildInfoRow(t.profile.name, controller.name.value)),
        const SizedBox(height: 25),
        Obx(() =>
            _buildInfoRow(t.profile.studentId, controller.studentId.value)),
        const SizedBox(height: 25),
        Obx(() => _buildInfoRow(t.profile.mail, controller.email.value)),
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

  Widget _buildMyArticles() => Obx(
        () => Column(
          children: ArticleType.profile
              .where((e) => controller.articles.value?[e]?.article != null)
              .map(
                (e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionHeader(type: e, onTap: () => controller.goToList(e)),
                    const SizedBox(height: 12),
                    ArticleCard(
                      article: controller.articles.value![e]!.article!,
                      direction: Axis.horizontal,
                      onTap: () => controller
                          .goToDetail(controller.articles.value![e]!.article!),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 60,
                      child: ZiggleButton(
                        color: Palette.light,
                        text: t.profile.others(
                            count: controller.articles.value![e]!.count),
                        textColor: Palette.black,
                        textStyle: TextStyles.bigNormal,
                        onTap: () => controller.goToList(e),
                      ),
                    )
                  ],
                ).paddingSymmetric(horizontal: 20, vertical: 25),
              )
              .toList(),
        ),
      );

  Widget _buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZiggleButton(
            text: t.profile.privacyPolicy,
            color: Colors.transparent,
            textStyle: TextStyles.link,
            padding: EdgeInsets.zero,
            onTap: controller.goToPrivacyPolicy,
          ),
          const SizedBox(height: 25),
          ZiggleButton(
            text: t.profile.termsOfService,
            color: Colors.transparent,
            textStyle: TextStyles.link,
            padding: EdgeInsets.zero,
            onTap: controller.goToTermsOfService,
          ),
        ],
      ).paddingSymmetric(horizontal: 38, vertical: 35);
}
