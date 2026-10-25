# Fix-it Technical Architecture (Proposed)

Status: **Proposed.** Nothing below is implemented. The resident/technician phone app and the admin tablet app currently use local mock data and do not connect to AWS.

## Overview

```mermaid
flowchart LR
    subgraph Clients["Android apps"]
        R["Resident / Technician app<br/>(phone)"]
        A["Admin app<br/>(tablet)"]
    end

    subgraph AWS["AWS Cloud"]
        APIGW["API Gateway<br/>(REST, HTTPS)"]
        AUTH["Authorizer<br/>(Cognito or Lambda authorizer)"]

        subgraph Compute["AWS Lambda"]
            L1["Requests / work orders"]
            L2["Properties, tenants, technicians"]
            L3["Appointments and approvals"]
            L4["Notifications / reports"]
        end

        DDB[("DynamoDB<br/>requests, assignments, appointments,<br/>status events, tenants, properties")]
        SNS["SNS topics<br/>(status and notification events)"]
        PUSH["Push channel<br/>(SNS mobile push / FCM)"]
        S3[("S3<br/>photos, agreement files")]
        CW["CloudWatch<br/>logs and alarms"]
    end

    R -->|HTTPS + token| APIGW
    A -->|HTTPS + token| APIGW
    APIGW --> AUTH
    AUTH --> APIGW
    APIGW --> L1 & L2 & L3 & L4

    L1 & L2 & L3 & L4 <--> DDB
    L1 -.->|pre-signed upload URL| S3
    L1 & L3 -->|publish status events| SNS
    SNS -->|fan-out| L4
    SNS --> PUSH
    PUSH -->|tenant / technician alerts| R
    PUSH -->|admin alerts| A
    Compute --> CW
```

Request flow: resident or technician app -> API Gateway -> Lambda -> DynamoDB -> SNS -> admin app. The admin app uses the same API.

## Design Decisions to Confirm

- **Authorization:** API Gateway needs an authorizer (for example Cognito groups for resident, technician, and admin). Each Lambda must enforce role and ownership; hiding screens in the apps is not security.
- **Notification delivery:** SNS publishes and fans out events. Reaching phones requires SNS mobile push (FCM for Android) or API polling. Provider choice is undecided.
- **Admin-only events:** a technician rejection goes only to the admin topic or subscription; the tenant keeps the Pending / In Progress status.
- **Files:** photos and agreement files go to S3 through pre-signed URLs. DynamoDB stores only the file reference.
- **DynamoDB:** status events and notification attempts are append-only items so history is never overwritten.

## Related Documents

- `docs/admin_doc/admin_data_contract.md` for the backend-neutral entity model.
- `docs/admin_doc/admin_implementation_plan.md` for admin stage status (A3 backend is on hold).
