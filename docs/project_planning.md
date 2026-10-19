# Apartment Service Management System (ASMS)

## Project Vision

Apartment Service Management System (ASMS) is a mobile-first platform that enables residents to request maintenance services, track progress, manage complaints, and submit move-out requests. Residents and technicians use role-specific modules in one Android phone app; administrators use a separate Android tablet app.

The system aims to replace phone calls, WhatsApp messages, emails, and manual processes with a structured workflow-driven service management platform.

---

# Application Modules and Packaging

The product has three role-based modules across two Android apps:

1. **Resident module:** resident experience in the phone app.
2. **Technician module:** technician experience in the same phone app, after technician sign-in.
3. **Administrator module:** a separate, tablet-optimized Android app.

Both apps require a shared backend for identity, property records, requests, assignments, appointments, status changes, and audit history. Backend framework, hosting, database, authentication provider, and API design are undecided. The legacy React Native and Spring Boot proposal is not an approved technology decision.

## Resident Module

- Sign in with phone number and apartment details using OTP.
- View resident, tenancy, and apartment information.
- Raise service requests with category, service type, description, priority, preferred time, and attachments when approved.
- View request status, assigned technician, and confirmed appointment information.
- Approve or reject an appointment-time proposal from the technician.
- Review service history and submit/track move-out requests.
- Access only the resident's own profile, apartment, and requests.

## Technician Module (Shared Phone App)

- Sign in with a technician login ID and an authentication/recovery policy to be confirmed.
- View only jobs assigned to the signed-in technician.
- Review request details, apartment/building location, access notes, and scheduled time.
- Accept or update work, review previous assignments, and record progress.
- Propose an alternative appointment time when unable to attend.
- Send the same appointment proposal to both the administrator and tenant; the proposed time takes effect only after both approve.

### Technician Work Status and Notification Workflow (Planned)

1. **Accept work**
	- Status: Work Accepted.
	- Notify the tenant with the technician's name and notify the administrator.
2. **Reject work**
	- Status: Work Rejected internally; require a rejection reason.
	- Notify the administrator with the reason. Do not immediately notify the tenant; keep the tenant-facing status Pending / In Progress while the administrator reviews and arranges reassignment or another action.
3. **Travel to site**
	- Status: Travelling to Site.
	- Notify the tenant with the technician's name and notify the administrator.
4. **Start work**
	- Status: Work Started.
	- Notify the tenant and administrator.
5. **Block or pause work**
	- Status: Work Blocked; require a reason and relevant details.
	- Notify the tenant with the reason/details and notify the administrator. Work resumes after the technician or administrator resolves the blocker.
6. **Complete work**
	- Status: Work Completed - Awaiting Confirmation.
	- Record completion comments, completion timestamp, and time taken from Work Started to completion for history and technician billing.
	- Notify the tenant to accept or reject the work; notify the administrator that completion awaits confirmation and include elapsed work time for history/billing.
	- Close the work order only after the tenant accepts and the administrator approves. Tenant rejection returns it to an appropriate active status.
7. **Reopen after closure**
	- The tenant may reopen a closed work order within 24 hours of official closure and must provide a reason.
	- Status: Reopened. Confirm to the tenant and notify the administrator for review and acceptance.
	- After admin acceptance, resume at the appropriate stage, including assignment/technician acceptance as needed. Repeat completion and both approvals after the work is resolved again.

Record each status transition with timestamp and actor. Rejection, blocking, and reopening require reasons. Keep complete status history for tenant, technician, and administrator, and send each specified notification to its intended recipients.

## Administrator Module (Separate Tablet App)

- Sign in with an administrator account and role-based permissions.
- Manage campuses, buildings/towers, apartments/units, residents/tenants, and tenancy records.
- Manage technician accounts, specialties, availability, roles, and permissions.
- Review and categorize requests; approve, reject, or request more information.
- Assign/reassign technicians, schedule appointments, and review appointment proposals.
- Approve or reject each technician appointment proposal; a proposed time is not confirmed until both administrator and tenant approve it.
- Manage move-out requests and review operational history.

