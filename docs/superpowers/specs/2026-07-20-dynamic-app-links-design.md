# Dynamic App Links Package Design

## Goal

Build a Flutter package with a Firebase Dynamic Links-style facade while using
`app_links` for native Android App Links and iOS Universal Links. The package
owns link coordination, validation, optional backend resolution, canonical-link
building, backend-agnostic short-link creation, and router-independent
navigation handling.

## Boundaries

The package does not own notifications, backend hosting, install detection,
store fallback, deferred deep links, or analytics attribution. Native platform
link delivery remains delegated to `app_links`.

## Public API

`DynamicAppLinks` exposes `getInitialLink`, `onLink`, `buildLink`,
`buildShortLink`, `handleLink`, `startListening`, `stopListening`, and
`dispose`. Applications configure an `AppLinkResolver`, `ShortLinkProvider`,
and `AppLinkHandler` through constructor injection.

## Event flow

The source stream is subscribed before the initial-link Future is awaited. Both
paths enter a serialized preparation pipeline. Incoming and resolved URIs are
validated against trusted schemes and hosts. Resolved URI duplicates are
suppressed inside a configurable time window. Prepared events are emitted on a
broadcast stream; optional navigation runs in a separate serialized queue so a
handler failure cannot terminate future link delivery.

## Testing

Unit tests replace the native source and backend collaborators. Coverage
includes canonical URI construction, provider delegation, initial/stream
coordination, resolution, trust validation, navigation success, and navigation
failure recovery. GitHub Actions runs formatting, analysis, and tests with the
stable Flutter SDK.
