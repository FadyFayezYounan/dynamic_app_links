# dynamic_app_links

A backend-agnostic Flutter package for receiving Android App Links and iOS
Universal Links, building canonical links, creating backend-powered short
links, and handling navigation inside the app.

The package intentionally delegates native link delivery to
[`app_links`](https://pub.dev/packages/app_links). Your backend remains
responsible for short-link storage, redirects, install detection, store
fallbacks, and deferred-link behavior.

## Features

- Get the initial link that launched the app.
- Listen to a unified stream containing initial and later links.
- Suppress duplicate initial/stream deliveries within a configurable window.
- Validate trusted schemes and hosts.
- Optionally resolve a short URL through your backend.
- Build canonical App Links without string concatenation.
- Create short links through any backend client.
- Handle navigation through an injected callback.
- Observe structured navigation results without terminating the link stream.

## Installation

```yaml
dependencies:
  dynamic_app_links:
    git:
      url: https://github.com/FadyFayezYounan/dynamic_app_links.git
```

Configure Android App Links and iOS Universal Links by following the platform
setup required by `app_links` and by hosting the appropriate association files
for your domain.

## Create the facade early

Instantiate the package before building the main application UI so cold-start
links are captured promptly.

```dart
final dynamicLinks = DynamicAppLinks(
  configuration: const DynamicAppLinksConfiguration(
    allowedHosts: {
      'links.example.com',
      's.example.com',
    },
  ),
);
```

`allowedHosts` should include every trusted URI that may enter or leave an
optional resolver. Keeping it empty accepts every host and is convenient for
prototyping, but explicit hosts are recommended in production.

## Receive links

`onLink` is a broadcast stream that coordinates the native initial-link Future
and incoming-link stream. Repeated resolved URIs inside `duplicateWindow` are
emitted once.

```dart
final subscription = dynamicLinks.onLink.listen(
  (data) {
    debugPrint('Original: ${data.originalUri}');
    debugPrint('Canonical: ${data.uri}');
  },
  onError: (Object error, StackTrace stackTrace) {
    // Log an invalid, untrusted, or unresolvable link.
  },
);
```

You can also read the cold-start link directly:

```dart
final initialLink = await dynamicLinks.getInitialLink();
```

## Build a canonical App Link

```dart
final canonicalLink = dynamicLinks.buildLink(
  AppLinkParameters(
    baseUri: Uri.parse('https://links.example.com'),
    path: 'products/42',
    queryParameters: const {
      'campaign': 'summer',
      'referrer': 'fady',
    },
  ),
);
```

## Integrate any short-link backend

The package does not prescribe HTTP, authentication, request fields, or
response fields. Implement `ShortLinkProvider`, or use the callback adapter
around your existing API client.

```dart
final dynamicLinks = DynamicAppLinks(
  configuration: const DynamicAppLinksConfiguration(
    allowedHosts: {'links.example.com', 's.example.com'},
  ),
  shortLinkProvider: CallbackShortLinkProvider((parameters) async {
    final response = await api.post(
      '/short-links',
      data: parameters.toMap(),
    );

    return ShortLinkResult(
      shortUrl: Uri.parse(response.data['shortUrl'] as String),
      originalUrl: parameters.link,
      id: response.data['id'] as String?,
    );
  }),
);

final result = await dynamicLinks.buildShortLink(
  ShortLinkParameters(
    link: canonicalLink,
    alias: 'summer-product',
    metadata: const {'channel': 'whatsapp'},
  ),
);
```

## Resolve an incoming short URL

Use a resolver only when the app receives the short URL itself and must ask the
backend for its final destination. When the backend redirects directly to the
canonical App Link, keep the default passthrough resolver.

```dart
final dynamicLinks = DynamicAppLinks(
  configuration: const DynamicAppLinksConfiguration(
    allowedHosts: {'s.example.com', 'links.example.com'},
  ),
  resolver: CallbackAppLinkResolver((incomingUri) async {
    if (incomingUri.host != 's.example.com') {
      return incomingUri;
    }

    final response = await api.get(
      '/short-links/resolve',
      queryParameters: {'url': incomingUri.toString()},
    );
    return Uri.parse(response.data['destination'] as String);
  }),
);
```

## Handle navigation

Navigation remains router-independent. The handler receives validated,
resolved `AppLinkData`, so it can use `go_router`, `auto_route`, Navigator, a
BLoC event, or any custom navigation system.

```dart
final dynamicLinks = DynamicAppLinks(
  configuration: const DynamicAppLinksConfiguration(
    allowedHosts: {'links.example.com'},
  ),
  handler: (link) async {
    switch (link.uri.pathSegments) {
      case ['products', final productId]:
        router.go('/products/$productId');
        return true;
      default:
        return false;
    }
  },
);

await dynamicLinks.startListening();
```

Observe navigation outcomes independently:

```dart
final resultSubscription = dynamicLinks.onHandlingResult.listen((result) {
  switch (result.status) {
    case LinkHandlingStatus.handled:
      break;
    case LinkHandlingStatus.ignored:
      break;
    case LinkHandlingStatus.invalid:
    case LinkHandlingStatus.failed:
      logger.error(result.error, result.stackTrace);
  }
});
```

For authentication or app-readiness requirements, let the handler save the link
in application state and return `false`, then call `handleLink` after the app is
ready.

```dart
final result = await dynamicLinks.handleLink(pendingUri);
```

## Lifecycle

```dart
await dynamicLinks.stopListening();
await subscription.cancel();
await resultSubscription.cancel();
await dynamicLinks.dispose();
```

## Scope

This package does not implement:

- Push-notification handling.
- Install detection or app-store fallback behavior.
- Deferred deep linking after installation.
- Short-link hosting or persistence.
- Analytics attribution.
- A hard-coded HTTP client or router dependency.

Those responsibilities stay with your backend and application architecture.
