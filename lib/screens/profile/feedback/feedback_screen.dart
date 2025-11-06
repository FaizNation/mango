import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Impor Bloc
import 'package:mango/screens/profile/email/web_email_view.dart';
// url_launcher tidak perlu diimpor di sini lagi

import 'package:mango/cubits/screens/profile/feedback/feedback_screen_cubit.dart';
import 'package:mango/cubits/screens/profile/feedback/feedback_screen_state.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Controller tetap di sini
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  
  // HAPUS: bool _sending = false;
  // HAPUS: Future<void> _sendEmail() async { ... }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Sediakan Cubit
    return BlocProvider(
      create: (context) => FeedbackCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFE6F2FF),
        appBar: AppBar(
          title: const Text('Feedback / Bug Report'),
          backgroundColor: const Color(0xFFE6F2FF),
        ),
        // 2. Gunakan BlocListener untuk Aksi (Navigasi & SnackBar)
        body: BlocListener<FeedbackCubit, FeedbackState>(
          listener: (context, state) {
            
            if (state is FeedbackError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            // Inilah cara Cubit memberi tahu UI untuk navigasi
            if (state is FeedbackShowWebView) {
              try {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => WebEmailView(url: state.url)),
                );
              } catch (_) {
                // Jika push gagal, panggil fungsi fallback di Cubit
                context.read<FeedbackCubit>().launchMailtoFallback(
                      _subjectController.text,
                      _bodyController.text,
                    );
              }
            }
          },
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _subjectController,
                      decoration: const InputDecoration(labelText: 'Subject'),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TextField(
                        controller: _bodyController,
                        decoration: const InputDecoration(
                          labelText: 'Describe the issue or feedback',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        expands: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // 3. Gunakan BlocBuilder untuk membangun Tombol
                    BlocBuilder<FeedbackCubit, FeedbackState>(
                      builder: (context, state) {
                        // Cek apakah state sedang 'sending'
                        final isSending = state is FeedbackSending;
                        
                        return ElevatedButton(
                          onPressed: isSending
                              ? null // Nonaktifkan tombol saat 'sending'
                              : () {
                                  // Panggil Cubit saat tombol ditekan
                                  context.read<FeedbackCubit>().sendEmail(
                                        _subjectController.text,
                                        _bodyController.text,
                                      );
                                },
                          child: isSending
                              ? const CircularProgressIndicator()
                              : const Text('Send'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}