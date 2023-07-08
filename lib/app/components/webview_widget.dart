import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';
import 'package:getx_skeleton/app/data/models/contact_model.dart';
import 'package:getx_skeleton/app/services/logger_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../routes/app_pages.dart';

class WebViewWidget0 extends StatefulWidget {
  final String url;
  final ContactModel? contactModel;
  final VoidCallback onPaymentSuccessCallBack;

  const WebViewWidget0({Key? key, required this.url, this.contactModel, required this.onPaymentSuccessCallBack}) : super(key: key);

  //const WebViewWidget({required this.url});

  @override
  _WebViewWidget0State createState() => _WebViewWidget0State();
}

class _WebViewWidget0State extends State<WebViewWidget0> {
  String selectedUrl = "";
  double value = 0.0;
  bool _canRedirect = true;
  bool _isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setUserAgent(
        'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            _redirect(url, model: widget.contactModel);
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            _redirect(url, model: widget.contactModel);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Payment Subscription",
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: Center(
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _redirect(String url, {ContactModel? model}) {
    if (_canRedirect) {
      bool _isSuccess = url.contains('success');
      bool _isFailed = url.contains('fail');
      bool _isCancel = url.contains('cancel');
      if (_isSuccess || _isFailed || _isCancel) {
        _canRedirect = false;
      }
      if (_isSuccess) {
        try {
          widget.onPaymentSuccessCallBack();
        } catch (e) {
          LoggerServices.find.logError(e);
        }

        // Get.offUntil(GetPageRoute(page: () => HomePage()), (route) => route.settings.name == Routes.HOME);
      }
      if (_isCancel) {
        Get.offAllNamed(Routes.HOME);
        // Get.offUntil(GetPageRoute(page: () => HomePage()), (route) => route.settings.name == Routes.HOME);
        CustomSnackBar.showCustomErrorToast(message: "You've cancelled the payment.");
      }
    }
  }
}