## Shared Workflow and Access Control

Resident submits request -> administrator reviews and assigns technician -> technician accepts and attends at the scheduled location/time -> technician records travel, start, blocked, and completion updates -> if needed, technician proposes a new time to both tenant and administrator -> the time changes only after both approve -> tenant accepts completed work -> administrator approves completion and closes the work order -> tenant may reopen it within 24 hours after closure.

Synchronize requests, assignments, appointment changes, and status transitions through the backend. Enforce access permissions at the backend/API, not only in app navigation.

## Decisions Required Before Implementation

- Technician login credential and account recovery method.
- Which resident contact and apartment details technicians may access.

---

# User Types

## Resident

Can raise requests, follow their own requests, approve or reject appointment proposals, accept or reject completed work, reopen a closed work order within 24 hours with a reason, review history, and submit move-out requests. A work order closes only after tenant acceptance and administrator approval.

## Technician

Can:

- Sign in to the technician role in the shared phone app
- View assigned tasks, request location, and scheduled time
- Update task progress and view previous assignment history
- Propose an alternative appointment time
- Report travel, work start, and blocking reasons
- Complete assigned service requests with comments and time-taken records
- Receive no immediate tenant notification for rejection; send the reason to the administrator for review

---

## Administrator

Can:

- Use the separate tablet app
- Manage campuses, buildings/towers, and apartments
- Manage residents/tenants, technicians, roles, and permissions
- Review and assign requests, schedule or adjust appointments, and manage request status
- Review move-out requests and operational history
- Generate reports

---

# Authentication

Authentication is role-specific and must resolve the signed-in user's role before opening a module.

## Resident Login

- Phone Number
- Apartment Number
- OTP Verification

Example:

Phone Number: +48 500000000
Apartment Number: A-302

## Technician Login

- Technician login ID.
- Credential, verification, and recovery method to be decided before implementation.

## Administrator Login

- Administrator account in the separate tablet app.
- Authentication and recovery method to be decided before implementation.

## Authorization

- Enforce role-based access in the shared backend and API, not only in app navigation.
- Residents may access only their own profile, apartment, and requests.
- Technicians may access only their assignments and the resident/property details needed to perform them.
- Administrators may access operational records permitted by their assigned role.

---

## User Discovery

After successful resident authentication, the system shall retrieve:

- Resident Name
- Tenant Information
- Owner Information
- Apartment Information
- Building Information
- Contact Details

Initially this information will be mocked.

Future integrations:

- Apartment ERP
- CRM
- Property Management System
- Resident Database

---

# Core Modules

## 1. Authentication Module

Features:

- Login
- OTP Verification
- Session Management
- User Profile Loading

---

## 2. Service Request Module

Features:

- Category Selection
- Subcategory Selection
- Complaint Submission
- Service Tracking

---

## 3. Service History Module

Features:

- Previous Requests
- Status History
- Assigned Technician
- Cost Tracking

---

## 4. Move-Out Module

Features:

- Move-Out Request Creation
- Status Tracking
- Inspection Scheduling

---

## 5. Notification Module

Features:

- Push Notifications
- Appointment Alerts
- Notifications for work acceptance, travel, start, blocked work, completion, tenant decisions, admin approval, closure, and reopening
- Rejection notifications to the administrator only while the tenant-facing status remains Pending / In Progress
- Notifications to tenant and administrator for each specified state change

---

# Service Classification

## Free Services

Covered under apartment maintenance agreements.

Examples:

### Plumbing

- Water leakage
- Drain blockage
- Pipe maintenance
- Water pressure issues

### Electrical

- Common area lighting
- Electrical faults
- Switch maintenance

### General Maintenance

- Door repairs
- Window maintenance

### Cleaning

- Corridor cleaning
- Common area cleanliness

---

## Paid Services

Additional resident-requested services.

Examples:

### Installation

- Air Conditioner Installation
- Refrigerator Installation
- Washing Machine Installation

### Electrical Enhancements

- Additional sockets
- Custom wiring

### Home Services

- Furniture Assembly
- Painting
- Minor Renovation

