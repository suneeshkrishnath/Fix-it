# ADENT.md

Version: 1.1

This file defines how AI coding assistants should work in this repository.

## Project Overview

**Project:** Fix-it, an Apartment Service Management System (ASMS)

**Product:** A Flutter mobile application for apartment residents to submit and follow up on maintenance and service requests.

**Current status:** Prototype. Android is the only supported platform. Do not describe planned functionality as already implemented.

The product plan describes these intended resident workflows:

- Sign in with a phone number, apartment number, and OTP
- View resident and apartment information
- Create service requests, add details, and attach photos
- Track request status and view service history
- Submit and track move-out requests

The plan excludes online payments, chat, AI categorization, a vendor marketplace, and multilingual support from the MVP. Technician and administrator workflows are not part of the resident mobile app unless the user explicitly expands its scope.

## Source Documents and Conflicts

Read the relevant available documents before implementation:

1. `docs/project_planning.md` for product goals and planned MVP scope.
2. `docs/implementation_plan.md` for planned feature sequencing, adapting it to the actual Flutter project.
3. `docs/UI_GUIDLINES.md` for general Material 3 direction only. Its IPTV-specific examples and visual requirements are from another project and do not apply to Fix-it.

The planning documents contain a React Native mobile and Spring Boot backend proposal. These are legacy technology choices and do not override the actual Flutter Android app. Do not create or migrate to a React Native app, add a backend, or assume external services exist unless the user requests that work. Treat integrations and API details in the plan as proposals; use mocks or existing project implementations for the prototype.

When instructions conflict, follow the user's latest direction, then the actual repository and its existing conventions. Keep changes limited to the requested prototype scope.

## Platform and Technology

- Use Flutter and Dart; support Android only for now.
- Use Riverpod for state management.
- Use GoRouter for navigation.
- Use Dio for HTTP when networking is needed.
- Use Hive for local persistence when persistence is needed.
- Use Freezed and JSON serialization for immutable models when appropriate.
- Use Material 3 and reusable Flutter widgets.
- Follow Clean Architecture and keep dependencies pointing inward. Presentation code must not access infrastructure directly; route data access through repositories.
- Do not introduce Provider, GetX, Bloc, or another state-management framework.
- Do not add packages or external services without a clear need and justification.

Preserve the repository's existing structure and conventions. For new feature code, keep presentation, domain, and data responsibilities separate without moving unrelated files.

## Prototype and Product Scope

- Implement only the resident-facing flows needed for the current task.
- Prefer simple, testable mock data where a real service is not available; make mock behavior clear in code and UI where relevant.
- Do not claim authentication, uploads, push notifications, or server synchronization are production-ready unless they are actually implemented.
- Do not add iOS support, production backend integration, payment processing, or unplanned product features without explicit direction.
- Treat performance, availability, and security figures in planning documents as future targets, not verified properties of this prototype.

## Implementation Practices

- Keep business logic out of widgets and screens.
- Use repositories as the boundary for data sources; do not make direct HTTP calls from UI code.
- Handle errors explicitly and present useful loading, error, empty, and success states where applicable.
- Use `const` constructors where practical and lazy builders for long lists.
- Avoid unrelated refactors and keep public APIs stable unless the task requires a change.
- Add or update tests for business logic and meaningful UI behavior.
- Never commit secrets, credentials, or API keys.

## Documentation and Completion

- Update relevant documentation when behavior or scope changes.
- Do not refer to absent documents such as `docs/ARCHITECTURE.md`, `docs/CODING_STANDARD.md`, or `docs/TASK_TRACKER.md` as required project files; create them only when specifically needed.
- For code changes, run the narrowest relevant tests, then `flutter analyze` when available. For Android-specific changes, validate the Android build when practical.
- Report checks that could not be run. Do not claim tests or builds passed without running them.