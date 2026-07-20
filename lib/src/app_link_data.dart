import 'app_link_resolver.dart';
import 'app_link_source_type.dart';

/// A validated and optionally resolved App Link.
final class AppLinkData {
  /// Creates App Link data.
  const AppLinkData({
    required this.originalUri,
    required this.uri,
    required this.source,
    required this.receivedAt,
  });

  /// The URI received from the operating system or caller.
  final Uri originalUri;

  /// The canonical URI produced after optional backend resolution.
  final Uri uri;

  /// How this link entered the package.
  final AppLinkSourceType source;

  /// When the package received the link.
  final DateTime receivedAt;

  /// Whether an [AppLinkResolver] changed the incoming URI.
  bool get wasResolved => originalUri != uri;

  @override
  String toString() {
    return 'AppLinkData('
        'originalUri: $originalUri, '
        'uri: $uri, '
        'source: $source, '
        'receivedAt: $receivedAt'
        ')';
  }
}
