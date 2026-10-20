# Administrator Tablet UI Guidelines

## Scope

These guidelines apply to the planned, separate Android tablet application for administrators. They do not replace the phone-app UI or the existing general project guidance. The current IPTV-oriented `docs/UI_GUIDLINES.md` examples are unrelated to Fix-it; use Material 3 and the requirements here instead.

## Tablet Layout

- Design for landscape and portrait tablet orientations, with usable layouts on smaller Android tablets.
- Use a navigation rail or persistent side navigation for primary modules: Dashboard, Requests, Properties, Residents, Technicians, and Reports (when reporting is approved).
- Prefer a queue/list plus detail workspace for requests and assignment review. Keep the selected request context visible while inspecting or assigning work.
- Use responsive tables or structured lists for large record sets. On narrow widths, collapse columns into readable record rows rather than clipping data.
- Keep filters and search easy to reach; show active filters and provide a clear/reset action.

## Forms and Data Management

- Group fields by task: identity/contact, property hierarchy, tenancy, roles/permissions, request/assignment, appointment.
- Mark required fields and explain validation beside the relevant input.
- Use searchable selectors for campus, building, apartment, technician, and role when lists are large.
- Confirm destructive or high-impact actions such as deactivation, rejection, reassignment, appointment decisions, and closure approval.
- Display relevant audit context (actor, date/time, previous/current status) in record details.

## Workflow Presentation

- Show work status as text with clear timestamps; do not rely on color alone.
- For technician appointment proposals, show the existing appointment, proposed time, and separate tenant/admin decisions. Make clear the new time is pending until both approve.
- For technician rejection, present the reason and admin next actions; do not imply the tenant has been notified when policy says otherwise.
- For completion, show technician comments and elapsed work time, then collect tenant acceptance and admin approval separately before closure.
- For reopening, show the official close time, remaining 24-hour eligibility, tenant reason, and admin review action.
- Make notification recipient and delivery state explicit in previews and logs.

## Components and States

- Use Material 3 components and consistent spacing, typography, and color roles.
- Support loading, empty, error, success, offline, permission-denied, validation, and confirmation states.
- Use dialogs or bottom sheets for focused decisions, not as substitutes for full data-management screens.
- Avoid unbounded nested scrolling; keep dense work queues usable with stable row heights and clear selection affordances.

## Accessibility

- Minimum touch target: 48 x 48 dp.
- Support system text scaling, screen readers, keyboard navigation, and visible focus.
- Maintain accessible contrast; communicate status with labels/icons as well as color.
- Respect locale direction, including RTL layout for Arabic if the admin app supports localization.

## Responsive Acceptance Checks

- Test representative small and large tablet sizes, landscape and portrait.
- Verify long names, apartment identifiers, request numbers, Arabic labels, and validation messages do not overflow or overlap.
- Verify assignment, rejection, dual-approval, completion, closure, and reopening dialogs/flows are usable at tablet size.
