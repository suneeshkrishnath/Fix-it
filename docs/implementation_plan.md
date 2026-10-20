# Apartment Service Management System
# Implementation Plan

---

## Stage Index

| Stage | Aim | Status | Remark |
|---|---|---|---|
| 1 | Project foundation | Done | Flutter Android resident prototype foundation. |
| 2 | Resident authentication | Done | Local mock OTP sign-in. |
| 3 | Resident dashboard | Done | Navigation exists; Profile and Move-out are placeholders. |
| 4 | Service requests | Done | Local request submission; photo attachments are Stage 5. |
| 5 | File uploads | Blocked | Deferred pending approved image selection and storage scope. |
| 6 | Request tracking | Done | Local timeline; no remote status updates. |
| 7 | Service history | Done | Local history and filters. |
| 7A | Resident profile and case workflow mocks | Done | Mock tenant/property profile, case timeline, technician details, and closed cases. |
| 8 | Move-out | Done | Local request submission and status tracking; no backend review updates. |
| 9 | Shared backend and administrator tablet app | In Progress | Local tablet prototypes cover properties, tenants, technicians/roles, request review/assignment, appointment dual approval, and work completion/reopen previews; shared backend/auth remains on hold. |
| 10 | Technician module in shared phone app | In Progress | Local login, jobs, and workflow-example tab are implemented; live status transitions, notifications, elapsed-time billing/history, and dual-approval completion are Planned. |
| 11 | Notifications | In Progress | Local sample inbox for tenant, technician, and admin-preview audiences; push delivery/provider integration remains Planned. |
| 12 | Production deployment | Planned | Phone app, tablet app, and shared backend. |

---

# Project Development Strategy

The project will be built in multiple stages using an incremental delivery approach.

Each stage should deliver a fully functional and testable outcome.

Copilot should complete one stage before moving to the next.

## Delivery Phases and Modules

- **Phase 1 (Stages 1-8):** Resident Android phone app and its resident workflows.
- **Phase 2 (Stages 9-12):** Shared operations backend, technician role in the phone app, separate administrator Android tablet app, notifications, and deployment.

The product has three modules across two Android apps: Resident and Technician roles share the phone app; Administrator uses a separate tablet app. The current repository has resident workflows and a local mock technician module. Authentication, assignments, service requests, profile, and move-out data are local. Do not describe mock behavior as backend-synchronized or production-ready.

---

# Stage 1
# Project Foundation and Architecture

Status: **Done** (Flutter Android prototype scope)

## Goal

Establish the Android-only Flutter project structure and baseline architecture for the resident application.

## Deliverables

### Mobile Application

- Flutter Android scaffold with application ID `com.iks.mobile.fix_it`.
- App composition and centralized GoRouter setup under `lib/app/`.
- Shared Material 3 theme under `lib/core/theme/`.
- Dashboard presentation under `lib/features/dashboard/presentation/`.
- Riverpod initialized at the application entry point.
- Flutter dependencies and a widget smoke test configured.

### Out Of Scope

- The React Native and Spring Boot projects and database schema in the original proposal are not part of this Flutter prototype. Do not create them unless the user explicitly expands scope.

## Definition Of Done

- `flutter analyze` passes.
- `flutter test` passes.
- An Android debug APK builds.
- App entry point, routing, theme, and feature presentation are separated.

---

# Stage 2
# Authentication Module

Status: **Done** (mock authentication and persisted English/Arabic selection)

## Goal

Implement resident login and fixed-code OTP verification for the Android prototype.

## Features

### Login Screen

Inputs:

- Phone Number
- Apartment Number

### OTP Screen

Inputs:

- OTP Code

### Language Selection

- Select English or Arabic on the sign-in screen before authentication.
- Save the choice on the device and restore it at app startup.
- Localize the resident app and use right-to-left layout when Arabic is selected.

### Authentication Flow

Login
→ Generate OTP
→ Verify OTP
→ Load Resident Profile
→ Dashboard

## Mock Behavior

The prototype recognizes the following resident details:

- Phone Number: `+48 500000000`
- Apartment Number: `A-302`

