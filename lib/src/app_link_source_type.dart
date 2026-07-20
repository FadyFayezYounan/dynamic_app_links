/// Describes how a link entered the package.
enum AppLinkSourceType {
  /// The link launched the application.
  initial,

  /// The operating system delivered the link while the app was running.
  incoming,

  /// Application code submitted the link directly.
  manual,
}
