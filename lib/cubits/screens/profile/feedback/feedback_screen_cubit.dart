import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'feedback_screen_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackInitial());

  // Alamat email tujuan
  final String _toEmail = 'novaatalagrab@gmail.com';

  // Ini menggantikan _sendEmail
  Future<void> sendEmail(String subjectText, String bodyText) async {
    emit(FeedbackSending());

    final subject = Uri.encodeComponent(subjectText.trim());
    final body = Uri.encodeComponent(bodyText.trim());
    
    // URL untuk Gmail (Web & In-App)
    final gmailComposeUrl = Uri.parse(
      'https://mail.google.com/mail/?view=cm&to=novaatalagrab@gmail.com&su=$subject&body=$body',
    );
    
    // URL Fallback
    final mailtoUrl = Uri.parse(
      'mailto:$_toEmail?subject=$subject&body=$body'
    );

    try {
      if (kIsWeb) {
        // --- LOGIKA UNTUK WEB ---
        if (!await launchUrl(
          gmailComposeUrl,
          mode: LaunchMode.externalApplication,
        )) {
          // Fallback ke mailto jika Gmail gagal
          if (!await launchUrl(mailtoUrl)) {
            throw Exception('Could not launch mail client');
          }
        }
      } else {
        // --- LOGIKA UNTUK MOBILE ---
        // Kita tidak bisa Navigator.push dari Cubit.
        // Sebagai gantinya, kita emit state agar UI yang melakukannya.
        emit(FeedbackShowWebView(gmailComposeUrl));
      }
      
      // Jika sukses (web) atau setelah emit (mobile), kembali ke state awal
      emit(FeedbackInitial());

    } catch (e) {
      emit(FeedbackError('Failed to open mail client: $e'));
      // Pastikan kembali ke initial setelah error agar tombol aktif lagi
      emit(FeedbackInitial());
    }
  }

  // Fungsi ini dipanggil oleh UI JIKA navigasi ke WebEmailView gagal
  Future<void> launchMailtoFallback(String subjectText, String bodyText) async {
    emit(FeedbackSending()); // Tampilkan loading lagi
    
    final subject = Uri.encodeComponent(subjectText.trim());
    final body = Uri.encodeComponent(bodyText.trim());
    final mailtoUrl = Uri.parse(
      'mailto:$_toEmail?subject=$subject&body=$body'
    );

    try {
      if (!await launchUrl(mailtoUrl)) {
        throw Exception('Could not launch mail client');
      }
      emit(FeedbackInitial());
    } catch (e) {
      emit(FeedbackError('Failed to open mail client: $e'));
      emit(FeedbackInitial());
    }
  }
}