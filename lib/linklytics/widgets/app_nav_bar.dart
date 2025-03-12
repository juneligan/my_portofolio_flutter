import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/linklytics/i18/texts.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text_styles.dart';

class AppNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(text: AppBarText.title.en, type: TextType.xl),
          Row(
            children: [
              _navItem(AppBarText.home.en),
              _navItem(AppBarText.about.en),
              _signUpButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(title, style: AppTextStyles.navBarItem),
    );
  }

  Widget _signUpButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(AppBarText.signIn.en, style: AppTextStyles.buttonText),
    );
  }
}