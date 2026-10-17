# Apartment Service Management System
# Implementation Plan

---

# Project Development Strategy

The project will be built in multiple stages using an incremental delivery approach.

Each stage should deliver a fully functional and testable outcome.

Copilot should complete one stage before moving to the next.

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

Status: **Done** (local mock authentication)

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
- Widget tests and `flutter analyze` pass.

---

# Stage 3
# Resident Dashboard

Status: **Done** (resident navigation; future modules are marked as planned)

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
- Unimplemented module destinations are clearly identified as planned rather than functional.
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

# Stage 8
# Move-Out Module

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

# Stage 9
# Administrator Portal

## Goal

Provide operations management.

## Technology

React Web Application

## Features

### Resident Management

- Search Residents
- View Details

### Request Management

- View Requests
- Assign Requests
- Change Status

### Appointment Scheduling

- Create Appointment
- Reschedule Appointment

### Technician Management

- Create Technician
- Update Technician
- Assign Technician

## Definition Of Done

- Admin manages entire workflow

---

# Stage 10
# Technician Portal

## Goal

Provide technician workspace.

## Features

- View Assigned Tasks
- Accept Job
- Update Status
- Add Notes
- Upload Completion Photos

## Definition Of Done

- Technician can complete jobs

---

# Stage 11
# Notification System

## Goal

Notify users about important events.

## Events

- Request Accepted
- Technician Assigned
- Appointment Scheduled
- Appointment Reminder
- Request Completed
- Move-Out Updates

## Technology

Firebase Cloud Messaging

## Definition Of Done

- Push notifications received successfully

---

# Stage 12
# AWS Production Deployment

## Infrastructure

Frontend

- React Native Mobile App

Backend

- AWS ECS or EKS

Database

- Amazon RDS PostgreSQL

Storage

- Amazon S3

Authentication

- AWS Cognito

Notifications

- Firebase Cloud Messaging

Monitoring

- CloudWatch
- Prometheus
- Grafana

## Definition Of Done

- Production deployment successful

---

# Future Enhancements

Phase 2

- Online Payments
- Vendor Marketplace
- Multi-Language Support
- AI Complaint Classification
- Chat Support

Phase 3

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

- React Native Functional Components
- React Query
- Redux Toolkit

## Backend Standards

- Spring Boot 3+
- JPA
- Liquibase
- JWT Security

## Testing

- Unit Tests
- Integration Tests
- API Tests

Minimum Coverage:

80%

---

# MVP Delivery Order

1. Authentication
2. Dashboard
3. Service Request
4. Image Upload
5. Tracking
6. History
7. Move-Out
8. Admin Portal
9. Notifications
10. Production Deployment

Target MVP Duration

4-6 Weeks