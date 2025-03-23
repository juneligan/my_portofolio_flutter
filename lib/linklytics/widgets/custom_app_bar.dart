import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_button.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_hyperlink.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_predefined_size.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text_styles.dart';
import 'package:my_portfolio_flutter/linklytics/i18/texts.dart';
import 'package:my_portfolio_flutter/linklytics/provider/jwt_token_notifier.dart';
import 'package:my_portfolio_flutter/linklytics/provider/token_provider.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTokenExpired = ref.watch(tokenProvider);

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
            AppBarText.title.en,
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
              _signUpButton(context, ref),
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
        title,
        type: TextType.md,
        color: Colors.white,
        onTap: onTap,
      ),
    );
  }

  Widget _signUpButton(BuildContext context, WidgetRef ref) {
    final tokenState = ref.watch(jwtTokenProvider);
    final isTokenExpired =
        tokenState == null ? null : JwtDecoder.isExpired(tokenState);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPredefinedSize.md),
      child: AppButton(
        isTokenExpired == null || isTokenExpired
            ? AppBarText.signIn.en
            : AppBarText.signOut.en,
        onPressed: () {
          if (isTokenExpired == null || !isTokenExpired) {
            ref.read(jwtTokenProvider.notifier).removeToken();
          }
          context.go(
            isTokenExpired == null || isTokenExpired
                ? LinkLyticsUri.otpLogin.uri
                : LinkLyticsUri.base.uri,
          );
        },
        type: ButtonType.error,
        size: ButtonSize.medium,
        textStyle: AppTextStyles.buttonText,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
