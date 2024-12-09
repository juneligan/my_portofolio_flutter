
import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';
import 'package:my_portfolio_flutter/utils/project_utils.dart';
import 'dart:js' as js;

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key, required this.project,
  });
  final ProjectUtils project;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 290.0,
      width: 260.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColor.bgLight2
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            project.image,
            height: 140.0,
            width: 260.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
            child: Text(
              project.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: CustomColor.whitePrimary
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(
              project.subtitle,
              style: const TextStyle(
                  fontSize: 12,
                  color: CustomColor.whiteSecondary
              ),
            ),
          ),
          const Spacer(),
          // footer projects
          Container(
            color: CustomColor.bgLight1,
            padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10
            ),
            child: Row(
              children: [
                const Text(
                  "Available on:",
                  style: TextStyle(
                      color: CustomColor.yellowSecondary,
                      fontSize: 10
                  ),
                ),
                const Spacer(),
                // if (project.iosLlink != null)
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                        "assets/ios_icon.png", width: 19
                    ),
                  ),
                ),
                // if (project.androidLink != null)
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                        "assets/android_icon.png", width: 17
                    ),
                  ),
                ),

                if (project.webLink != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: InkWell(
                      onTap: () {
                        js.context.callMethod("open", [project.webLink]);
                      },
                      child: Image.asset(
                          "assets/web_icon.png", width: 17
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}