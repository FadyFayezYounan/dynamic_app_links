import 'dart:async';

/// Converts an incoming link into the canonical URI understood by the app.
///
/// A backend can use this contract to resolve a short URI into its final App
/// Link. Applications whose backend redirects directly to the final link can
/// keep the default [PassthroughAppLinkResolver].
abstract interface class AppLinkResolver {
  /// Resolves [uri] into the canonical application URI.
  Future<Uri> resolve(Uri uri);
}

/// Returns incoming URIs unchanged.
final class PassthroughAppLinkResolver implements AppLinkResolver {
  /// Creates a passthrough resolver.
  const PassthroughAppLinkResolver();

  @override
  Future<Uri> resolve(Uri uri) async => uri;
}

/// Resolves links by invoking an application-provided callback.
final class CallbackAppLinkResolver implements AppLinkResolver {
  /// Creates a callback resolver.
  const CallbackAppLinkResolver(this.callback);

  /// Callback used to resolve incoming links.
  final FutureOr<Uri> Function(Uri uri) callback;

  @override
  Future<Uri> resolve(Uri uri) => Future<Uri>.sync(() => callback(uri));
}
