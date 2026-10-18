# Apartment Service Management System (ASMS)

## Project Vision

Apartment Service Management System (ASMS) is a mobile-first platform that enables apartment residents, tenants, and owners to request maintenance services, track progress, manage complaints, and submit move-out requests through a single application.

The system aims to replace phone calls, WhatsApp messages, emails, and manual processes with a structured workflow-driven service management platform.

---

# Business Goals

## Resident Experience

Provide a simple and transparent way for residents to:

- Report maintenance issues
- Request paid services
- Track request progress
- View technician information
- Review service history
- Submit move-out requests

## Operational Efficiency

Provide apartment administrators with:

- Centralized complaint management
- Technician assignment workflows
- Service tracking
- Audit history
- Service reporting

## Future Vision

The platform should eventually support:

- Payments
- Vendor Management
- AI-based issue categorization
- Property ERP integration
- Resident communication

---

# User Types

## Resident

Can:

- Login using phone number and apartment information
- Create service requests
- Upload photos
- Track request status
- View history
- Submit move-out requests

---

## Technician

Can:

- View assigned tasks
- Update task progress
- Schedule appointments
- Complete service requests
- Add service notes

---

## Administrator

Can:

- Manage residents
- Manage technicians
- Configure services
- Assign technicians
- Schedule appointments
- Review move-out requests
- Generate reports

---

# Authentication

## Login Method

Authentication will be based on:

- Phone Number
- Apartment Number
- OTP Verification

Example:

Phone Number: +48 500000000
Apartment Number: A-302

---

## User Discovery

After successful authentication the system shall retrieve:

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
6. Completed

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

- OTP Authentication
- Secure APIs
- Role-Based Access Control
- HTTPS Only

## Scalability

Design for multi-property support in future.

---

# Technology Stack

## Mobile Application

React Native

Reason:

- Android Support
- iOS Support
- Single Codebase
- Copilot Friendly

---

## Backend

Spring Boot

Reason:

- Enterprise Ready
- Easy Integration
- Strong Security Ecosystem

---

## Database

PostgreSQL

---

## Storage

AWS S3

Used For:

- Complaint Images
- Documents

---

## Authentication

Phase 1:

- Mock OTP Service

Phase 2:

- AWS Cognito

---

## Notifications

Firebase Cloud Messaging (FCM)

---

# MVP Scope

Included

✅ OTP Login

✅ Resident Profile

✅ Complaint Creation

✅ Photo Upload

✅ Service Tracking

✅ Service History

✅ Move-Out Request

Not Included

❌ Online Payments

❌ Chat

❌ AI Classification

❌ Vendor Marketplace
