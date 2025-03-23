import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_button.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_predefined_size.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sized_box.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:my_portfolio_flutter/linklytics/pages/dashboard/analytics_page.dart';
import 'package:my_portfolio_flutter/linklytics/provider/jwt_token_notifier.dart';
import 'package:my_portfolio_flutter/linklytics/provider/token_provider.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTokenExpired = ref.watch(tokenProvider);

    if (isTokenExpired == null || isTokenExpired) {
      return _buildSessionExpiredDialog(context);
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          const AnalyticsPage(clickData:{},),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              AppSizedBox.md(),
              Container(
                width: AppPredefinedSize.md,
              ),
              AppSizedBox.md(),
              Container(
                width: AppPredefinedSize.md,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSessionExpiredDialog(BuildContext context) {
    return AlertDialog(
      title: const AppText(
        "Session Expired",
        type: TextType.md,
      ),
      content: const AppText(
        "Your session has expired. Please log in again.",
        type: TextType.md,
      ),
      actions: [
        TextButton(
          onPressed: () => context.go(LinkLyticsUri.otpLogin.uri),
          child: AppText("Login", type: TextType.md),
        ),
      ],
    );
  }
}
