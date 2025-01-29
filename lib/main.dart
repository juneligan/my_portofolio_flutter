import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/pages/my_portfolio/home_page.dart';
import 'package:my_portfolio_flutter/routes/route_config.dart';

void main() {
  runApp(
      const ProviderScope(
        child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouteConfig.returnRouter(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'June Ligan',
    );
  }
}