The local mock accepts OTP `123456` and returns a sample resident profile. The signed-in profile is stored in Hive and restored at app startup.

The planned API endpoints and database-backed resident lookup remain future backend work; they are not implemented in this Flutter prototype.

## Definition Of Done

- Valid resident details progress to OTP verification; invalid details show an error.
- A valid mock OTP loads the resident profile and opens the dashboard.
- A saved local session is restored on app startup and can be cleared by signing out.
- English and Arabic can be selected before login; the choice persists across app restarts and Arabic uses RTL layout.
- Widget tests and `flutter analyze` pass.

---

# Stage 3
# Resident Dashboard

Status: **Done** (resident navigation; later stages added mock Profile and Move-out workflows)

## Goal

Create the resident dashboard and operational navigation for the planned workflows.

## Features

Dashboard actions:

- Create Service Request
- My Requests
- History
- Move Out Request
- Profile

## Definition Of Done

- Dashboard displays resident and apartment context.
- Create Request, My Requests, History, Move Out Request, and Profile actions navigate to their routes.
- Dashboard navigation reaches the resident workflows; Profile and Move-out behavior is documented in Stages 7A and 8.
- Widget tests and `flutter analyze` pass.

---

# Stage 4
# Service Request Module

Status: **Done** (local request submission; image attachments deferred to Stage 5)

## Goal

Allow residents to create and locally persist service requests in the Android prototype.

## Features

### Category List

Free Services

- Plumbing
- Electrical
- Maintenance
- Cleaning

Paid Services

- Installation
- Home Services
- Electrical Upgrade

Additional Services (list entries only; details, pricing, and request flows are future scope)

- Housemaid
- Babysitter
- Proxy Driver
- Deep Cleaning

All apartment-related services must appear in the category list. Selecting an additional service shows it in the list only; no extra detail screens are built yet.

### Complaint Form

Fields:

- Category
- Subcategory
- Description
- Priority
- Preferred Visit Time

## API

The API endpoints remain future backend work. Requests are stored locally in Hive.

## Definition Of Done

- Category, subcategory, description, and priority can be submitted.
- Preferred visit date/time is optional.
- A confirmation screen displays the created request number.
- Widget tests and `flutter analyze` pass.
- Photo attachments are handled in Stage 5.

---

# Stage 5
# File Upload Module

Status: **Blocked / Deferred Change Request**

Change request: Revisit Android gallery/camera image selection, the five-image limit, file metadata, and upload/storage handling in a later approved stage. The `image_picker` dependency is intentionally not included yet. Do not mark this stage complete until image attachment scope is approved and its storage behavior is implemented and tested.

## Goal

Store complaint images after the deferred change request is approved.

## Implementation

The original proposal specifies remote uploads to AWS S3 and metadata in an attachments table. Neither service exists in the current Flutter prototype; do not implement the integration without explicit direction.

Proposed future storage:

AWS S3

Store metadata inside:

attachments table

## Definition Of Done

- Approved image selection works within agreed type, size, and count limits.
- Image metadata and links persist with the service request.
- Any remote upload service is explicitly configured and tested.

---

# Stage 6
# Request Tracking Module

Status: **Done** (local status timeline; remote real-time updates deferred)

## Goal

Let residents view each locally stored request and its current status timeline.

Status changes from technicians or administrators and remote real-time synchronization require a backend and remain out of scope.

## Statuses

Submitted

Accepted

Assigned

Appointment Scheduled

In Progress

Completed

Rejected

Cancelled

## UI

Timeline View

Example:

Submitted ✓

Accepted ✓

Assigned ✓

Scheduled ✓

In Progress

Completed

## Definition Of Done

- Residents can open a request from My Requests and view its details.
- A timeline reflects the request's saved status, including terminal rejected/cancelled states.
- Loading, error, and empty request-list states are handled.
- Widget tests and `flutter analyze` pass.
- Remote real-time synchronization is explicitly deferred until a backend exists.

---

# Stage 7
# Service History Module

Status: **Done** (local request history and filters)

## Goal

Allow residents to review saved service requests and filter the local history.

## Features

Filters:

- Date Range
- Category
- Status

Display

