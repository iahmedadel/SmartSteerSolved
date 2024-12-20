import 'package:car_app/maps_screen.dart';
import 'package:car_app/settings_screen.dart';
import 'package:flutter/material.dart';

import 'emergency_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of pages for the navigation
  final List<Widget> _pages = [
    const TechnologiesScreen(),
    EmergencyScreen(),
    SettingsScreen(),
    const AboutScreen(),
    const ContactUsScreen(),
    MapsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'images/background.jpg'), // Path to your background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: _pages[_selectedIndex], // Display the selected page
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'Technologies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black, // Black color for selected item
        unselectedItemColor:
            Colors.grey[800], // Dark grey color for unselected items
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold), // Bold label for selected item
      ),
    );
  }
}

// Placeholder screens for navigation
class TechnologiesScreen extends StatelessWidget {
  const TechnologiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Technologies Screen'));
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('About Screen'));
  }
}

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Contact Us Screen'));
  }
}
