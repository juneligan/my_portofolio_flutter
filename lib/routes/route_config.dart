import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/pages/my_portfolio/home_page.dart';
import 'package:my_portfolio_flutter/url_shortener/pages/dashboard_page.dart';
import 'package:my_portfolio_flutter/url_shortener/pages/login_page.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';
import 'package:my_portfolio_flutter/screens/initial_screen.dart';

class RouteConfig {
  static GoRouter returnRouter() {
    return GoRouter(initialLocation: "/", routes: [
      GoRoute(
          path: "/", // my portfolio
          name: RouteNames.initial,
          pageBuilder: (context, state) {
            return const MaterialPage(child: HomePage());
          }),
      GoRoute(
          path: "/login",
          name: RouteNames.login,
          pageBuilder: (context, state) {
            return const MaterialPage(child: LoginPage());
          }),
      GoRoute(
          path: "/dashboard",
          name: RouteNames.dashboard,
          pageBuilder: (context, state) {
            return const MaterialPage(child: DashboardPage());
          }),
    ]);
  }
}