- Request Number
- Category
- Type
- Date
- Status
- Cost

## Definition Of Done

- History shows request number, category, type, date, status, and recorded cost when available.
- Date range, category, and status filters can be combined and cleared.
- Requests without a recorded cost are labeled honestly.
- Widget/unit tests and `flutter analyze` pass.
- History is local; remote synchronization and cost updates require a future backend.

---

# Stage 7A
# Resident Profile and Case Workflow Mock Screens

Status: **Done** (mock data only; no backend)

## Goal

Add mock resident-facing screens for the profile and for case workflow visibility. Data is static or locally seeded and must be clearly identified as sample data.

## 1. Resident Profile Screen

Sections:

### Tenant Details

- Full name
- Phone number
- Email
- Emirates ID (masked)

### Apartment Details

- Apartment number
- Tower number
- Floor
- Mock Dubai address (e.g., Tower 3, Dubai Marina, Dubai, UAE)

### Tenancy Details

- Tenancy start and end dates
- Annual rent and payment frequency
- Security deposit
- Tenancy status

### Contract Details

- Contract number
- Landlord / property manager
- Contract issue and expiry dates
- Renewal status

## 2. Case Workflow and Status

Once a complaint is raised, the tenant can open the case and view:

- Workflow timeline and current case status
- Technician details if assigned (name, specialty, phone, photo placeholder)
- Appointment date and time if scheduled

### Closed Case Mock Data

Each closed case shows:

- Raised date
- Approved by (manager name)
- Technician assigned and technician name
- Appointment date/time
- Fix date
- Closing comments

Provide at least two mock closed cases in different categories.

## Architecture

- Mock repositories under each feature's data layer behind domain interfaces, exposed through Riverpod providers, so they can be replaced by a real backend later.
- Reusable Material 3 widgets for info sections and timeline steps.
- English and Arabic strings for every label, with RTL support.
- Routes registered in GoRouter; the dashboard Profile action opens the profile screen.

## Definition Of Done

- Profile screen shows tenant, apartment, tenancy, and contract sections with mock Dubai data.
- Case detail shows workflow, status, and technician details when assigned.
- Closed cases show all fields listed above.
- Mock data is labeled as sample data.
- Widget tests and `flutter analyze` pass.

---

# Stage 8
# Move-Out Module

Status: **Done** (local submission and status display; reviewer-driven status changes need a backend)

## Goal

Manage move-out requests.

## Form Fields

- Move-Out Date
- Reason
- Contact Number
- Forwarding Address
- Notes

## Workflow

Submitted
→ Review
→ Inspection Scheduled
→ Inspection Completed
→ Approved
→ Closed

## APIs

POST /api/moveout

GET /api/moveout

GET /api/moveout/{id}

## Definition Of Done

- User submits move-out request
- User tracks progress

---

# PHASE 2: Operations, Notifications, and Deployment (Stages 9-12)

---

# Stage 9
# Shared Operations Backend and Administrator Tablet App

Status: **In Progress** (local tablet prototype exists; shared backend and production authentication remain on hold)

## Goal

Provide a shared source of truth for resident and technician workflows, and an administrator experience optimized for Android tablets. The administrator app is separate from the resident/technician phone app.

## Shared Backend Requirements

- Authenticate users and enforce resident, technician, and administrator roles on every protected operation.
- Provide shared records and APIs for campuses, buildings/towers, apartments, tenancy, residents, technicians, services, requests, assignments, appointments, status history, and move-out requests.
- Record who created or changed a request, assignment, appointment, or status and when.
- Synchronize technician updates to the resident and administrator apps.
- Send each technician appointment-change proposal to both the assigned administrator and tenant, and store their decisions separately. Change the scheduled time only after both approve.
- Review technician work rejections with reason; keep the tenant-facing status Pending / In Progress during review, then reassign or record another admin action.
- Store tenant accept/reject decisions for completed work. Require administrator approval after tenant acceptance before closing the work order.
- Accept or reject reopened work orders and resume accepted issues at the appropriate assignment stage.
- Record work-start and completion timestamps and calculate elapsed work time for history and technician billing.
- Enforce the tenant's 24-hour reopen period from the official work-order closure timestamp; require a reason and admin review for reopening.
- Select backend framework, hosting, database, and authentication provider before implementation. Do not assume the legacy Spring Boot/AWS proposal is approved.

