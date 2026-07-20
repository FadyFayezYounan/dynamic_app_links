/// Validation and event-coordination settings for `DynamicAppLinks`.
final class DynamicAppLinksConfiguration {
  /// Creates App Link configuration.
  const DynamicAppLinksConfiguration({
    this.allowedSchemes = const <String>{'https'},
    this.allowedHosts = const <String>{},
    this.duplicateWindow = const Duration(seconds: 2),
  });

  /// URI schemes accepted by the package.
  ///
  /// Scheme matching is case-insensitive. An empty set accepts every scheme.
  final Set<String> allowedSchemes;

  /// Trusted incoming and resolved URI hosts.
  ///
  /// Host matching is case-insensitive. Include both the short-link host and
  /// canonical App Link host when an `AppLinkResolver` is configured. An empty
  /// set accepts every host.
  final Set<String> allowedHosts;

  /// Repeated resolved URIs received within this period are emitted once.
  final Duration duplicateWindow;
}
