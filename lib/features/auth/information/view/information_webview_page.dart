import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:digital_oms_sheba/core/constant/colors_custom.dart';

class InformationWebviewPage extends StatefulWidget {
  final String title;
  final String url;

  const InformationWebviewPage({super.key, required this.title, required this.url});

  @override
  State<InformationWebviewPage> createState() => _InformationWebviewPageState();
}

class _InformationWebviewPageState extends State<InformationWebviewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: myGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: myGreen),
            ),
        ],
      ),
    );
  }
}