## Administrator Tablet Module

### Property and Account Management

- Add, edit, search, and deactivate campuses, buildings/towers, and apartments/units.
- Add, edit, search, and deactivate resident/tenant records; associate each resident with an apartment and tenancy.
- Add, edit, search, and deactivate technicians; record specialty and availability.
- Create administrator accounts and assign roles and permissions.

### Request and Assignment Management

- Review and categorize incoming requests; approve, reject, or request more information.
- Assign and reassign technicians, set appointment date/time, and review proposed appointment changes.
- Approve or reject a technician's proposed appointment change. The existing appointment remains in effect until both administrator and tenant approve the new time.
- View request, assignment, appointment, status, and move-out history.
- Manage service categories and request status transitions.

## Definition Of Done

- Tablet layouts support the complete admin workflows and loading, empty, error, and confirmation states.
- Role-based access is enforced by the backend, not only hidden in the UI.
- Changes appear consistently in both apps and are covered by API and UI tests.
- Property records, assignments, appointment changes, and status transitions have auditable history.
- A proposed appointment change is not applied until both tenant and administrator approvals are recorded.

---

# Stage 10
# Technician Module in the Shared Phone App

Status: **In Progress** (local mock technician workflow implemented; shared backend and administrator approval depend on Stage 9)

## Goal

Add a technician role to the existing Android phone app, sharing its installation with the resident role while keeping authorization and navigation role-specific.

## Features

### Technician Authentication

- Sign in with a technician login ID.
- Prototype accepts `TECH-001` by ID only. This is demonstration access, not secure authentication; select production credentials and recovery policy before release.
- Route each authenticated account to its authorized resident or technician experience.

### Assigned Work

- List jobs assigned to the signed-in technician, with current status and appointment time.
- Open a job to view complaint details, apartment/building location, and relevant access notes.
- Accept or update work progress and view previous completed assignments.
- Propose an alternative appointment time to both the tenant and administrator when unable to attend; retain the existing appointment until both approve.

### Technician Work Status and Notification Workflow

Status: **Planned** (seeded workflow examples are visible; live transitions, notifications, and approvals are not implemented)

1. **Work Accepted:** notify the tenant with the technician's name and notify the administrator.
2. **Work Rejected:** require a reason and notify the administrator only. Keep the tenant-facing status Pending / In Progress while the administrator reviews and reassigns or takes another action.
3. **Travelling to Site:** notify the tenant with the technician's name and notify the administrator.
4. **Work Started:** notify the tenant and administrator.
5. **Work Blocked:** require a reason/details and notify the tenant and administrator. Resume after the technician or administrator resolves the blocker.
6. **Work Completed - Awaiting Confirmation:** record completion comments, completion timestamp, and time taken since Work Started for history/billing. Notify the tenant to accept/reject and notify the administrator that completion awaits review, including elapsed work time for history/billing. The administrator approves only after tenant acceptance; close only after both approvals. Tenant rejection returns the issue to an appropriate active status.
7. **Reopened:** the tenant may reopen a closed work order within 24 hours of official closure and must provide a reason. Confirm to the tenant and notify the administrator. Admin reviews and accepts the issue for further action; repeat technician assignment, completion, tenant acceptance, and admin approval as needed.

Every transition records timestamp and actor. Rejection, blocking, and reopening require reasons. Maintain complete status history for all authorized roles and send each specified notification to the relevant recipients.

## Confirmed Workflow Rules

- Both the administrator and tenant must approve an appointment-time proposal before it becomes the scheduled appointment.
- Technician completion does not close the work order. The tenant accepts or rejects; administrator approval follows tenant acceptance, and closure requires both approvals.
- The tenant may reopen a closed work order within 24 hours of official closure with a reason; admin must review and accept it for further action.
- Define which tenant contact and apartment details technicians may access.

