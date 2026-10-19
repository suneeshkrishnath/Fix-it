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
- Record completion date and closing comments.
- Mark work completed; the tenant, not the technician, closes the request after confirming the work.

## Administrator Module (Separate Tablet App)

- Sign in with an administrator account and role-based permissions.
- Manage campuses, buildings/towers, apartments/units, residents/tenants, and tenancy records.
- Manage technician accounts, specialties, availability, roles, and permissions.
- Review and categorize requests; approve, reject, or request more information.
- Assign/reassign technicians, schedule appointments, and review appointment proposals.
- Approve or reject each technician appointment proposal; a proposed time is not confirmed until both administrator and tenant approve it.
- Manage move-out requests and review operational history.

## Shared Workflow and Access Control

Resident submits request -> administrator reviews and assigns technician -> technician attends at the scheduled location/time and records progress -> if needed, technician proposes a new time to both tenant and administrator -> the time changes only after both approve -> technician records completion/comments -> tenant confirms the work and closes the request -> tenant may reopen it within 24 hours after closure.

Synchronize requests, assignments, appointment changes, and status transitions through the backend. Enforce access permissions at the backend/API, not only in app navigation.

## Decisions Required Before Implementation

- Technician login credential and account recovery method.
- Which resident contact and apartment details technicians may access.

---

# User Types

## Resident

Can raise requests, follow their own requests, approve or reject appointment proposals, close a request after work is complete, reopen it within 24 hours of closure, review history, and submit move-out requests.

## Technician

Can:

- Sign in to the technician role in the shared phone app
- View assigned tasks, request location, and scheduled time
- Update task progress and view previous assignment history
- Propose an alternative appointment time
- Complete assigned service requests with closing comments

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
- Status Updates

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
6. Work Completed (awaiting tenant confirmation)
7. Closed by Tenant
8. Reopened by Tenant within 24 hours of closure

Optional:

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

- Resident/technician phone app: Flutter and Dart for Android. The resident prototype exists; technician mode is planned.
- Administrator: separate Flutter Android tablet app, planned.
- Shared backend: required for identity, permissions, property records, requests, assignments, appointments, and audit history. Select framework, hosting, and API design before implementation.
- Database and file storage: select with the backend. The current prototype uses Hive locally and does not upload files.
- Authentication: current resident sign-in uses mock OTP; production provider and technician/admin credential and recovery policies remain undecided.
- Notifications: select a provider during backend and production design.

---

# Planned MVP Scope and Current Prototype

Planned product scope includes resident authentication and service workflows, technician assignment/workflows in the shared phone app, administrator property/account/request management in the tablet app, and move-out tracking. Photo attachments remain deferred pending approval of selection and storage behavior.

The current repository is an Android Flutter resident prototype. It has mock OTP authentication, local service request creation/tracking/history, and dashboard placeholders for Profile and Move-out. Technician mode, the administrator tablet app, shared backend, live status updates, and photo upload are not implemented.

Future enhancements include online payments, chat, AI classification, a vendor marketplace, and ERP integration.