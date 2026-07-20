/// Supplies links received from the operating system.
abstract interface class AppLinkSource {
  /// Returns the link that launched the app, if one exists.
  Future<Uri?> getInitialLink();

  /// Emits links received while the application is running.
  Stream<Uri> get onLink;
}
