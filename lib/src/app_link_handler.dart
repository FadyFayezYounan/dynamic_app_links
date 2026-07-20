import 'dart:async';

import 'app_link_data.dart';

/// Navigates to the destination represented by [link].
///
/// Return `true` when the application handled the destination and `false` when
/// it intentionally ignored it.
typedef AppLinkHandler = FutureOr<bool> Function(AppLinkData link);
