import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/linklytics/pages/about_page.dart';
import 'package:my_portfolio_flutter/linklytics/pages/linklytics_home_page.dart';
import 'package:my_portfolio_flutter/linklytics/pages/otp_login_page_v2.dart';
import 'package:my_portfolio_flutter/linklytics/storybook/link_storybook_app.dart';
import 'package:my_portfolio_flutter/pages/blog/blog_page.dart';
import 'package:my_portfolio_flutter/pages/ecommerce/ecommerce.dart';
import 'package:my_portfolio_flutter/pages/home/home_page.dart';
import 'package:my_portfolio_flutter/pages/my_portfolio/portfolio_page.dart';
import 'package:my_portfolio_flutter/pages/storybook/button_showcase.dart';
import 'package:my_portfolio_flutter/pages/storybook/storybook_app.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';
import 'package:my_portfolio_flutter/linklytics/pages/dashboard_page.dart';
import 'package:my_portfolio_flutter/linklytics/pages/login_page.dart';
import 'package:my_portfolio_flutter/linklytics/pages/register_page.dart';
import 'package:my_portfolio_flutter/linklytics/widgets/main_layout.dart';

class RouteConfig {
  // static const String linklyticsBasePath = "/linklytics";
  static const String linklyticsHomePath = "";
  // static const String aboutPath = "/about";
  static const String registerPath = "/register";
  // static const String dashboardPath = "/dashboard";
  static const String loginPath = "/login";
  // static const String otpLoginPath = "/login/otp";
  static const String homePagePath = "/";
  static const String portfolioPath = "/portfolio";
  static const String ecommercePath = "/ecommerce";
  static const String storyBookPath = "/storybook";
  static const String blogPath = "/blog";

  static GoRouter returnRouter() {
    return GoRouter(
        // initialLocation: '/',
        initialLocation: Uri.base.toString().replaceFirst(
              '${Uri.base.origin}/#', // this is to stay on the same location
              '', // when refreshes or page reload
            ),
        // problem: i.e. http://localhost:52472/#/login when you reload
        // it will go back to the initiallocation if the value is fixed, so let's
        // say, the fixed value is '/', so when you reload/refresh the browser
        // it will go back to http://localhost:52472 instead of staying to
        // #/login
        routes: [
          GoRoute(
              path: homePagePath,
              builder: (context, state) => const HomePage()),
          GoRoute(
              path: portfolioPath,
              builder: (context, state) => const PortfolioPage()),
          GoRoute(
              path: ecommercePath,
              builder: (context, state) => const EcommercePage()),
          GoRoute(
              path: LinkLyticsUri.dashboard.uri,
              builder: (context, state) => DashboardPage()),
          GoRoute(
              path: blogPath, builder: (context, state) => const BlogPage()),
          GoRoute(
              path: '/storybook',
              builder: (context, state) => const StorybookApp(),
              routes: [
                GoRoute(
                  path: '/button',
                  builder: (context, state) => const ButtonShowcase(),
                )
              ]),
          ShellRoute(
              builder: (context, state, child) {
                return MainLayout(
                  child: child,
                ); // ✅ Keeps AppBar & Footer fixed
              },
              routes: [
                buildLinkLyticsRoute(
                  LinkLyticsUri.base,
                  const LinklyticsHomePage(),
                ),
                buildLinkLyticsRoute(
                  LinkLyticsUri.about,
                  const AboutPage(),
                ),
                buildLinkLyticsRoute(
                  LinkLyticsUri.login,
                  const LoginPage(),
                ),
                buildLinkLyticsRoute(
                  LinkLyticsUri.storybook,
                  const LinkStorybookApp(),
                ),
                buildLinkLyticsRoute(
                  LinkLyticsUri.otpLogin,
                  const OtpLoginPageV2(),
                ),
                buildLinkLyticsRoute(
                  LinkLyticsUri.register,
                  const RegisterPage(),
                ),
                buildLinkLyticsRoute(
                  LinkLyticsUri.dashboard,
                  DashboardPage(),
                ),
              ]),
        ]);
  }

  static GoRoute buildLinkLyticsRoute(LinkLyticsUri path, Widget page) {
    return GoRoute(
        path: path.uri,
        name: path.toString(),
        pageBuilder: (context, state) {
          return NoTransitionPage(child: page);
        });
  }
}
