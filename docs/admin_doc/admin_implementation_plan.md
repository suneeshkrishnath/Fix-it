# Fix-it Administrator Tablet App - Implementation Plan

## Overall Status

**Stage 9: In Progress (local tablet prototype).** The administrator app is a separate Android tablet app in this repository. Its shared backend, production authentication, and deployment are not implemented. The resident/technician phone app remains a separate app surface.

Implementation order is dependency-driven: establish the shared backend and authorization contract before building workflows that must synchronize with the phone app. Select technologies and APIs before implementation; React Native, Spring Boot, AWS, PostgreSQL, and Firebase in legacy planning material are not approved choices.

## Admin Stages

| Stage | Aim | Status | Dependency / Exit |
|---|---|---|---|
| A1 | Confirm tablet-app packaging, user roles, permissions, and workflows | Done | Separate Flutter Android tablet app in this repo; unique application ID; local prototype scope approved |
| A2 | Define shared property, identity, request, assignment, appointment, and audit data | Done | Backend-neutral entity contract recorded in `admin_data_contract.md` |
| A3 | Implement backend authentication, role enforcement, and audit foundation | On Hold | Backend stack, auth provider, hosting, and security policy need approval; prototype will use local mock data only |
| A4 | Build tablet app foundation, navigation, responsive shell, and localization | Done | Separate Android app identity, tablet navigation shell, mock operations overview, and distinct theme |
| A5 | Campus, building/tower, and apartment management | Done (local prototype) | In-memory sample hierarchy supports search, filters, add/edit, and safe deactivation; no persistence/backend sync |
| A6 | Resident/tenant and tenancy management | Done (local prototype) | Add tenants from active apartments with tenancy dates; agreement attachment is a placeholder; data is in-memory only |
| A7 | Technician accounts, specialties, availability, roles, and permissions | Done (local prototype) | Sample technician records and editable local role permissions; no authentication or server enforcement |
| A8 | Request review and technician assignment/reassignment | Done (local prototype) | Sample queue supports search/status filters, reasoned review decisions, technician assignment/reassignment, and local status history; no backend synchronization |
| A9 | Appointment scheduling and dual approval of proposed changes | Done (local prototype) | Proposal, tenant/admin decisions, and timestamps are local; scheduled time changes only after both approve, while rejection retains the current time |
| A10 | Work status review, blockers, completion approval, closure, and reopening | Planned | Full lifecycle and 24-hour reopen rule pass API/UI tests |
| A11 | Notification integration and operational reports | Planned | Provider selected; events, recipients, retries, and reports validated |
| A12 | Release, deployment, monitoring, backup, and support | Not Required Now | Explicitly excluded from this prototype request |

## Detailed Acceptance Workflows

### Property Records

- CRUD/search/deactivation for campus -> building/tower -> apartment/unit.
- Validate required hierarchy relationships and protect referenced records from destructive deletion.

### Accounts and Permissions

- Admin can manage tenant/tenancy and technician accounts within their permission scope.
- Backend rejects cross-role and out-of-scope requests even when a client calls an endpoint directly.

### Request Queue and Assignment

- Admin can inspect, filter, approve, reject, request information, assign, and reassign.
- Every rejection, reassignment, status, and decision stores actor, timestamp, and reason when required.

### Appointment Changes

- Technician proposal is delivered to both tenant and assigned admin.
- Track tenant and admin decisions independently.
- Apply the proposed time only after both approve; a rejection leaves the existing appointment active.

### Work Completion and Reopen

- Technician completion records comments, completion timestamp, and elapsed time since Work Started.
- Tenant accepts or rejects completion; admin approves after tenant acceptance.
- Work order closes only after both approvals. Rejected work returns to an appropriate active state.
- Tenant may reopen within 24 hours of official closure with a required reason; admin must review and accept it before work resumes.

### Notifications

- Work Accepted: tenant receives technician name; admin receives acceptance.
- Work Rejected: admin receives reason; tenant is not notified immediately and keeps Pending / In Progress during review.
- Travel and Work Started: tenant and admin are notified.
- Work Blocked: tenant and admin receive reason/details.
- Completion: tenant receives accept/reject request; admin receives completion and elapsed time.
- Tenant decision, admin approval, closure, and reopening notify relevant roles.

## Quality Gates

- Unit tests for policies, state transitions, access rules, and timing windows.
- API integration tests for role enforcement, auditing, dual approvals, and notification recipients.
- Tablet widget tests for CRUD, queue filtering, assignment, approvals, and error/empty states.
- End-to-end tests cover resident submission -> admin assignment -> technician work -> tenant acceptance -> admin closure -> tenant reopening.
- `flutter analyze` and tests pass for Flutter apps; backend checks are defined after stack selection.
