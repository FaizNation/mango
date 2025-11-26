import 'package:flutter/material.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Model data
    final List<TeamMember> leadMembers = [
      TeamMember(
        name: 'King Faiz Nation',
        role: 'Lead Developer (Ketua Tim)',
        description:
            'Memimpin arsitektur dan mengawasi implementasi fitur inti aplikasi.',
        imagePath: 'assets/images/masjenar.png',
        githubUrl: 'https://github.com/faiznation',
        instagramUrl: 'https://instagram.com/faiznation',
      ),
      TeamMember(
        name: 'Dezkrazzer',
        role: 'Full Stack (Co-Lead)',
        description:
            'Menjamin kualitas dan stabilitas aplikasi lewat pengujian menyeluruh.',
        imagePath: 'assets/images/masakbar.png',
        githubUrl: 'https://github.com/dezkrazzer',
        instagramUrl: 'https://instagram.com/dezkrazzer',
      ),
    ];

    final List<TeamMember> otherMembers = [
      TeamMember(
        name: 'Jenar',
        role: 'Frontend Developer',
        description: 'Bertanggung jawab atas desain antarmuka dan frontend.',
        imagePath: 'assets/images/user_placeholder.png',
        githubUrl: 'https://github.com/Jenar',
        instagramUrl: 'https://instagram.com/Jenar',
      ),
      TeamMember(
        name: 'Mia',
        role: 'UI/UX Designer',
        description: 'Bertanggung jawab atas desain antarmuka pengguna, Dan Pengimplementasian UI.',
        imagePath: 'assets/images/user_placeholder.png',
        githubUrl: 'https://github.com/Mia',
        instagramUrl: 'https://instagram.com/Mia',
      ),
      TeamMember(
        name: 'Febri',
        role: 'Backend & Database Manager',
        description: 'Mengelola koneksi server dan memastikan data aman',
        imagePath: 'assets/images/user_placeholder.png',
        githubUrl: 'https://github.com/Febri',
        instagramUrl: 'https://instagram.com/Febri',
      ),
      TeamMember(
        name: 'Faqih',
        role: 'Hacker & Bug Hunter',
        description: 'Menganalisis pola penggunaan, mengidentifikasi *bug*, .',
        imagePath: 'assets/images/user_placeholder.png',
        githubUrl: 'https://github.com/faqih',
        instagramUrl: 'https://instagram.com/faqih',
      ),
      TeamMember(
        name: 'Manda Fatimah A',
        role: 'Backend Developer',
        description: 'Membangun.',
        imagePath: 'assets/images/user_placeholder.png',
        githubUrl: 'https://github.com/mandaazaziah',
        instagramUrl: 'https://instagram.com/manda',
      ),
      TeamMember(
        name: 'Felicia',
        role: 'Frontend Developer',
        description: 'Menyusun komponen UI dan interaksi pengguna.',
        imagePath: 'assets/images/user_placeholder.png',
        githubUrl: 'https://github.com/felicia',
        instagramUrl: 'https://instagram.com/felicia',
      ),
      TeamMember(
        name: 'Keisa',
        role: 'QA Engineer',
        description: 'Menulis skenario pengujian dan melaporkan bug.',
        imagePath: 'assets/images/user_placeholder.png',
        githubUrl: 'https://github.com/keisa',
        instagramUrl: 'https://instagram.com/keisa',
      ),
      TeamMember(
        name: 'Leonbot',
        role: 'DevOps',
        description: 'Mengelola deployment dan konfigurasi CI/CD.',
        imagePath: 'assets/images/user_placeholder.png',
        githubUrl: 'https://github.com/leonbot',
        instagramUrl: 'https://instagram.com/leonbot',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Our Team',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Group of aspiring engineers want to make a practical and useful web application to aid and facilitate the job searching process after the coding bootcamp.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // LEADS: King Faiz & Dezkrazzer (always at top, side by side)
                LayoutBuilder(builder: (context, constraints) {
                  final double cardWidth =
                      constraints.maxWidth > 800 ? 420 : constraints.maxWidth / 1.05;
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: leadMembers
                        .map((m) => SizedBox(
                              width: cardWidth,
                              child: TeamCard(member: m, isLead: true),
                            ))
                        .toList(),
                  );
                }),

                const SizedBox(height: 28),

                // OTHER MEMBERS (8 members) - grid-like responsive
                LayoutBuilder(builder: (context, constraints) {
                  const double spacing = 16;
                  final double maxW = constraints.maxWidth;
                  // Breakpoints:
                  // >=1000 -> 4 columns (desktop)
                  // >=700  -> 3 columns (tablet)
                  // <700   -> 2 columns (phone)
                  final int columns = maxW >= 1000 ? 4 : (maxW >= 700 ? 3 : 2);
                  final double totalSpacing = spacing * (columns - 1);
                  final double itemWidth = (maxW - totalSpacing) / columns;

                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: spacing,
                    runSpacing: 16,
                    children: otherMembers
                        .map((m) => SizedBox(
                              width: itemWidth.clamp(200, 420),
                              child: TeamCard(member: m),
                            ))
                        .toList(),
                  );
                }),

                const SizedBox(height: 28),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'This application was developed by our team to fulfill the midterm assignment for the platform-based programming course at Surabaya State University.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Simple model for team member
class TeamMember {
  final String name;
  final String role;
  final String description;
  final String imagePath;
  final String githubUrl;
  final String instagramUrl;

  TeamMember({
    required this.name,
    required this.role,
    required this.description,
    required this.imagePath,
    required this.githubUrl,
    required this.instagramUrl,
  });
}

// Reusable card widget
class TeamCard extends StatelessWidget {
  final TeamMember member;
  final bool isLead;
  const TeamCard({super.key, required this.member, this.isLead = false});

  void _openUrl(BuildContext context, String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open URL: $url')),
    );
    // Replace above SnackBar with url_launcher if you want to actually open links.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isLead ? 6 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isLead ? const Color(0xFFF1F8FF) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular image
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: AssetImage(member.imagePath),
            ),
            const SizedBox(height: 12),
            Text(
              member.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isLead ? FontWeight.w700 : FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              member.role,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue.shade700,
                fontStyle: FontStyle.italic,
                fontWeight: isLead ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // description with constrained height to avoid overflow zebra
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 72),
              child: Text(
                member.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            // Social icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.code),
                  tooltip: 'GitHub',
                  onPressed: () => _openUrl(context, member.githubUrl),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  color: Colors.pink,
                  tooltip: 'Instagram',
                  onPressed: () => _openUrl(context, member.instagramUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}