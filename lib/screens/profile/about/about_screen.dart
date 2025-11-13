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
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const GFAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/images/masjenar.png'),
                ),
                const SizedBox(height: 16),

                // --- PERUBAHAN DIMULAI DI SINI ---
                // Mengganti "Faiz Nation" menjadi "Tim Pengembang" sebagai judul utama
                const Text(
                  'Tim Pengembang', // Judul utama
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12), // Sedikit dirapikan

                // Menghapus sub-judul "Tim Pengembang:"
                // dan langsung mendaftar anggota di bawah judul utama

                // Menambahkan "Faiz Nation" sebagai Ketua Tim
                const Text(
                  " King Faiz Nation",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 4), // Spasi antar nama

                // Nama Anda
                const Text(
                  "Faqih Rafasha Argandhi",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 4), // Spasi antar nama

                // Nama Anda
                const Text(
                  "Febriana Nur Aini",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 4), // Spasi antar nama

                const Text(
                  "Dezkrazzer",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 4), // Spasi antar nama

                // Placeholder untuk Jenar
                const Text(
                  "Jenar",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),

                const Text(
                  " Mia",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 4), // Spasi antar nama

                // Nama Anda
                const Text(
                  "Manda",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 4), // Spasi antar nama

                // Nama Anda
                const Text(
                  "Felicia",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 4), // Spasi antar nama

                const Text(
                  "Keisa",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 4), // Spasi antar nama

                // Placeholder untuk Jenar
                const Text(
                  "Leonbot",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                // --- AKHIR PERUBAHAN ---

                const SizedBox(height: 24),
                const Text(
                  // --- DESKRIPSI DIMODIFIKASI ---
                  'This application was developed by our team to fulfill the midterm assignment for the platform-based programming course at Surabaya State University.',
                  // Teks asli: 'This app is developed by Faiz Nation, This application was developed...'
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, height: 1.4),
                ),
                const Spacer(),
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