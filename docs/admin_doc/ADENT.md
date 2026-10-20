# Administrator Tablet App - Agent Instructions

## Product and Platform

- This folder documents the planned administrator module for Fix-it.
- The admin module is a separate Android tablet app, not an admin mode inside the resident/technician phone app.
- Proposed packaging is a sibling Flutter app in the same repository; confirm app identity, workspace, and shared-code boundaries before scaffolding.
- Stage 9 is **On Hold**. Do not imply admin screens, backend integration, account management, or notification delivery already exist.

## Before Implementation

Read:

1. `docs/project_planning.md` for product roles and workflow decisions.
2. `docs/implementation_plan.md` Stage 9 for the shared backend/admin scope and current hold status.
3. `.docs/Admin_doc/admin_project_plan.md` for the admin module requirements.
4. `.docs/Admin_doc/admin_implementation_plan.md` for implementation sequencing and acceptance gates.
5. `.docs/Admin_doc/admin_ui_guidelines.md` for tablet behavior.

## Scope

Admin work is expected to include campus/building/apartment hierarchy, tenant and tenancy records, technician accounts, roles/permissions, request review, assignment/reassignment, appointments, status history, completion approval, reopening review, operational notifications, and approved reports.

The current resident/technician prototypes use local mock data. Do not connect admin behavior to pretend-shared local Hive data or claim synchronization. Stage 9 requires an approved backend/API and authorization model before the workflows are treated as shared.

## Engineering Requirements

- Use Flutter and Dart for Android tablet UI and follow the selected repository architecture.
- Preserve a separate app entry point and application identity from the phone app if implementing the planned sibling app.
- Define repository/API boundaries; keep transport and persistence out of widgets.
- Enforce role permissions in the backend/API, not only by hiding UI controls.
- Record actor, timestamp, decision, and required reason for audited work-order events.
- Do not choose a backend framework, database, cloud provider, auth provider, push provider, or file-storage integration without approval.
- Do not add dependencies/external services without clear need and direction.
- Add tests for authorization, workflow transitions, timing rules, notification recipients, and tablet interactions.
- Run relevant tests and `flutter analyze`; validate tablet build/layout when the target project exists.

## Workflow Rules

- Appointment proposals require both tenant and admin approval; keep the existing appointment until both approve.
- Technician rejection requires a reason; notify admin only, and keep tenant-facing status Pending / In Progress while admin reviews.
- Work Blocked requires reason/details and is visible to tenant and admin.
- Technician completion records comments and elapsed work time but does not close the order.
- Close only after tenant acceptance and admin approval.
- The tenant may reopen within 24 hours of official closure with a reason; admin reviews and accepts the reopened issue before further work.
- Preserve complete status history; do not erase earlier assignment, appointment, decision, or closure events.
