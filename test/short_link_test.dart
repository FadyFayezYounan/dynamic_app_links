import 'package:dynamic_app_links/dynamic_app_links.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildShortLink delegates to the configured backend provider', () async {
    ShortLinkParameters? capturedParameters;
    final dynamicLinks = DynamicAppLinks(
      shortLinkProvider: CallbackShortLinkProvider((parameters) {
        capturedParameters = parameters;
        return ShortLinkResult(
          shortUrl: Uri.parse('https://s.example.com/abc'),
          originalUrl: parameters.link,
          id: 'abc',
        );
      }),
      configuration: const DynamicAppLinksConfiguration(
        allowedHosts: <String>{'links.example.com'},
      ),
    );
    final parameters = ShortLinkParameters(
      link: Uri.parse('https://links.example.com/products/42'),
      alias: 'product-42',
    );

    final result = await dynamicLinks.buildShortLink(parameters);

    expect(capturedParameters, same(parameters));
    expect(result.shortUrl, Uri.parse('https://s.example.com/abc'));
    expect(result.originalUrl, parameters.link);
    await dynamicLinks.dispose();
  });

  test('buildShortLink throws when no provider is configured', () async {
    final dynamicLinks = DynamicAppLinks(
      configuration: const DynamicAppLinksConfiguration(
        allowedHosts: <String>{'links.example.com'},
      ),
    );

    expect(
      () => dynamicLinks.buildShortLink(
        ShortLinkParameters(
          link: Uri.parse('https://links.example.com/products/42'),
        ),
      ),
      throwsA(isA<ShortLinkProviderNotConfiguredException>()),
    );
    await dynamicLinks.dispose();
  });
}
