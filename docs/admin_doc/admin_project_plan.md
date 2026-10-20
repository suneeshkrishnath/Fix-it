# Fix-it Administrator Tablet App - Project Plan

## Status and Scope

**Status: In Progress (local prototype).** The administrator module is a separate Android tablet app in this repository, distinct from the resident/technician phone app, with a unique application ID. Shared backend and production authentication remain unimplemented.

The current admin prototype provides a tablet dashboard and local campus, building/block/tower, and apartment lists with search/filtering and add/edit/deactivate controls. Tenant management can add tenant contact details to an active apartment with tenancy dates. The agreement attachment control is a placeholder; no file is selected or stored. Property, tenant, and tenancy changes are in-memory and reset on app restart. Request operations, technician/admin role enforcement, and backend synchronization are not implemented yet.

The admin app and phone app must use a shared backend for identity, property records, requests, assignments, appointments, work status, and audit history. The existing resident and technician prototypes use local mock data and are not a backend contract. Backend framework, hosting, database, authentication provider, and notification provider are undecided.

## Administrator Users and Access

- Administrators sign in to the tablet app using an approved account and authentication policy.
- The system must support configurable roles and permissions; do not assume a fixed role hierarchy until approved.
- Enforce permissions in the backend/API as well as in the UI.
- Record the actor and timestamp for every create, edit, deactivation, assignment, appointment decision, status change, and approval.

## Core Workflows

### Property Management

Maintain the property hierarchy:

Campus -> Building/Tower -> Apartment/Unit

Administrators can add, edit, search, and deactivate property records. Prevent deletion/deactivation that would orphan active tenancy, request, or history records.

### Resident and Tenancy Management

- Add, edit, search, and deactivate resident/tenant records.
- Associate a tenant with an apartment and tenancy dates/details.
- View resident contact information and apartment/tenancy context when authorized.

### Technician and Role Management

- Add, edit, search, and deactivate technician accounts.
- Maintain specialty and availability information.
- Assign roles and permissions to administrator accounts and operational users.

### Request Review and Assignment

- Review new requests, category, description, priority, attachments when supported, location, and preferred appointment time.
- Approve, reject, or request additional information with a recorded reason.
- Assign or reassign a technician and schedule an appointment.
- Review technician acceptance, rejection, work progress, blockers, completion comments, and elapsed work time.
- Review request, assignment, appointment, tenant decision, and status history.

### Appointment Change Approval

When a technician proposes a different appointment time, send the same proposal to the tenant and administrator. Keep the current appointment until both approve. If either rejects, retain the current appointment and record the decision and actor.

### Completion, Closure, and Reopening

- Technician completion changes the work order to **Work Completed - Awaiting Confirmation**; it does not close the work order.
- The tenant accepts or rejects the completed work. After tenant acceptance, an administrator reviews and approves completion. Close only after both approvals.
- If the tenant rejects completion, return the work order to an appropriate active status for further work.
- A tenant can reopen a closed work order within 24 hours of its official closure, with a reason. The administrator reviews and accepts it for further action; then it returns to the appropriate assignment/work stage.

### Technician Status Review

- **Work Accepted:** administrator can see technician acceptance.
- **Work Rejected:** technician must provide a reason. Notify the administrator only; keep the tenant-facing status Pending / In Progress during admin review. The administrator reassigns or records another action.
- **Travelling to Site / Work Started:** show status and timestamps to authorized roles.
- **Work Blocked:** require reason/details; admin can review and coordinate resolution.
- **Work Completed:** show completion comments, completion time, and elapsed time from work start for history and technician billing.

### Notifications and Reporting

- Provide administrator visibility for request acceptance, technician assignment/reassignment, appointment changes, rejection, travel/start, blocked work, completion, tenant decision, closure, and reopening.
- Route resident/technician notifications according to the approved workflow; rejection is admin-only while under review.
- Provide operational reports for requests, assignment history, work time, appointments, and status outcomes as a later acceptance scope.
- No push service or external provider is selected yet.

## Data and Security Requirements

- Shared records must cover campuses, buildings, apartments, residents, tenancy, technicians, roles, requests, assignments, appointments, status history, approvals, and audit events.
- Residents may access only their own records; technicians may access only their assignments and necessary job details; administrators may access records allowed by their role.
- Protect APIs with authenticated role checks and HTTPS. UI hiding alone is not authorization.
- Preserve closed, rejected, reopened, and reassigned history; prefer deactivation over destructive deletion of referenced records.

## Dependencies and Decisions

- Stage 9 is on hold. The admin app depends on a selected shared backend and agreed API/data model.
- Confirm admin account authentication, role definitions, property hierarchy ownership, and required reports before implementation.
- Confirm appointment rejection/timeout behavior and admin service-level expectations.
- Select backend, database, hosting, push provider, and file storage before committing to integrations.

## Definition of Done

- Administrators can manage properties, residents/tenancies, technicians, roles, requests, assignments, and appointments from a tablet-optimized app.
- Backend authorization enforces role boundaries.
- Both tenant and administrator decisions are recorded before appointment changes or closure are applied.
- Rejection, blocker, completion, closure, and reopen events retain actor, timestamp, reason where required, and work history.
- Updates are visible to authorized phone-app roles through the shared backend.
- Loading, empty, validation, error, confirmation, offline, and permission-denied states are tested.
