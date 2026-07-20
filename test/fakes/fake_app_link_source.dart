import 'dart:async';

import 'package:dynamic_app_links/dynamic_app_links.dart';

final class FakeAppLinkSource implements AppLinkSource {
  FakeAppLinkSource({Future<Uri?>? initialLink})
      : _initialLink = initialLink ?? Future<Uri?>.value();

  final Future<Uri?> _initialLink;
  final StreamController<Uri> _controller = StreamController<Uri>.broadcast();

  @override
  Future<Uri?> getInitialLink() => _initialLink;

  @override
  Stream<Uri> get onLink => _controller.stream;

  void add(Uri uri) => _controller.add(uri);

  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  Future<void> close() => _controller.close();
}
