import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false; // Track theme mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              // Toggle theme mode
              if (isDarkMode) {
                // Dark Mode
                ThemeData.dark();
              } else {
                // Light Mode
                ThemeData.light();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.person, size: 40),
                SizedBox(width: 16),
                Text('Your Name: Hari', style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.phone, size: 40),
                SizedBox(width: 16),
                Text('Phone Number: +91 8520016687', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
