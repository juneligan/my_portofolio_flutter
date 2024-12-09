import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';

class MainMobile extends StatelessWidget {
  const MainMobile({super.key, required this.onNavButtonTap});
  final Function(int) onNavButtonTap;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 30
      ),
      height: screenHeight,
      constraints: const BoxConstraints(minHeight: 560.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avatar
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(colors: [
                CustomColor.scaffoldBg.withOpacity(0.6),
                CustomColor.scaffoldBg.withOpacity(0.6)
              ]).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: Image.asset(
                "assets/flutter_dash_avatar_v2.png",
                width: screenWidth
            ),
          ),
          const SizedBox(height: 30.0),
          // intro txt
          const Text("Hi,\nI'm June Ligan\nA Flutter Developer",
              style: TextStyle(
                  height: 1.5,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.whitePrimary
              )
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 205.0,
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        CustomColor.yellowSecondary
                    )
                ),
                onPressed: () {
                  onNavButtonTap(3);
                },
                child: const Text("Get in touch",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColor.whiteSecondary)
                )
            ),
          )

          // btn
        ],
      ),
    );
  }
}
