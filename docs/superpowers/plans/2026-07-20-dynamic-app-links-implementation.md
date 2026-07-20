# Dynamic App Links Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a tested Flutter package that receives App Links, builds canonical and short links, and delegates in-app navigation.

**Architecture:** Use `app_links` only as the native source. Keep backend resolution, short-link creation, validation, deduplication, and navigation behind injected Dart contracts and one `DynamicAppLinks` facade.

**Tech Stack:** Flutter, Dart 3.5+, app_links 6.4.1–7.x, flutter_test, GitHub Actions.

## Global Constraints

- No notification handling.
- No native Android or iOS implementation inside this package.
- No hard-coded HTTP client, backend response shape, or navigation library.
- Short-link hosting, install detection, fallback, and deferred-link behavior remain backend responsibilities.

---

### Task 1: Package models and contracts

**Files:** `lib/src/*.dart`, `lib/dynamic_app_links.dart`

- [x] Define native source, resolver, short-link provider, and navigation callback contracts.
- [x] Define immutable link parameters, results, events, exceptions, and handling outcomes.
- [x] Add the `app_links` adapter and public exports.

### Task 2: Canonical and short-link creation

**Files:** `lib/src/app_link_parameters.dart`, `lib/src/short_link_*.dart`, `test/app_link_parameters_test.dart`, `test/short_link_test.dart`

- [x] Write tests for URI joining, query merging, missing schemes, provider delegation, and missing providers.
- [x] Implement canonical URI construction and backend-agnostic short-link creation.

### Task 3: Link coordination and navigation

**Files:** `lib/src/dynamic_app_links.dart`, `lib/src/link_deduplicator.dart`, `test/dynamic_app_links_test.dart`

- [x] Test initial/stream deduplication, resolution, trust errors, handler execution, and handler failure recovery.
- [x] Implement serialized preparation, validation, deduplication, unified event delivery, and navigation result delivery.

### Task 4: Documentation and continuous integration

**Files:** `README.md`, `example/`, `.github/workflows/ci.yml`, `CHANGELOG.md`, `LICENSE`

- [x] Document setup, backend customization, resolution, navigation, lifecycle, and package scope.
- [x] Add a minimal example and CI checks for formatting, analysis, and tests.
