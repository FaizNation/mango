import 'package:equatable/equatable.dart';

// Kelas dasar
abstract class FeedbackState extends Equatable {
  const FeedbackState();
  @override
  List<Object?> get props => [];
}

// State awal, tombol bisa ditekan
class FeedbackInitial extends FeedbackState {}

// State saat tombol ditekan, tombol dinonaktifkan
class FeedbackSending extends FeedbackState {}

// State khusus untuk memberitahu UI (non-web) agar membuka WebView
class FeedbackShowWebView extends FeedbackState {
  final Uri url;
  const FeedbackShowWebView(this.url);
  @override
  List<Object?> get props => [url];
}

// State jika terjadi error, untuk menampilkan SnackBar
class FeedbackError extends FeedbackState {
  final String message;
  const FeedbackError(this.message);
  @override
  List<Object?> get props => [message];
}