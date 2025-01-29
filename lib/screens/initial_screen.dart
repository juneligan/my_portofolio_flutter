import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/routes/route_names.dart';


class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(RouteNames.initial),),
    );
  }
}
