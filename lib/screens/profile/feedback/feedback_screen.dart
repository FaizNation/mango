import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../email/web_email_view.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _sending = false;

  Future<void> _sendEmail() async {
    final subject = Uri.encodeComponent(_subjectController.text.trim());
    final body = Uri.encodeComponent(_bodyController.text.trim());
    setState(() => _sending = true);
    try {
      if (kIsWeb) {
        final gmailComposeWeb = Uri.parse(
          'https://mail.google.com/mail/?view=cm&to=novaatalagrab@gmail.com&su=$subject&body=$body',
        );
        if (!await launchUrl(
          gmailComposeWeb,
          mode: LaunchMode.externalApplication,
        )) {
          final mailto =
              'mailto:novaatalagrab@gmail.com?subject=$subject&body=$body';
          final Uri uri = Uri.parse(mailto);
          if (!await launchUrl(uri)) {
            throw Exception('Could not launch mail client');
          }
        }
      } else {
        final gmailCompose = Uri.parse(
          'https://mail.google.com/mail/?view=cm&to=novaatalagrab@gmail.com&su=$subject&body=$body',
        );
        try {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => WebEmailView(url: gmailCompose)),
          );
        } catch (_) {
          final mailto =
              'mailto:novaatalagrab@gmail.com?subject=$subject&body=$body';
          final Uri uri = Uri.parse(mailto);
          if (!await launchUrl(uri)) {
            throw Exception('Could not launch mail client');
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to open mail client: $e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        title: const Text('Feedback / Bug Report'),
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
                ElevatedButton(
                  onPressed: _sending ? null : _sendEmail,
                  child: _sending
                      ? const CircularProgressIndicator()
                      : const Text('Send'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
