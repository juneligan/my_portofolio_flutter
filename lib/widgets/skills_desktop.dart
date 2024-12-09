import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';
import 'package:my_portfolio_flutter/constants/skill_items.dart';

class SkillsDesktop extends StatelessWidget {
  const SkillsDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // platforms
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450.0),
          child: Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            children: [
              for (int i = 0; i < platformItems.length; i++)
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                      color: CustomColor.bgLight2,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0
                      ),
                      leading: Image.asset(platformItems[i]["img"]),
                      title: Text(platformItems[i]["title"])
                  ),
                )
            ],
          ),
        ),
        const SizedBox(width: 50),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (int i = 0; i < skillItems.length; i++)
                  Chip(
                      backgroundColor: CustomColor.bgLight2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12
                      ),
                      label: Text(skillItems[i]["title"]),
                      avatar: Image.asset(skillItems[i]["img"]))
              ],
            ),
          ),
        )
      ],
    );
  }
}
