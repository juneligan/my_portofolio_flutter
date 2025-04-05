import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/api_route_names.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';

class UrlRedirectionPage extends ConsumerStatefulWidget {
  final String? shortUrl;

  const UrlRedirectionPage({super.key, this.shortUrl});

  @override
  ConsumerState<UrlRedirectionPage> createState() =>
      _ExternalRedirectPageState();
}

class _ExternalRedirectPageState extends ConsumerState<UrlRedirectionPage> {

  @override
  void initState() {
    super.initState();
    // You can still access Riverpod state here via `ref` if needed

    if (widget.shortUrl == null) {
      return;
    }
    // Redirect to external URL
    html.window.location.href =
    '${ApiRouteName.domain.path}${ApiRouteName.redirectToUrl.applyParams(
        {'shortUrl': widget.shortUrl!}).replaceFirst('api/', '')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.shortUrl == null
                ? SizedBox(height: 16,)
                : CircularProgressIndicator(),
            SizedBox(height: 16),
            widget.shortUrl == null ? AppText(
                'Sorry, Invalid url', type: TextType.md) : Text(
                'Redirecting to external site...'),
          ],
        ),
      ),
    );
  }
}
