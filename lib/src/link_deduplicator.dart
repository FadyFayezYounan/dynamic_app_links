final class LinkDeduplicator {
  LinkDeduplicator(this.window);

  final Duration window;
  final Map<String, DateTime> _seenAt = <String, DateTime>{};

  bool isDuplicate(Uri uri, DateTime now) {
    if (window == Duration.zero) {
      return false;
    }

    _seenAt.removeWhere(
      (_, timestamp) => now.difference(timestamp) > window,
    );

    final key = _keyFor(uri);
    final previous = _seenAt[key];
    _seenAt[key] = now;
    return previous != null && now.difference(previous) <= window;
  }

  static String _keyFor(Uri uri) {
    final queryPairs = <MapEntry<String, String>>[];
    for (final entry in uri.queryParametersAll.entries) {
      for (final value in entry.value) {
        queryPairs.add(MapEntry<String, String>(entry.key, value));
      }
    }
    queryPairs.sort((first, second) {
      final keyComparison = first.key.compareTo(second.key);
      return keyComparison != 0
          ? keyComparison
          : first.value.compareTo(second.value);
    });

    final sortedQuery = queryPairs
        .map(
          (entry) => '${Uri.encodeQueryComponent(entry.key)}='
              '${Uri.encodeQueryComponent(entry.value)}',
        )
        .join('&');

    return uri
        .normalizePath()
        .replace(
          scheme: uri.scheme.toLowerCase(),
          host: uri.host.toLowerCase(),
          query: sortedQuery,
        )
        .toString();
  }
}
