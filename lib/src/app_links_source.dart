import 'package:app_links/app_links.dart';

import 'app_link_source.dart';

/// The default [AppLinkSource] backed by the `app_links` package.
final class AppLinksSource implements AppLinkSource {
  /// Creates an App Links source.
  ///
  /// Supplying [appLinks] is useful for testing or advanced integrations.
  AppLinksSource({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;

  @override
  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  @override
  Stream<Uri> get onLink => _appLinks.uriLinkStream;
}
