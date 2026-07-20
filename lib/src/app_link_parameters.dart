import 'dynamic_app_links_exception.dart';

/// Parameters used to construct a canonical App Link.
final class AppLinkParameters {
  /// Creates App Link parameters.
  AppLinkParameters({
    required this.baseUri,
    this.path = '',
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    this.fragment,
  }) : queryParameters = Map<String, dynamic>.unmodifiable(queryParameters);

  /// The application's HTTPS App Link prefix.
  ///
  /// Example: `https://links.example.com`.
  final Uri baseUri;

  /// A path relative to [baseUri].
  ///
  /// Leading and trailing slashes are normalized when the URI is built.
  final String path;

  /// Query parameters merged with any parameters already present in [baseUri].
  ///
  /// Values accepted by [Uri.replace] are supported, including a string or an
  /// iterable of strings.
  final Map<String, dynamic> queryParameters;

  /// Optional URI fragment. When omitted, the fragment in [baseUri] is kept.
  final String? fragment;

  /// Builds the canonical URI.
  Uri toUri() {
    if (!baseUri.hasScheme) {
      throw const InvalidAppLinkException(
        'AppLinkParameters.baseUri must contain a URI scheme.',
      );
    }

    final mergedQueryParameters = <String, dynamic>{
      ...baseUri.queryParametersAll,
      ...queryParameters,
    };

    return baseUri.replace(
      path: _joinPaths(baseUri.path, path),
      queryParameters:
          mergedQueryParameters.isEmpty ? null : mergedQueryParameters,
      fragment: fragment,
    );
  }

  static String _joinPaths(String basePath, String childPath) {
    final normalizedBase = basePath.endsWith('/') && basePath.length > 1
        ? basePath.substring(0, basePath.length - 1)
        : basePath;
    final normalizedChild = childPath.startsWith('/')
        ? childPath.substring(1)
        : childPath;

    if (normalizedChild.isEmpty) {
      return normalizedBase;
    }
    if (normalizedBase.isEmpty || normalizedBase == '/') {
      return '/$normalizedChild';
    }
    return '$normalizedBase/$normalizedChild';
  }

  @override
  String toString() => 'AppLinkParameters(${toUri()})';
}
