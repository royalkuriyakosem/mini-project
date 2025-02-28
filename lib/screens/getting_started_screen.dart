import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _markAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenGettingStarted', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildPage(
            context,
            'Welcome to Aidify',
            'Your personal assistant for accessibility.',
            'assets/images/welcome.png', // Replace with your asset path
          ),
          _buildPage(
            context,
            'Features',
            'Explore various features like text-to-speech, object detection, and more.',
            'assets/images/features.png', // Replace with your asset path
          ),
          _buildPage(
            context,
            'Get Started',
            'Let\'s get started with Aidify!',
            'assets/images/get_started.png', // Replace with your asset path
          ),
        ],
      ),
      bottomSheet: _currentPage == 2
          ? TextButton(
              onPressed: () async {
                await _markAsSeen();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Finish',
                style: TextStyle(fontSize: 18),
              ),
            )
          : TextButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }

  Widget _buildPage(BuildContext context, String title, String description,
      String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath,
              height: 250), // Ensure you have these images in your assets
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
