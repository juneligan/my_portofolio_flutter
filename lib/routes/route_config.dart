import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/pages/my_portfolio/portfolio_page.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';
import 'package:my_portfolio_flutter/url_shortener/pages/dashboard_page.dart';
import 'package:my_portfolio_flutter/url_shortener/pages/login_page.dart';
import 'package:my_portfolio_flutter/url_shortener/pages/otp_login_page.dart';
import 'package:my_portfolio_flutter/url_shortener/pages/register_page.dart';
import 'package:my_portfolio_flutter/url_shortener/pages/shortener_home_page.dart';
import 'package:my_portfolio_flutter/url_shortener/widgets/main_layout.dart';

import '../main.dart';

class RouteConfig {
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
          GoRoute(path: '/', builder: (context, state) => HomePage()),
          GoRoute(path: '/portfolio', builder: (context, state) => PortfolioPage()),
          GoRoute(path: '/ecommerce', builder: (context, state) => EcommercePage()),
          GoRoute(path: '/dashboard', builder: (context, state) => DashboardPage()),
          GoRoute(path: '/blog', builder: (context, state) => BlogPage()),
          ShellRoute(
              builder: (context, state, child) {
                return MainLayout(
                  child: child,
                ); // ✅ Keeps AppBar & Footer fixed
              },

              routes: [
          //       GoRoute(
          //           path: "/", // my portfolio
          //           name: RouteNames.portfolio,
          //           pageBuilder: (context, state) {
          //             return const NoTransitionPage(
          //                 child: ShortenerHomePage()); // temporary
          //             // return const MaterialPage(child: HomePage());
          //           }),
                GoRoute(
                    path: "/lynklytics/dashboard",
                    name: RouteNames.linklyticsDashboard,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage(child: DashboardPage());
                    }),
                GoRoute(
                    path: "/linklytics",
                    name: RouteNames.linklytics,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage(child: ShortenerHomePage());
                    }),
                GoRoute(
                    path: "/linklytics/login",
                    name: RouteNames.linklyticsLogin,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage(child: LoginPage());
                    }),
                GoRoute(
                    path: "/linklytics/login/otp",
                    name: RouteNames.linklyticsOtpLogin,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage(child: OtpLoginPage());
                    }),
                GoRoute(
                    path: "/linklytics/register",
                    name: RouteNames.linklyticsRegister,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage(child: RegisterPage());
                    }),
              ]),
        ]);
  }
}
