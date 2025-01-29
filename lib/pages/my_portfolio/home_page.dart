import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/constants/colors.dart';
import 'package:my_portfolio_flutter/constants/size.dart';
import 'package:my_portfolio_flutter/widgets/contact_section.dart';
import 'package:my_portfolio_flutter/widgets/drawer_mobile.dart';
import 'package:my_portfolio_flutter/widgets/footer.dart';
import 'package:my_portfolio_flutter/widgets/header_desktop.dart';
import 'package:my_portfolio_flutter/widgets/header_mobile.dart';
import 'package:my_portfolio_flutter/widgets/main_desktop.dart';
import 'package:my_portfolio_flutter/widgets/main_mobile.dart';
import 'package:my_portfolio_flutter/widgets/project_section.dart';
import 'package:my_portfolio_flutter/widgets/skills_desktop.dart';
import 'package:my_portfolio_flutter/widgets/skills_mobile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final List<GlobalKey> navBarKeys = List.generate(4, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          key: scaffoldKey,
          endDrawer: constraints.maxWidth >= kMinDesktopWidth
              ? null
              : DrawerMobile(onNavItemTap: (int navIndex) {
                scaffoldKey.currentState?.closeEndDrawer();
                scrollToSection(navIndex);
              }),
          backgroundColor: CustomColor.scaffoldBg,
          body: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // header
                SizedBox(
                  key: navBarKeys.first,
                ),
                if (constraints.maxWidth >= kMinDesktopWidth)
                  HeaderDesktop(
                    onNavMenuTap: (int navIndex) {
                      scrollToSection(navIndex);
                    },
                  )
                else
                  HeaderMobile(
                    onLogosTap: () {},
                    onMenuTap: () {
                      scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),
                // main
                if (constraints.maxWidth >= kMinDesktopWidth)
                  MainDesktop(onNavButtonTap: (int navIndex) {
                    scrollToSection(navIndex);
                  },)
                else
                  MainMobile(onNavButtonTap: (int navIndex) {
                    scrollToSection(navIndex);
                  },),
                // SKILLS
                Container(
                  key: navBarKeys[1],
                  width: screenWidth,
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
                  color: CustomColor.bgLight1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "What I can do",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: CustomColor.whitePrimary),
                      ),
                      const SizedBox(height: 50),
                      if (constraints.maxWidth >= kMedDesktopWidth)
                        const SkillsDesktop()
                      else
                        const SkillsMobile(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // PROJECTS
                ProjectSection(key: navBarKeys[2]),
                const SizedBox(height: 30),
                // CONTACT
                ContactSection(key: navBarKeys[3]),
                // FOOTER
                const Footer()
              ],
            ),
          ));
    });
  }

  void scrollToSection(int navIndex) {
    if (navIndex == 4) {
      // open a blog page
      return;
    }
    final key = navBarKeys[navIndex];
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
