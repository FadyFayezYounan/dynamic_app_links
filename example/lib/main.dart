import 'dart:async';

import 'package:dynamic_app_links/dynamic_app_links.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  late final DynamicAppLinks _dynamicLinks;
  StreamSubscription<AppLinkData>? _subscription;
  Uri? _latestLink;
  Uri? _latestShortLink;

  @override
  void initState() {
    super.initState();
    _dynamicLinks = DynamicAppLinks(
      configuration: const DynamicAppLinksConfiguration(
        allowedHosts: <String>{'links.example.com', 's.example.com'},
      ),
      shortLinkProvider: CallbackShortLinkProvider((parameters) {
        return ShortLinkResult(
          shortUrl: Uri.parse('https://s.example.com/demo'),
          originalUrl: parameters.link,
        );
      }),
    );
    _subscription = _dynamicLinks.onLink.listen((link) {
      setState(() => _latestLink = link.uri);
    });
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_dynamicLinks.dispose());
    super.dispose();
  }

  Future<void> _buildShortLink() async {
    final canonicalLink = _dynamicLinks.buildLink(
      AppLinkParameters(
        baseUri: Uri.parse('https://links.example.com'),
        path: 'products/42',
        queryParameters: const <String, dynamic>{'campaign': 'example'},
      ),
    );
    final result = await _dynamicLinks.buildShortLink(
      ShortLinkParameters(link: canonicalLink),
    );
    setState(() => _latestShortLink = result.shortUrl);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dynamic App Links example')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Latest incoming link: ${_latestLink ?? 'None'}'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _buildShortLink,
                child: const Text('Build example short link'),
              ),
              const SizedBox(height: 16),
              Text('Short link: ${_latestShortLink ?? 'None'}'),
            ],
          ),
        ),
      ),
    );
  }
}
