import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_button.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_hyperlink.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_predefined_size.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text_styles.dart';
import 'package:my_portfolio_flutter/linklytics/i18/texts.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppHyperlink(
            text: AppBarText.title.en,
            type: TextType.xl,
            color: Colors.white,
            onTap: () => context.go(LinkLyticsUri.base.uri),
          ),
          Row(
            children: [
              _navItem(
                AppBarText.home.en,
                context,
                () => context.go(LinkLyticsUri.base.uri),
              ),
              _navItem(
                AppBarText.about.en,
                context,
                () => context.go(LinkLyticsUri.about.uri),
              ),
              _signUpButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    String title,
    BuildContext context,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPredefinedSize.md),
      child: AppHyperlink(
        text: title,
        type: TextType.md,
        color: Colors.white,
        onTap: onTap,
      ),
    );
  }

  Widget _signUpButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPredefinedSize.md),
      child: AppButton(
        label: AppBarText.signIn.en,
        onPressed: () => context.go(LinkLyticsUri.otpLogin.uri),
        type: ButtonType.error,
        size: ButtonSize.medium,
        textStyle: AppTextStyles.buttonText,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
