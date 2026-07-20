/// Result returned by a configured short-link backend.
final class ShortLinkResult {
  /// Creates a short-link result.
  ShortLinkResult({
    required this.shortUrl,
    required this.originalUrl,
    this.id,
    this.expiresAt,
    List<String> warnings = const <String>[],
    Map<String, Object?> metadata = const <String, Object?>{},
  })  : warnings = List<String>.unmodifiable(warnings),
        metadata = Map<String, Object?>.unmodifiable(metadata);

  /// The short URI returned by the backend.
  final Uri shortUrl;

  /// The canonical URI represented by [shortUrl].
  final Uri originalUrl;

  /// Optional identifier returned by the backend.
  final String? id;

  /// Optional expiration time returned by the backend.
  final DateTime? expiresAt;

  /// Non-fatal warnings returned by the backend.
  final List<String> warnings;

  /// Additional backend-specific response values.
  final Map<String, Object?> metadata;

  /// Converts the result to a map.
  Map<String, Object?> toMap() => <String, Object?>{
        'shortUrl': shortUrl.toString(),
        'originalUrl': originalUrl.toString(),
        if (id != null) 'id': id,
        if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
        if (warnings.isNotEmpty) 'warnings': warnings,
        if (metadata.isNotEmpty) 'metadata': metadata,
      };

  @override
  String toString() => 'ShortLinkResult(${toMap()})';
}