The current prototype stores technician assignments and workflow actions locally. Tenant approval is available in the resident request view; the administrator approval step is not available while Stage 9 is on hold, so proposed appointment changes remain pending.
The detailed status and notification workflow above is planned and is not implemented by the local technician demo.

## Definition Of Done

- Technicians can access only their own assignments and permitted resident/location details.
- Assignment, appointment, progress, and completion changes persist through the shared backend and appear in the resident and admin views.
- Previous assignment history and proposed appointment decisions are visible to authorized roles.
- The proposed appointment changes only after both approvals; completed work is closed only after tenant acceptance and admin approval, and may be reopened by the tenant within 24 hours.
- Role, workflow, error, and meaningful UI behavior are tested.

---

# Stage 11
# Notification System

Status: **In Progress** (local sample notification center implemented; real push delivery is not implemented)

## Goal

Preview role-specific notifications for important events; later connect these events to the approved push provider and shared backend.

## Events

- Request Accepted
- Technician Assigned
- Appointment Scheduled
- Appointment Reminder
- Request Completed
- Move-Out Updates
- Appointment change proposed or approved/rejected
- Assignment accepted or completed by technician
- Work Accepted: notify tenant with technician name and notify administrator.
- Work Rejected: notify administrator with reason only; do not immediately notify tenant.
- Travelling to Site and Work Started: notify tenant and administrator.
- Work Blocked: notify tenant and administrator with reason/details.
- Work Completed - Awaiting Confirmation: notify tenant to accept/reject and notify administrator that review is pending.
- Tenant acceptance/rejection and administrator approval/closure: notify relevant parties.
- Tenant reopening within 24 hours: confirm to tenant and notify administrator.
- Notify both tenant and administrator when either party records an appointment proposal decision.

## Technology

Select a notification provider during backend design; no provider is configured in the current prototype.

## Definition Of Done

- Each Stage 10 event is delivered to the specified recipient(s) with the correct request, technician, status, and reason details.
- Rejection notifications go only to the administrator while the tenant-facing status remains Pending / In Progress during review.
- Push delivery failures and retries are handled and covered by notification tests.

---

# Stage 12
# Production Deployment

Status: **Planned** (hosting provider and production architecture require approval)

## Infrastructure

Applications

- Flutter Android phone app (resident and technician roles)
- Separate Flutter Android tablet app (administrator role)

Shared Backend

- To be selected; must expose secured APIs for both apps

Database

- To be selected; must store shared property, identity, request, assignment, appointment, and audit records

File Storage

- Select a provider as part of the approved backend and attachment design.

Authentication and Authorization

- To be selected; must enforce role-based access

Notifications

- Use the provider selected in Stage 11.

Monitoring

- Select monitoring and alerting services for the approved hosting environment.

## Definition Of Done

- Phone app, tablet app, and shared backend are deployed to approved environments.
- Release signing, secrets management, backup/restore, monitoring, and operational support are configured.
- End-to-end resident, technician, and administrator workflows pass acceptance tests.

---

# Future Enhancements

After Phase 2 delivery

- Online Payments
- Vendor Marketplace
- AI Complaint Classification
- Chat Support

Later enhancements

- ERP Integration
- CRM Integration
- Smart Maintenance Recommendations
- Predictive Maintenance Analytics

---

# Copilot Development Guidelines

## Coding Standards

- Follow Clean Architecture
- SOLID Principles
- REST API Standards
- OpenAPI Documentation

## Mobile Standards

- Flutter and Dart for Android apps
- Riverpod for state management
- GoRouter for navigation
- Keep administrator tablet app separate from the resident/technician phone app

## Backend Standards

- Select backend framework and persistence stack before implementation
- Secure APIs with role-based authorization and auditable status changes
- Document APIs and validate them with automated tests

## Testing

- Unit Tests
- Integration Tests
- API Tests

Minimum Coverage:

80%

---

# MVP Delivery Order

1. Resident authentication and dashboard
2. Resident service requests, tracking, and history
3. Approved attachment workflow
4. Resident move-out workflow
5. Shared backend, identity, and property data
6. Administrator tablet app
7. Technician role in the shared phone app
8. Notifications
9. Production deployment of both Android apps and the backend

Target MVP Duration

4-6 Weeks