import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFFE6F2FF),
      ),
      body: Center(
        child: Container(
          // On wider screens, this constrains the content to a max width of 700.
          // On smaller screens (less than 700), this has no effect.
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const GFAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/images/icon.png'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Faiz Nation',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Depeloper males',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  'This app is developed by Faiz Nation, especially those that help readers discover and enjoy comics from across the world. If you have feedback or find a bug, please let me know.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, height: 1.4),
                ),
                const Spacer(), // Use Spacer to push the button to the bottom
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                const SizedBox(height: 24), // Add some padding at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