---

# Complaint Workflow

Resident selects:

Service Category
→ Service Type
→ Complaint Details
→ Upload Photos
→ Submit

---

# Complaint Form Fields

## Required

- Category
- Subcategory
- Description

## Optional

- Priority
- Preferred Visit Time
- Additional Notes

## Attachments

- Photo Upload
- Camera Support
- Gallery Selection

Supported Formats:

- JPG
- PNG
- HEIC

Limits:

- Maximum 5 Images
- Maximum 10 MB per image

---

# Request Status Workflow

1. Submitted
2. Accepted
3. Assigned
4. Appointment Scheduled
5. In Progress
6. Work Accepted
7. Travelling to Site
8. Work Started
9. Work Blocked (reason required; can resume)
10. Work Completed - Awaiting Confirmation
11. Closed (tenant acceptance and administrator approval)
12. Reopened by Tenant within 24 hours of closure

Optional:

- Work Rejected (internal; admin review and reassignment/action required)
- Rejected
- Cancelled

---

# Move-Out Workflow

Submitted
→ Under Review
→ Inspection Scheduled
→ Inspection Completed
→ Approved
→ Closed

---

# Mobile Application Screens

## Authentication

- Splash Screen
- Login Screen
- OTP Verification

## Resident Dashboard

- Create Request
- My Requests
- History
- Move Out
- Profile

## Service Requests

- Category Selection
- Complaint Form
- Request Details

## Tracking

- Timeline Status View
- Technician Details
- Appointment View

## Move-Out

- Request Form
- Status Tracking

## Profile

- Resident Information
- Apartment Information

## Technician Module (Same Phone App)

- Technician sign-in and assigned-work list
- Job details with location and appointment time
- Appointment change proposal
- Work status, completion, comments, and assignment history

## Administrator Module (Separate Tablet App)

- Campus, building/tower, apartment, resident, and tenancy management
- Technician accounts, roles, and permissions
- Request review, assignment, appointment scheduling, and status history
- Move-out review and operational history

---

# Language Support

- Let residents choose English or Arabic on the sign-in screen before authentication.
- Apply the selected language throughout the resident app and remember it on the device.
- Use right-to-left layout when Arabic is selected.
- Keep English as the default for new installations.

---

# Non-Functional Requirements

## Performance

- API response time under 2 seconds
- App startup below 3 seconds

## Availability

- 99.9% uptime target

## Security

- Role-appropriate authentication for residents, technicians, and administrators.
- Secure APIs with server-enforced role-based access control.
- HTTPS for all network traffic.

## Scalability

- Support multiple campuses, buildings, and properties.

---

# Technology Direction

- Resident/technician phone app: Flutter and Dart for Android. Resident workflows and a local mock technician mode exist; secure authentication and shared technician workflows are planned.
- Administrator: separate Flutter Android tablet app, planned.
- Shared backend: required for identity, permissions, property records, requests, assignments, appointments, and audit history. Select framework, hosting, and API design before implementation.
- Database and file storage: select with the backend. The current prototype uses Hive locally and does not upload files.
- Authentication: current resident sign-in uses mock OTP; production provider and technician/admin credential and recovery policies remain undecided.
- Notifications: select a provider during backend and production design.

---

# Planned MVP Scope and Current Prototype

Planned product scope includes resident authentication and service workflows, technician assignment/workflows in the shared phone app, administrator property/account/request management in the tablet app, and move-out tracking. Photo attachments remain deferred pending approval of selection and storage behavior.

The current repository is an Android Flutter prototype with mock resident OTP authentication, local service request creation/tracking/history, a mock profile, local move-out submission/tracking, and a local mock technician role with sample assignments and job actions. The administrator tablet app, shared backend, live synchronization, and photo upload are not implemented. Technician sign-in accepts the demo ID `TECH-001` only and is not production authentication. Appointment proposals remain pending because administrator approval is not available. Resident-facing labels support English and Arabic, selected before sign-in; Arabic uses right-to-left layout.

Future enhancements include online payments, chat, AI classification, a vendor marketplace, and ERP integration.
