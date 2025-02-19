import 'package:flutter/material.dart';
import 'package:my_portfolio_flutter/url_shortener/widgets/main_layout.dart';

class ShortenerHomePage extends StatefulWidget {
  const ShortenerHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<ShortenerHomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroSection(),
          _buildFeaturesSection(),
        ],
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Column(
    //       children: [
    //         _buildNavBar(),
    //         Expanded(
    //           child: SingleChildScrollView(
    //             child: Column(
    //               children: [
    //                 _buildHeroSection(),
    //                 _buildFeaturesSection(),
    //               ],
    //             ),
    //           ),
    //           // child: Center(
    //           //   child: _buildLoginOrRegister(),
    //           // ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildNavBar() {
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
          const Text(
            'Linklytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              _navItem("Home"),
              _navItem("About"),
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
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _signUpButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'SignUp',
        style: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Linklytics Simplifies URL Shortening For Efficient Sharing.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Linklytics streamlines the process of URL shortening, making sharing links effortless and efficient.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text('Manage Links',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Create Short Link'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: Image.network(
          //     'https://via.placeholder.com/400',
          //     height: 250,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Trusted by individuals and teams at the world best companies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _featureCard('Simple URL Shortening',
                  'Experience the ease of creating short, memorable URLs in just a few clicks.'),
              _featureCard('Powerful Analytics',
                  'Gain insights into your link performance with our analytics dashboard.'),
              _featureCard('Enhanced Security',
                  'Rest assured with our robust security measures and encryption.'),
              _featureCard('Fast and Reliable',
                  'Enjoy lightning-fast redirects and high uptime.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureCard(String title, String description) {
    return SizedBox(
      width: 300,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(description, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
