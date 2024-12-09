import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';
import 'package:my_portfolio_flutter/utils/project_utils.dart';

import 'project_card.dart';

class ProjectSection extends StatelessWidget {
  const ProjectSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      child: Column(
        children: [
          // Work projects title
          const Text(
            "Work Projects",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CustomColor.whitePrimary
            ),
          ),
          // Work projects cards
          const SizedBox(height: 50),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Wrap(
                spacing: 25,
                runSpacing: 25,
                children: [
                  for(int i = 0; i < workProjectUtils.length; i++)
                    ProjectCard(project: workProjectUtils[i])
                ]
            ),
          )
        ],
      ),
    );
  }
}
