import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/url_shortener_api.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_predefined_size.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_sized_box.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:my_portfolio_flutter/linklytics/pages/dashboard/analytics_page.dart';
import 'package:my_portfolio_flutter/linklytics/pages/dashboard/shorten_url_item.dart';
import 'package:my_portfolio_flutter/linklytics/provider/token_provider.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTokenExpired = ref.watch(tokenProvider);
    final _shortenUrlsProvider = ref.watch(shortenUrlsProvider);

    if (isTokenExpired == null || isTokenExpired) {
      return _buildSessionExpiredDialog(context);
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          const AnalyticsPage(
            clickData: {},
          ),
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
          ),
          ..._shortenUrlsProvider.when(
            data: (data) {
              if (data.isEmpty) {
                return [Text('No Data')];
              }

              return data.map((entry) => ShortUrlBox(
                  shortUrl: entry.shortUrl,
                  originalUrl: entry.originalUrl,
                  urlId: entry.id,
                  clickCount: entry.clickCount,
                  creationDate: entry.createdDate));
            },
            loading: () => const [Center(child: CircularProgressIndicator())],
            error: (error, stack) =>
                [Center(child: Text("Error loading data: $error"))],
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
          onPressed: () => context.go(LinkLyticsUri.login.uri),
          child: AppText("Login", type: TextType.md),
        ),
      ],
    );
  }
}
