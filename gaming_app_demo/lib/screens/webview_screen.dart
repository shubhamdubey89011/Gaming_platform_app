import 'package:flutter/material.dart';
import 'package:gaming_app_demo/providers/webview_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  void _initializeWebViewController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    // Create the WebViewController from Platform-specific params
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            Provider.of<WebViewProvider>(context, listen: false)
                .setLoading(true);
          },
          onPageFinished: (url) {
            Provider.of<WebViewProvider>(context, listen: false)
                .setLoading(false);
          },
          onWebResourceError: (error) {
            _showErrorDialog(
                context, 'Failed to load page: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(
          Provider.of<WebViewProvider>(context, listen: false).selectedUrl));

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final webViewProvider = Provider.of<WebViewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gaming Platform'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Select Game Platform',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Create a ListTile for each website
            for (int i = 0; i < webViewProvider.urlNames.length; i++)
              ListTile(
                title: Text(webViewProvider.urlNames[i]),
                onTap: () {
                  webViewProvider.setSelectedUrl(
                      webViewProvider.urls[i]); // Update the selected URL
                  _controller.loadRequest(Uri.parse(
                      webViewProvider.selectedUrl)); // Load the new URL
                  Navigator.pop(context); // Close the drawer
                },
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (_controller != null)
            RefreshIndicator(
              onRefresh: () async {
                _controller.reload();
              },
              child: WebViewWidget(controller: _controller),
            )
          else
            const Center(child: CircularProgressIndicator()),
          if (webViewProvider.isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.reload();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }
}
