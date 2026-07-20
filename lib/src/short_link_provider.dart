import 'dart:async';

import 'short_link_parameters.dart';
import 'short_link_result.dart';

/// Creates short links using an application-owned backend.
abstract interface class ShortLinkProvider {
  /// Sends [parameters] to the backend and returns its short-link result.
  Future<ShortLinkResult> createShortLink(ShortLinkParameters parameters);
}

/// Creates short links by invoking an application-provided callback.
final class CallbackShortLinkProvider implements ShortLinkProvider {
  /// Creates a callback short-link provider.
  const CallbackShortLinkProvider(this.callback);

  /// Callback that integrates with the application's backend client.
  final FutureOr<ShortLinkResult> Function(ShortLinkParameters parameters)
      callback;

  @override
  Future<ShortLinkResult> createShortLink(ShortLinkParameters parameters) {
    return Future<ShortLinkResult>.sync(() => callback(parameters));
  }
}
