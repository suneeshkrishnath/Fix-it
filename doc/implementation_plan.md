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

## Goal

Establish project structure and baseline architecture.

## Deliverables

### Mobile Application

Create React Native project structure.

Folders:

src/
├── screens
├── components
├── navigation
├── services
├── api
├── hooks
├── store
├── assets
├── models
└── utils

### Backend

Create Spring Boot project.

Packages:

com.apartment.auth
com.apartment.resident
com.apartment.request
com.apartment.moveout
com.apartment.technician
com.apartment.notification

### Database

Create database schema.

Tables:

- residents
- apartments
- service_requests
- attachments
- technicians
- appointments
- move_out_requests

## Definition Of Done

- Mobile project runs
- Backend starts
- Database connection works

---

# Stage 2
# Authentication Module

## Goal

Implement login and mock OTP verification.

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

Store residents in database.

System validates:

Phone Number + Apartment Number

Then generates mock OTP.

Example OTP:

123456

## API Endpoints

POST /api/auth/send-otp

POST /api/auth/verify-otp

GET /api/auth/profile

## Definition Of Done

- User login successful
- Profile loaded successfully

---

# Stage 3
# Resident Dashboard

## Goal

Create main application dashboard.

## Features

Cards:

- Create Service Request
- My Requests
- History
- Move Out Request
- Profile

## Definition Of Done

- Dashboard navigation operational

---

# Stage 4
# Service Request Module

## Goal

Allow residents to create complaints.

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

### Attachment Support

Upload Images

Maximum:

- 5 Images

## API

POST /api/requests

GET /api/requests

GET /api/requests/{id}

## Definition Of Done

- Complaint submission successful

---

# Stage 5
# File Upload Module

## Goal

Store complaint images.

## Implementation

Upload files to:

AWS S3

Store metadata inside:

attachments table

## API

POST /api/attachments

DELETE /api/attachments/{id}

## Definition Of Done

- Images uploaded successfully
- Images linked to requests

---

# Stage 6
# Request Tracking Module

## Goal

Track complaint lifecycle.

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

- User can view status in real time

---

# Stage 7
# Service History Module

## Goal

Allow users to see historical requests.

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

- Historical information accessible

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