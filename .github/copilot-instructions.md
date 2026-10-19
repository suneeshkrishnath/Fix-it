# Copilot Instructions

This repository contains **Fix-it**, a Flutter prototype for an Apartment Service Management System (ASMS). The mobile app currently supports Android only and is intended for apartment residents.

## Before Implementation

Read these available documents:

1. `ADENT.md` for repository-wide coding guidance and project boundaries.
2. `docs/project_planning.md` for intended product goals and MVP workflows.
3. `docs/implementation_plan.md` for planned sequencing, adapted to the existing Flutter app.
4. `docs/UI_GUIDLINES.md` for Material 3 guidance only; its IPTV examples are from another project.

The planning documents contain a React Native and Spring Boot proposal. These are legacy technology choices, not instructions to replace the Flutter app or create a backend. Treat planned workflows and integrations as future scope unless they exist in the code or the user requests them. Do not claim prototype functionality is implemented without verifying it.

## Project Requirements

- Use Flutter and Dart; target Android only unless the user expands platform support.
- Build resident-facing flows such as OTP login, resident profile, service requests with photos, request tracking/history, and move-out requests as directed by the current task.
- Provide English and Arabic throughout the resident app, with language selection before login, a saved device preference, and right-to-left layout for Arabic.
- Use Riverpod, GoRouter, Dio, Hive, and Freezed where their corresponding functionality is needed and consistent with existing code.
- Follow Clean Architecture; keep UI code separate from business logic and data access.
- Use Material 3 and reusable widgets.
- Write tests for business logic and meaningful UI behavior.
- Do not use Provider, GetX, or Bloc.
- Do not add a backend, external integrations, or dependencies without user direction and a clear need.

Prioritize maintainability, readability, and testability. Preserve the existing project structure and avoid unrelated changes.
