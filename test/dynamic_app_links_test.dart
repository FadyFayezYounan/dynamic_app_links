import 'dart:async';

import 'package:dynamic_app_links/dynamic_app_links.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_app_link_source.dart';

void main() {
  group('DynamicAppLinks', () {
    test('coordinates the initial link and stream duplicate', () async {
      final initialCompleter = Completer<Uri?>();
      final source = FakeAppLinkSource(initialLink: initialCompleter.future);
      final dynamicLinks = DynamicAppLinks(
        source: source,
        configuration: const DynamicAppLinksConfiguration(
          allowedHosts: <String>{'links.example.com'},
        ),
      );
      final events = <AppLinkData>[];
      final subscription = dynamicLinks.onLink.listen(events.add);
      final uri = Uri.parse('https://links.example.com/products/42');

      source.add(uri);
      await Future<void>.delayed(Duration.zero);
      initialCompleter.complete(uri);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(events, hasLength(1));
      expect(events.single.uri, uri);

      await subscription.cancel();
      await dynamicLinks.dispose();
      await source.close();
    });

    test('resolves an incoming short URL before emitting it', () async {
      final source = FakeAppLinkSource();
      final dynamicLinks = DynamicAppLinks(
        source: source,
        resolver: CallbackAppLinkResolver((uri) {
          expect(uri, Uri.parse('https://s.example.com/abc'));
          return Uri.parse('https://links.example.com/products/42');
        }),
        configuration: const DynamicAppLinksConfiguration(
          allowedHosts: <String>{'s.example.com', 'links.example.com'},
        ),
      );
      final linkFuture = dynamicLinks.onLink.first;

      source.add(Uri.parse('https://s.example.com/abc'));
      final link = await linkFuture;

      expect(link.originalUri, Uri.parse('https://s.example.com/abc'));
      expect(link.uri, Uri.parse('https://links.example.com/products/42'));
      expect(link.wasResolved, isTrue);

      await dynamicLinks.dispose();
      await source.close();
    });

    test('reports an untrusted host and keeps the stream alive', () async {
      final source = FakeAppLinkSource();
      final dynamicLinks = DynamicAppLinks(
        source: source,
        configuration: const DynamicAppLinksConfiguration(
          allowedHosts: <String>{'links.example.com'},
        ),
      );
      final errors = <Object>[];
      final validLinkCompleter = Completer<AppLinkData>();
      final subscription = dynamicLinks.onLink.listen(
        (link) {
          if (!validLinkCompleter.isCompleted) {
            validLinkCompleter.complete(link);
          }
        },
        onError: errors.add,
      );

      source.add(Uri.parse('https://evil.example.com/products/42'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      source.add(Uri.parse('https://links.example.com/products/42'));

      expect((await validLinkCompleter.future).uri.host, 'links.example.com');
      expect(errors, hasLength(1));
      expect(errors.single, isA<UntrustedAppLinkException>());

      await subscription.cancel();
      await dynamicLinks.dispose();
      await source.close();
    });

    test('startListening invokes the navigation handler', () async {
      final source = FakeAppLinkSource();
      AppLinkData? handledLink;
      final dynamicLinks = DynamicAppLinks(
        source: source,
        handler: (link) {
          handledLink = link;
          return true;
        },
        configuration: const DynamicAppLinksConfiguration(
          allowedHosts: <String>{'links.example.com'},
        ),
      );
      final resultFuture = dynamicLinks.onHandlingResult.first;
      await dynamicLinks.startListening();

      source.add(Uri.parse('https://links.example.com/products/42'));
      final result = await resultFuture;

      expect(result.status, LinkHandlingStatus.handled);
      expect(handledLink?.uri.path, '/products/42');

      await dynamicLinks.dispose();
      await source.close();
    });

    test('a handler failure does not stop later links', () async {
      final source = FakeAppLinkSource();
      var callCount = 0;
      final dynamicLinks = DynamicAppLinks(
        source: source,
        handler: (link) {
          callCount += 1;
          if (callCount == 1) {
            throw StateError('navigation failed');
          }
          return true;
        },
        configuration: const DynamicAppLinksConfiguration(
          allowedHosts: <String>{'links.example.com'},
        ),
      );
      final resultsFuture = dynamicLinks.onHandlingResult.take(2).toList();
      await dynamicLinks.startListening();

      source.add(Uri.parse('https://links.example.com/products/1'));
      source.add(Uri.parse('https://links.example.com/products/2'));
      final results = await resultsFuture;

      expect(results.first.status, LinkHandlingStatus.failed);
      expect(results.last.status, LinkHandlingStatus.handled);
      expect(callCount, 2);

      await dynamicLinks.dispose();
      await source.close();
    });

    test('handleLink returns invalid for an untrusted manual URI', () async {
      final source = FakeAppLinkSource();
      final dynamicLinks = DynamicAppLinks(
        source: source,
        configuration: const DynamicAppLinksConfiguration(
          allowedHosts: <String>{'links.example.com'},
        ),
      );

      final result = await dynamicLinks.handleLink(
        Uri.parse('https://evil.example.com/products/42'),
      );

      expect(result.status, LinkHandlingStatus.invalid);
      expect(result.error, isA<UntrustedAppLinkException>());

      await dynamicLinks.dispose();
      await source.close();
    });
  });
}
