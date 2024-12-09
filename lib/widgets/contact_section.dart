import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';
import 'package:my_portfolio_flutter/constants/size.dart';
import 'package:my_portfolio_flutter/constants/sns_links.dart';
import 'package:my_portfolio_flutter/widgets/custom_text_field.dart';
import 'dart:js' as js;

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
      color: CustomColor.bgLight1,
      child: Column(
        children: [
          // title
          const Text(
            "Get in touch",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: CustomColor.whitePrimary),
          ),
          const SizedBox(height: 50),
          ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
                maxHeight: 100,
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth >= kMinDesktopWidth) {
                  return buildNameEmailFieldDesktop();
                } else {
                  return buildNameEmailFieldMobile();
                }
              })),

          const SizedBox(height: 15),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: const CustomTextField(
              hintText: "Your message",
              maxLines: 16,
            ),
          ),
          const SizedBox(height: 20),
          // send button
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(CustomColor.yellowSecondary),
                ),
                child: const Text(
                  "Get in touch",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColor.whiteSecondary,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: const Divider()),
          const SizedBox(height: 15),

          // SNS icon button links
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  js.context.callMethod('open', [SnsLinks.github]);
                },
                child: Image.asset(
                  "assets/github.png",
                  width: 28.0,
                ),
              ),
              InkWell(
                onTap: () {
                  js.context.callMethod('open', [SnsLinks.linkedIn]);
                },
                child: Image.asset(
                  "assets/linkedin.png",
                  width: 28.0,
                ),
              ),
              InkWell(
                onTap: () {
                  js.context.callMethod('open', [SnsLinks.facebook]);
                },
                child: Image.asset(
                  "assets/facebook.png",
                  width: 28.0,
                ),
              ),
              InkWell(
                onTap: () {
                  js.context.callMethod('open', [SnsLinks.instagram]);
                },
                child: Image.asset(
                  "assets/instagram.png",
                  width: 28.0,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Row buildNameEmailFieldDesktop() {
    return const Row(
      children: [
        Flexible(child: CustomTextField(hintText: "Your name")),
        SizedBox(width: 15),
        Flexible(child: CustomTextField(hintText: "Your email"))
      ],
    );
  }

  Column buildNameEmailFieldMobile() {
    return const Column(
      children: [
        Flexible(child: CustomTextField(hintText: "Your name")),
        SizedBox(height: 15),
        Flexible(child: CustomTextField(hintText: "Your email"))
      ],
    );
  }
}
