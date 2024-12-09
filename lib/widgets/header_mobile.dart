import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/styles/style.dart';
import 'package:my_portfolio_flutter/widgets/site_logo.dart';

class HeaderMobile extends StatelessWidget {
  const HeaderMobile({super.key, this.onLogosTap, this.onMenuTap});
  final VoidCallback? onLogosTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kHeaderDecoration,
      height: 50.0,
      margin: const EdgeInsets.fromLTRB(40, 5, 20, 5) ,
      child: Row(
        children: [
          SiteLogo(onTap: onLogosTap,),
          const Spacer(),
          IconButton(onPressed: onMenuTap, icon: const Icon(Icons.menu)),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
