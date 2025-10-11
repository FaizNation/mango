import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebEmailView extends StatefulWidget {
  final Uri url;
  const WebEmailView({super.key, required this.url});

  @override
  State<WebEmailView> createState() => _WebEmailViewState();
}

class _WebEmailViewState extends State<WebEmailView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
