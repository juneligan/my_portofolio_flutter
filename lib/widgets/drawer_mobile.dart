import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';
import 'package:my_portfolio_flutter/constants/nav_items.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({super.key, required this.onNavItemTap});
  final Function(int) onNavItemTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColor.scaffoldBg,
      child: ListView(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close)
              )
          ),
        ),
        for(int i = 0; i < navIcons.length; i++)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
            leading: Icon(navIcons[i]),
            titleTextStyle: const TextStyle(
                color: CustomColor.whitePrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16
            ),
            onTap: () {
              onNavItemTap(i);
            },
            title: Text(navTitles[i]),
          )
      ]),
    );
  }
}