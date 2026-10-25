# Fix-it Shared Operations Data Contract

Status: **Planned** (backend-neutral domain contract; no API or database is implemented)

This contract is intended to be shared by the resident/technician phone app and the administrator tablet app. The local prototypes may seed equivalent sample data, but local Hive data is not a shared source of truth.

## Entity Relationships

```text
Campus 1 -> many Buildings/Towers
Building/Tower 1 -> many Apartments/Units
Apartment 1 -> many Tenancies over time
Tenant 1 -> many Tenancies and Work Orders
Technician 1 -> many Assignments
Work Order 1 -> many Assignments, Appointments, Status Events, and Notifications
```

## Core Records

### Campus

- `id`, `name`, `status`, `createdAt`, `updatedAt`, `updatedBy`

### Building/Tower

- `id`, `campusId`, `nameOrNumber`, `address`, `status`, `createdAt`, `updatedAt`, `updatedBy`

### Apartment/Unit

- `id`, `buildingId`, `unitNumber`, `floor`, `status`, `createdAt`, `updatedAt`, `updatedBy`
- Unique within its building; keep referenced units when tenancy or work history exists.

### Tenant and Tenancy

- Tenant: `id`, `fullName`, `phone`, `email`, protected identity fields, `status`, audit fields.
- Tenancy: `id`, `tenantId`, `apartmentId`, `startDate`, `endDate`, `status`, contract/document references, audit fields.
- Tenant creation selects a valid apartment from the campus/building/unit hierarchy.

### Technician and Role

- Technician: `id`, `loginId`, `displayName`, `specialty`, `availability`, `status`, audit fields.
- Role/permission assignments are explicit records or claims; exact role hierarchy and authentication provider remain undecided.

### Work Order

- `id`, `requestNumber`, `tenantId`, `apartmentId`, `category`, `subcategory`, `description`, `priority`, `currentStatus`, `createdAt`, `updatedAt`, `updatedBy`.
- Keep current state separate from the append-only status history.

### Assignment and Work Timing

- Assignment: `id`, `workOrderId`, `technicianId`, `assignedAt`, `assignedBy`, `acceptanceStatus`, `rejectionReason`.
- Work events include `travellingAt`, `workStartedAt`, `blockedAt`, `blockReason`, `resumedAt`, `workCompletedAt`, `completionComments`, and elapsed minutes.
- Elapsed minutes are derived from the agreed start/completion events; adjustments must be auditable.

### Appointment and Proposal

- Appointment: `id`, `workOrderId`, `scheduledAt`, `status`, audit fields.
- Proposal: `id`, `workOrderId`, `proposedAt`, `proposedBy`, `reason`, separate tenant/admin decisions, decision timestamps, and decision actors.
- Update the scheduled appointment only after both tenant and administrator approve the same proposal.

### Completion Approval and Reopening

- Completion decisions store tenant decision/reason/time and administrator decision/reason/time independently.
- Set `closedAt` only after tenant acceptance and administrator approval.
- Reopen eligibility ends 24 hours after official `closedAt`; reopening requires a tenant reason and an administrator review/accept action.

### Status Event and Notification Event

- Status event: `id`, `workOrderId`, `fromStatus`, `toStatus`, `actorId`, `actorRole`, `occurredAt`, `reason`, `metadata`.
- Notification event: `id`, `workOrderId`, `recipientId`, `recipientRole`, `eventType`, `payload`, `createdAt`, `deliveryStatus`, `attemptCount`, `lastAttemptAt`.
- Persist every status change and notification attempt; do not overwrite prior events.

## Invariants

- Backend authorization is authoritative; UI visibility is not a security boundary.
- Residents access only their own tenant, tenancy, apartment, and work orders.
- Technicians access only assigned work orders and the minimum property/contact data needed to perform them.
- Administrators access only records allowed by their assigned permissions.
- Appointment proposals require tenant and administrator approval before changing the appointment.
- Technician rejection is visible to administrators with a required reason; the tenant-facing state remains Pending / In Progress until admin action.
- Completion is not closure: tenant accepts first, then administrator approves; both are required to close.
- Rejection, blocking, and reopening require reasons. Every transition has an actor and timestamp.

## Decisions Still Required

- Backend framework, database, hosting, API style, authentication provider, and notification provider.
- Technician/admin credential and account-recovery policies.
- Appointment-proposal expiry and rejection/timeout policy.
- Elapsed-work-time rounding, edits, and billing approval policy.
- Document-storage provider, retention policy, and allowed contract formats/size.