import 'package:dynamic_app_links/dynamic_app_links.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLinkParameters', () {
    test('builds a canonical link and merges query parameters', () {
      final parameters = AppLinkParameters(
        baseUri: Uri.parse('https://links.example.com/app?language=en'),
        path: '/products/42',
        queryParameters: const <String, dynamic>{'campaign': 'summer'},
        fragment: 'details',
      );

      expect(
        parameters.toUri(),
        Uri.parse(
          'https://links.example.com/app/products/42'
          '?language=en&campaign=summer#details',
        ),
      );
    });

    test('rejects a base URI without a scheme', () {
      final parameters = AppLinkParameters(
        baseUri: Uri.parse('links.example.com'),
      );

      expect(parameters.toUri, throwsA(isA<InvalidAppLinkException>()));
    });
  });
}
