import 'app_link_data.dart';

/// Outcome produced by navigation handling.
enum LinkHandlingStatus {
  /// The configured handler navigated to the destination.
  handled,

  /// The handler intentionally declined the destination or was not configured.
  ignored,

  /// The incoming URI failed validation.
  invalid,

  /// Resolution or navigation threw an error.
  failed,
}

/// Describes the outcome of processing and navigating an App Link.
final class LinkHandlingResult {
  const LinkHandlingResult._({
    required this.status,
    this.link,
    this.error,
    this.stackTrace,
  });

  /// Creates a successful result.
  const LinkHandlingResult.handled(AppLinkData link)
      : this._(status: LinkHandlingStatus.handled, link: link);

  /// Creates an intentionally ignored result.
  const LinkHandlingResult.ignored(AppLinkData link)
      : this._(status: LinkHandlingStatus.ignored, link: link);

  /// Creates an invalid-link result.
  const LinkHandlingResult.invalid(Object error, StackTrace stackTrace)
      : this._(
          status: LinkHandlingStatus.invalid,
          error: error,
          stackTrace: stackTrace,
        );

  /// Creates a failed result.
  const LinkHandlingResult.failed({
    AppLinkData? link,
    required Object error,
    required StackTrace stackTrace,
  }) : this._(
          status: LinkHandlingStatus.failed,
          link: link,
          error: error,
          stackTrace: stackTrace,
        );

  /// Processing status.
  final LinkHandlingStatus status;

  /// Prepared App Link data when preparation succeeded.
  final AppLinkData? link;

  /// Validation, resolution, or handler error.
  final Object? error;

  /// Stack trace associated with [error].
  final StackTrace? stackTrace;

  /// Whether navigation completed successfully.
  bool get isHandled => status == LinkHandlingStatus.handled;

  @override
  String toString() {
    return 'LinkHandlingResult('
        'status: $status, '
        'link: $link, '
        'error: $error'
        ')';
  }
}
