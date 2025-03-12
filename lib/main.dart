import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio_flutter/constants/project_names.dart';
import 'package:my_portfolio_flutter/routes/route_config.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouteConfig.returnRouter(),
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      // theme: ThemeData.dark(),
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Sans',
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       routerConfig: RouteConfig.returnRouter(),
//       debugShowCheckedModeBanner: false,
//       showSemanticsDebugger: false,
//       theme: ThemeData.dark(),
//       // theme: ThemeData(
//       //   textTheme: GoogleFonts.interTextTheme(),
//       // ),
//       title: 'June Ligan',
//     );
//   }
// }
