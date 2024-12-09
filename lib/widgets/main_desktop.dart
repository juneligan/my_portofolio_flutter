import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';

class MainDesktop extends StatelessWidget {
  const MainDesktop({super.key, required this.onNavButtonTap});
  final Function(int) onNavButtonTap;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: screenHeight/1.2,
      constraints: const BoxConstraints(minHeight: 350.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Hi,\nI'm June Ligan\nA Flutter Developer",
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.whitePrimary
                    )
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 250,
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
              ],
            ),
            Image.asset(
                "assets/flutter_dash_avatar_v2.png",
                width: screenWidth/2),
          ]
      ),
    );
  }
}
