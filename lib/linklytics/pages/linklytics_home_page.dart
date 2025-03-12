import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/linklytics/constants/app_spacing.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_fade_in_widget.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_hyperlink.dart';
import 'package:my_portfolio_flutter/linklytics/i18/texts.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_button.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_predefined_size.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sized_box.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text_styles.dart';
import 'package:my_portfolio_flutter/linklytics/widgets/feature_card.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';

class LinklyticsHomePage extends ConsumerWidget {
  const LinklyticsHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppFadeInWidget(
                  child:
                      AppText(text: HomePageText.title.en, type: TextType.xl),
                  // duration: Duration(milliseconds: 600),
                  offsetY: -30,
                ),
                AppSizedBox.sm(),
                AppFadeInWidget(
                  offsetY: -30,
                  child: AppText(
                    text: HomePageText.description.en,
                    type: TextType.md,
                  ),
                ),
                AppSizedBox.lg(),
                Row(
                  children: [
                    AppButton(
                      label: HomePageText.manageLinks.en,
                      onPressed: () {},
                      type: ButtonType.gradient,
                      size: ButtonSize.medium,
                    ),
                    AppSizedBox.sm(horizontal: true),
                    AppButton(
                      label: HomePageText.createShortLink.en,
                      onPressed: () {},
                      type: ButtonType.primary,
                      isOutlined: true,
                      textStyle: AppTextStyles.textTheme.bodyLarge,
                      outlineColor: Colors.black,
                      size: ButtonSize.large,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSpacing.sectionPadding,
            child: Column(
              children: [
                Text(
                  'Trusted by individuals and teams at the world best companies',
                  style: AppTextStyles.textTheme.displayMedium,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    FeatureCard(
                        title: 'Simple URL Shortening',
                        description:
                            'Experience the ease of creating short, memorable URLs in just a few clicks.'),
                    FeatureCard(
                        title: 'Powerful Analytics',
                        description:
                            'Gain insights into your link performance with our analytics dashboard.'),
                    FeatureCard(
                        title: 'Enhanced Security',
                        description:
                            'Rest assured with our robust security measures and encryption.'),
                    FeatureCard(
                        title: 'Fast and Reliable',
                        description:
                            'Enjoy lightning-fast redirects and high uptime.'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
