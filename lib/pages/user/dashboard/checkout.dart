import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// ignore: public_member_api_docs
class CheckoutPage extends StatefulWidget {
  // ignore: public_member_api_docs

  const CheckoutPage({
    super.key,
    required this.url,
    this.returnUrl,
  });
  // ignore: public_member_api_docs
  final String url;
  final String? returnUrl;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(onNavigationRequest: (request) {
          if (request.url.contains('success')) {
            Navigator.pop(context, true);
            print(request.url);
            return NavigationDecision.prevent;
          }
          if (request.url.contains('failed')) {
            Navigator.pop(context, false);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }, onWebResourceError: (error) async {
          final dialog = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Something went wrong'),
                content: Text('$error'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('close'),
                  )
                ],
              );
            },
          );
          if (dialog) {
            Navigator.pop(context, false);
          }
        }),
      )
      ..addJavaScriptChannel('Paymongo', onMessageReceived: (message) {
        if (message.message == '3DS-authentication-complete') {
          Navigator.pop(context, true);
          return;
        }
        if (message.message.contains('success')) {
          Navigator.pop(context, true);
          return;
        }
        if (message.message.contains('failed')) {
          Navigator.pop(context, false);
        }
      })
      ..loadRequest(Uri.parse(widget.url));

    _webViewController = controller;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
          body: SafeArea(
        child: WebViewWidget(
          controller: _webViewController,
        ),
      )),
    );
  }
}
