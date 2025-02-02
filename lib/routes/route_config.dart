import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/pages/my_portfolio/home_page.dart';
import 'package:my_portfolio_flutter/url_shortener/pages/dashboard_page.dart';
import 'package:my_portfolio_flutter/url_shortener/pages/login_page.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';

class RouteConfig {
  static GoRouter returnRouter() {
    return GoRouter(
        initialLocation: Uri.base.toString().replaceFirst(
              '${Uri.base.origin}/#', // this is to stay on the same location
              '', // when refreshes or page reload
            ), // problem: i.e. http://localhost:52472/#/login when you reload
        // it will go back to the initiallocation if the value is fixed, so let's
        // say, the fixed value is '/', so when you reload/refresh the browser
        // it will go back to http://localhost:52472 instead of staying to
        // #/login
        routes: [
          GoRoute(
              path: "/", // my portfolio
              name: RouteNames.portfolio,
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
