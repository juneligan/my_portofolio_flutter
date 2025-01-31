import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/url_shortener/constants/colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: CustomColor.scaffoldBg,
      body: const SingleChildScrollView(
        child: Center(
          child: Text("Welcome to June's Place"),
        ),
      ),
    );
  }
}
