import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Model data
    final List<TeamMember> leadMembers = [
      TeamMember(
        name: 'King Faiz Nation',
        role: 'Lead Developer',
        description:
            'Memimpin pengembangan aplikasi dan mengoordinasikan tim teknis.',
        imageUrl: 'https://unavatar.io/github/faiznation',
        githubUrl: 'https://github.com/faiznation',
        instagramUrl: 'https://www.instagram.com/faiz_natioon/',
      ),
    ];

    final List<TeamMember> otherMembers = [
      TeamMember(
        name: 'Jenar Aditiya B',
        role: 'Frontend Developer',
        description: 'Bertanggung jawab atas desain antarmuka dan frontend.',
        imageUrl: 'https://unavatar.io/github/jennn1-jr',
        githubUrl: 'https://github.com/jennn1-jr',
        instagramUrl: 'https://www.instagram.com/jenar_aditiya/',
      ),
      TeamMember(
        name: 'Mia Audina I A',
        role: 'Content Writer',
        description: 'Membuat konten informatif dan menarik untuk pengguna.',
        imageUrl: 'https://unavatar.io/github/MyaruL',
        githubUrl: 'https://github.com/MyaruL',
        instagramUrl: 'https://www.instagram.com/myariesh/',
      ),
      TeamMember(
        name: 'Febriana N A',
        role: 'Content Writer',
        description: 'Menghasilkan teks deskriptif dan panduan penggunaan aplikasi.',
        imageUrl: 'https://unavatar.io/github/beeena4',
        githubUrl: 'https://github.com/beeena4',
        instagramUrl: 'https://www.instagram.com/fbenaa/',
      ),
      TeamMember(
        name: 'Faqih Rafasha A',
        role: 'Hacker & Bug Hunter',
        description: 'Menganalisis pola penggunaan, mengidentifikasi *bug*, .',
        imageUrl: 'https://unavatar.io/github/Argandhi23',
        githubUrl: 'https://github.com/Argandhi23',
        instagramUrl: 'https://www.instagram.com/argandhi__/',
      ),
      TeamMember(
        name: 'Manda Fatimah A',
        role: 'Content Writer',
        description: 'Menyusun konten yang jelas dan mudah dipahami pengguna.',
        imageUrl: 'https://unavatar.io/github/mandaazaziah',
        githubUrl: 'https://github.com/mandaazaziah',
        instagramUrl: 'https://www.instagram.com/fattyma.nda/',
      ),
      TeamMember(
        name: 'Felicia Andara L',
        role: 'Content Writer',
        description: 'Membuat konten yang menarik dan relevan untuk aplikasi.',
        imageUrl: 'https://unavatar.io/github/feliciaandaraaa',
        githubUrl: 'https://github.com/feliciaandaraaa',
        instagramUrl: 'https://www.instagram.com/flcaadr/',
      ),
      TeamMember(
        name: 'Keisa Aushafa D',
        role: 'Content Writer',
        description: 'Menghasilkan konten yang informatif dan engaging untuk pengguna.',
        imageUrl: 'https://unavatar.io/github/KeisaAushafa',
        githubUrl: 'https://github.com/KeisaAushafa',
        instagramUrl: 'https://www.instagram.com/keshfaa/',
      ),
      TeamMember(
        name: 'Leony Andika T',
        role: 'DevOps',
        description: 'Mengelola deployment dan konfigurasi CI/CD.',
        imageUrl: 'https://unavatar.io/github/leooalderic',
        githubUrl: 'https://github.com/leooalderic',
        instagramUrl: 'https://www.instagram.com/lny.andika/',
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
  final String imageUrl; 
  final String githubUrl;
  final String instagramUrl;

  TeamMember({
    required this.name,
    required this.role,
    required this.description,
    required this.imageUrl, 
    required this.githubUrl,
    required this.instagramUrl,
  });
}

// Reusable card widget
class TeamCard extends StatelessWidget {
  final TeamMember member;
  final bool isLead;
  const TeamCard({super.key, required this.member, this.isLead = false});

  void _openUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault, 
        webOnlyWindowName: '_blank',      
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa membuka link: $url')),
      );
    }
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
              backgroundImage: member.imageUrl.startsWith('http')
                  ? NetworkImage(member.imageUrl)
                  : AssetImage(member.imageUrl) as ImageProvider,
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
                  icon: const FaIcon(FontAwesomeIcons.github),
                  tooltip: 'GitHub',
                  onPressed: () => _openUrl(context, member.githubUrl),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagram),
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