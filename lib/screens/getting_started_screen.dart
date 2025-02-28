import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  bool _isDarkMode = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: PageView(
        controller: _pageController,
        children: [
          _buildPage('Welcome to Aidify!', 'Your personal assistant for accessibility.', 'assets/images/welcome.png'),
          _buildPage('Features', 'Explore various features like text-to-speech, object detection, and more.', 'assets/images/features.png'),
          _buildPage('Get Started', 'Let\'s get started with Aidify!', 'assets/images/get_started.png'),
          _buildDarkModeSelectionPage(), // New page for dark mode selection
        ],
      ),
    );
  }

  Widget _buildPage(String title, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250),
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

  Widget _buildDarkModeSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you want to use dark mode?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              _setDarkMode(false);
              _navigateToLogin();
            },
            child: const Text('No', style: TextStyle(fontSize: 18)),
          ),
          TextButton(
            onPressed: () {
              _setDarkMode(true);
              _navigateToLogin();
            },
            child: const Text('Yes', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
