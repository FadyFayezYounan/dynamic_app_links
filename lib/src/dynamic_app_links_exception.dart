/// Base exception thrown by the package.
sealed class DynamicAppLinksException implements Exception {
  /// Creates a package exception.
  const DynamicAppLinksException(
    this.message, {
    this.cause,
    this.causeStackTrace,
  });

  /// Human-readable failure description.
  final String message;

  /// Original error, when available.
  final Object? cause;

  /// Stack trace associated with [cause], when available.
  final StackTrace? causeStackTrace;

  @override
  String toString() => '$runtimeType: $message';
}

/// The URI is malformed or does not contain required App Link information.
final class InvalidAppLinkException extends DynamicAppLinksException {
  /// Creates an invalid-link exception.
  const InvalidAppLinkException(
    super.message, {
    super.cause,
    super.causeStackTrace,
  });
}

/// The URI uses a scheme or host that is not trusted by the configuration.
final class UntrustedAppLinkException extends DynamicAppLinksException {
  /// Creates an untrusted-link exception.
  const UntrustedAppLinkException(
    super.message, {
    super.cause,
    super.causeStackTrace,
  });
}

/// A backend resolver failed to produce the canonical App Link.
final class AppLinkResolutionException extends DynamicAppLinksException {
  /// Creates a link-resolution exception.
  const AppLinkResolutionException(
    super.message, {
    super.cause,
    super.causeStackTrace,
  });
}

/// No short-link provider was configured.
final class ShortLinkProviderNotConfiguredException
    extends DynamicAppLinksException {
  /// Creates a missing-provider exception.
  const ShortLinkProviderNotConfiguredException()
      : super(
          'No ShortLinkProvider is configured. Pass one to DynamicAppLinks.',
        );
}

/// The configured short-link backend failed.
final class ShortLinkCreationException extends DynamicAppLinksException {
  /// Creates a short-link creation exception.
  const ShortLinkCreationException(
    super.message, {
    super.cause,
    super.causeStackTrace,
  });
}
