/// Parameters sent to the application's short-link backend.
final class ShortLinkParameters {
  /// Creates short-link parameters.
  ShortLinkParameters({
    required this.link,
    this.alias,
    this.expiresAt,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) : metadata = Map<String, Object?>.unmodifiable(metadata);

  /// The canonical App Link to shorten.
  final Uri link;

  /// Optional custom alias requested from the backend.
  final String? alias;

  /// Optional expiration time requested from the backend.
  final DateTime? expiresAt;

  /// Backend-specific values that do not belong to the package's core model.
  final Map<String, Object?> metadata;

  /// Converts the parameters to a backend-friendly map.
  Map<String, Object?> toMap() => <String, Object?>{
        'link': link.toString(),
        if (alias != null) 'alias': alias,
        if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
        if (metadata.isNotEmpty) 'metadata': metadata,
      };

  @override
  String toString() => 'ShortLinkParameters(${toMap()})';
}
