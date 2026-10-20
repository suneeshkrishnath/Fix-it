// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Fix-it';

  @override
  String get residentSignIn => 'Resident sign in';

  @override
  String get welcomeToFixIt => 'Welcome to Fix-it';

  @override
  String get signInPrompt => 'Sign in with your resident details.';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get apartmentNumber => 'Apartment number';

  @override
  String get sendVerificationCode => 'Send verification code';

  @override
  String get enterPhoneNumber => 'Enter your phone number.';

  @override
  String get enterApartmentNumber => 'Enter your apartment number.';

  @override
  String get residentDetailsNotRecognized =>
      'Resident details were not recognized.';

  @override
  String otpRequestFailed(String error) {
    return 'Could not request a verification code: $error';
  }

  @override
  String prototypeResident(String phone, String apartment) {
    return 'Prototype resident: $phone, apartment $apartment';
  }

  @override
  String get verifyPhoneNumber => 'Verify phone number';

  @override
  String get enterVerificationCode => 'Enter your verification code';

  @override
  String get mockCodeExplanation => 'The prototype uses a fixed mock code.';

  @override
  String get prototypeCode => 'Prototype code: 123456';

  @override
  String get verificationCode => 'Verification code';

  @override
  String get verifyAndContinue => 'Verify and continue';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get incorrectVerificationCode => 'The verification code is incorrect.';

  @override
  String otpVerificationFailed(String error) {
    return 'Could not verify the code: $error';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String welcomeResident(String name) {
    return 'Welcome, $name';
  }

  @override
  String apartmentValue(String number) {
    return 'Apartment $number';
  }

  @override
  String get serviceRequests => 'Service requests';

  @override
  String get createServiceRequest => 'Create service request';

  @override
  String get reportMaintenanceIssue => 'Report a maintenance issue';

  @override
  String get myRequests => 'My requests';

  @override
  String get trackOpenRequests => 'Track open requests';

  @override
  String get serviceHistory => 'Service history';

  @override
  String get reviewCompletedServices => 'Review completed services';

  @override
  String get apartmentSection => 'Apartment';

  @override
  String get moveOutRequest => 'Move-out request';

  @override
  String get startMoveOutRequest => 'Start a move-out request';

  @override
  String get residentProfile => 'Resident profile';

  @override
  String get viewResidentDetails => 'View resident details';

  @override
  String get createRequestPlanned =>
      'Service request creation is planned for a later stage.';

  @override
  String get requestTrackingPlanned =>
      'Request tracking is planned for a later stage.';

  @override
  String get historyPlanned => 'Service history is planned for a later stage.';

  @override
  String get moveOutPlanned =>
      'Move-out requests are planned for a later stage.';

  @override
  String get profilePlanned =>
      'Resident profile details are planned for a later stage.';

  @override
  String get serviceCategory => 'Service category';

  @override
  String get serviceType => 'Service type';

  @override
  String get describeIssue => 'Describe the issue';

  @override
  String get descriptionRequired => 'Add a description of the issue.';

  @override
  String get priority => 'Priority';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityHigh => 'High';

  @override
  String get choosePreferredVisit => 'Choose preferred visit time (optional)';

  @override
  String preferredVisit(String date, String time) {
    return 'Preferred: $date $time';
  }

  @override
  String get submitRequest => 'Submit request';

  @override
  String get requestSubmitted => 'Request submitted';

  @override
  String requestNumberSubmitted(String requestNumber) {
    return 'Request $requestNumber submitted';
  }

  @override
  String get returnToDashboard => 'Return to dashboard';

  @override
  String get plumbing => 'Plumbing';

  @override
  String get electrical => 'Electrical';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get cleaning => 'Cleaning';

  @override
  String get installation => 'Installation';

  @override
  String get homeServices => 'Home Services';

  @override
  String get electricalUpgrade => 'Electrical Upgrade';

  @override
  String get waterLeakage => 'Water leakage';

  @override
  String get drainBlockage => 'Drain blockage';

  @override
  String get pipeMaintenance => 'Pipe maintenance';

  @override
  String get waterPressureIssue => 'Water pressure issue';

  @override
  String get commonAreaLighting => 'Common area lighting';

  @override
  String get electricalFault => 'Electrical fault';

  @override
  String get switchMaintenance => 'Switch maintenance';

  @override
  String get doorRepair => 'Door repair';

  @override
  String get windowMaintenance => 'Window maintenance';

  @override
  String get corridorCleaning => 'Corridor cleaning';

  @override
  String get commonAreaCleanliness => 'Common area cleanliness';

  @override
  String get airConditionerInstallation => 'Air conditioner installation';

  @override
  String get refrigeratorInstallation => 'Refrigerator installation';

  @override
  String get washingMachineInstallation => 'Washing machine installation';

  @override
  String get furnitureAssembly => 'Furniture assembly';

  @override
  String get painting => 'Painting';

  @override
  String get minorRenovation => 'Minor renovation';

  @override
  String get additionalSockets => 'Additional sockets';

  @override
  String get customWiring => 'Custom wiring';

  @override
  String get additionalServices => 'Additional Services';

  @override
  String get housemaid => 'Housemaid';

  @override
  String get babysitter => 'Babysitter';

  @override
  String get proxyDriver => 'Proxy driver';

  @override
  String get deepCleaning => 'Deep cleaning';

  @override
  String get sampleDataNotice => 'Sample data for prototype purposes.';

  @override
  String get statusAwaitingTenantConfirmation => 'Awaiting tenant confirmation';

  @override
  String get statusClosedByTenant => 'Closed by tenant';

  @override
  String get statusReopened => 'Reopened';

  @override
  String get technicianSignIn => 'Technician sign in';

  @override
  String get technicianWorkspace => 'Technician workspace';

  @override
  String get technicianPrototypeAuthNotice =>
      'Prototype access uses a technician ID only. This is not secure authentication.';

  @override
  String get technicianLoginId => 'Technician login ID';

  @override
  String get enterTechnicianId => 'Enter your technician ID.';

  @override
  String get technicianIdNotRecognized => 'Technician ID was not recognized.';

  @override
  String get signIn => 'Sign in';

  @override
  String get demoTechnicianId => 'Demo technician ID: TECH-001';

  @override
  String get technicianJobs => 'Technician jobs';

  @override
  String get workflowExamples => 'Workflow examples';

  @override
  String get workflowDemoNotice =>
      'Dummy workflow examples; these are not live jobs or notifications.';

  @override
  String get workflowStatusWorkAccepted => 'Work Accepted';

  @override
  String get workflowStatusWorkRejected => 'Work Rejected';

  @override
  String get workflowStatusTravelling => 'Travelling to Site';

  @override
  String get workflowStatusWorkStarted => 'Work Started';

  @override
  String get workflowStatusWorkBlocked => 'Work Blocked';

  @override
  String get workflowStatusWorkCompleted =>
      'Work Completed - Awaiting Confirmation';

  @override
  String get workflowStatusClosed => 'Closed';

  @override
  String get workflowStatusReopened => 'Reopened';

  @override
  String get tenantNotification => 'Tenant notification preview';

  @override
  String get adminNotification => 'Administrator notification preview';

  @override
  String get tenantNotNotifiedDuringReview =>
      'No immediate tenant notification; tenant-facing status stays Pending / In Progress during admin review.';

  @override
  String get tenantNotifiedWorkAccepted =>
      'Tenant is told the work was accepted and sees the technician\'s name.';

  @override
  String get adminNotifiedWorkAccepted =>
      'Administrator is told the technician accepted the work.';

  @override
  String get adminNotifiedWorkRejected =>
      'Administrator is notified with the technician\'s rejection reason.';

  @override
  String get tenantNotifiedTravelling =>
      'Tenant is told the technician is travelling, including the technician\'s name.';

  @override
  String get adminNotifiedTravelling =>
      'Administrator is told the technician is travelling to site.';

  @override
  String get tenantNotifiedWorkStarted => 'Tenant is told work has started.';

  @override
  String get adminNotifiedWorkStarted =>
      'Administrator is told work has started.';

  @override
  String get tenantNotifiedWorkBlocked =>
      'Tenant is told work is blocked; the reason is included.';

  @override
  String get adminNotifiedWorkBlocked =>
      'Administrator is told work is blocked; the reason is included.';

  @override
  String get tenantNotifiedWorkCompleted =>
      'Tenant is asked to review and accept or reject the completed work.';

  @override
  String get adminNotifiedWorkCompleted =>
      'Administrator is told work awaits confirmation; elapsed time is included for history/billing.';

  @override
  String get tenantNotifiedClosed =>
      'Tenant is told the work order is closed after both approvals.';

  @override
  String get adminNotifiedClosed =>
      'Administrator is told the work order is closed after both approvals.';

  @override
  String get tenantNotifiedReopened =>
      'Tenant is told the work order was reopened.';

  @override
  String get adminNotifiedReopened =>
      'Administrator is told the work order was reopened and needs review.';

  @override
  String get workflowReason => 'Reason';

  @override
  String workflowElapsedMinutes(String minutes) {
    return 'Time taken: $minutes min';
  }

  @override
  String get workflowEventTime => 'Event time';

  @override
  String get assignedJobs => 'Assigned';

  @override
  String get workHistory => 'Work history';

  @override
  String get sampleAssignmentsNotice =>
      'Sample assignments; changes are saved on this device only.';

  @override
  String get noAssignments => 'No assignments in this list.';

  @override
  String get locationUnavailable => 'Location unavailable';

  @override
  String couldNotLoadAssignments(String error) {
    return 'Could not load assignments: $error';
  }

  @override
  String get workCompletedAwaitingTenant =>
      'Work completed · awaiting tenant confirmation';

  @override
  String get jobDetails => 'Job details';

  @override
  String couldNotLoadJob(String error) {
    return 'Could not load job: $error';
  }

  @override
  String get assignmentNotFound => 'Assignment not found.';

  @override
  String get completeWork => 'Complete work';

  @override
  String get submitCompletion => 'Submit completion';

  @override
  String get proposalSaved =>
      'Proposal saved. Tenant and administrator approval are required.';

  @override
  String get sampleAssignmentNotice =>
      'Sample assignment. No real resident or service is affected.';

  @override
  String get scheduledTime => 'Scheduled time';

  @override
  String get appointmentNotScheduled => 'Not scheduled';

  @override
  String get appointmentChangeProposal => 'Appointment change proposal';

  @override
  String get technicianProposedAppointment =>
      'Technician proposed a new appointment';

  @override
  String get tenant => 'Tenant';

  @override
  String get administrator => 'Administrator';

  @override
  String get approved => 'approved';

  @override
  String get pending => 'pending';

  @override
  String get rejectNewTime => 'Reject new time';

  @override
  String get approveNewTime => 'Approve new time';

  @override
  String get appointmentUnchangedUntilBothApprove =>
      'The current appointment stays in place until both the tenant and administrator approve.';

  @override
  String get confirmWorkAndClose => 'Confirm work and close request';

  @override
  String get reopenRequest => 'Reopen request';

  @override
  String get reopenWindowExpired => 'The 24-hour reopen window has expired.';

  @override
  String get tenantConfirmationClosesRequest =>
      'The tenant closes the request after confirming the repair.';

  @override
  String get acceptAssignment => 'Accept assignment';

  @override
  String get startWork => 'Start work';

  @override
  String get proposeNewTime => 'Propose new time';

  @override
  String get markWorkComplete => 'Mark work complete';

  @override
  String get cancel => 'Cancel';

  @override
  String get request => 'Request';

  @override
  String couldNotLoadProfile(String error) {
    return 'Could not load profile: $error';
  }

  @override
  String get tenantDetails => 'Tenant details';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get emiratesId => 'Emirates ID';

  @override
  String get apartmentDetails => 'Apartment details';

  @override
  String get towerNumber => 'Tower number';

  @override
  String get floor => 'Floor';

  @override
  String get address => 'Address';

  @override
  String get tenancyDetails => 'Tenancy details';

  @override
  String get tenancyStart => 'Tenancy start';

  @override
  String get tenancyEnd => 'Tenancy end';

  @override
  String get annualRent => 'Annual rent';

  @override
  String get paymentFrequency => 'Payment frequency';

  @override
  String get securityDeposit => 'Security deposit';

  @override
  String get contractDetails => 'Contract details';

  @override
  String get contractNumber => 'Contract number';

  @override
  String get landlord => 'Landlord / property manager';

  @override
  String get contractIssued => 'Contract issued';

  @override
  String get contractExpires => 'Contract expires';

  @override
  String get closedCases => 'Closed cases';

  @override
  String couldNotLoadClosedCases(String error) {
    return 'Could not load closed cases: $error';
  }

  @override
  String get raisedOn => 'Raised on';

  @override
  String get approvedByManager => 'Approved by manager';

  @override
  String get technicianName => 'Technician';

  @override
  String get appointment => 'Appointment';

  @override
  String get fixDate => 'Fix date';

  @override
  String get closingComments => 'Closing comments';

  @override
  String get assignedTechnician => 'Assigned technician';

  @override
  String couldNotLoadMoveOut(String error) {
    return 'Could not load move-out request: $error';
  }

  @override
  String get chooseMoveOutDate => 'Choose move-out date';

  @override
  String get moveOutDate => 'Move-out date';

  @override
  String get moveOutDateRequired => 'Choose a move-out date.';

  @override
  String get moveOutReason => 'Reason';

  @override
  String get moveOutReasonRequired => 'Enter a reason for moving out.';

  @override
  String get contactNumber => 'Contact number';

  @override
  String get forwardingAddress => 'Forwarding address';

  @override
  String get forwardingAddressRequired => 'Enter a forwarding address.';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get submitMoveOutRequest => 'Submit move-out request';

  @override
  String get moveOutSubmittedTitle => 'Your move-out request';

  @override
  String get moveOutStatusReview => 'Review';

  @override
  String get moveOutStatusInspectionScheduled => 'Inspection scheduled';

  @override
  String get moveOutStatusInspectionCompleted => 'Inspection completed';

  @override
  String get moveOutStatusApproved => 'Approved';

  @override
  String get moveOutStatusClosed => 'Closed';

  @override
  String couldNotLoadRequests(String error) {
    return 'Could not load requests: $error';
  }

  @override
  String get noRequestsYet => 'No service requests yet.';

  @override
  String get requestDetails => 'Request details';

  @override
  String get requestNotFound => 'Request not found.';

  @override
  String couldNotLoadRequest(String error) {
    return 'Could not load request: $error';
  }

  @override
  String get requestStatus => 'Request status';

  @override
  String get statusSavedOnDevice =>
      'Status shown is the latest information saved on this device.';

  @override
  String get statusSubmitted => 'Submitted';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusAssigned => 'Assigned';

  @override
  String get statusAppointmentScheduled => 'Appointment scheduled';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get filterCategory => 'Category';

  @override
  String get allCategories => 'All categories';

  @override
  String get filterStatus => 'Status';

  @override
  String get allStatuses => 'All statuses';

  @override
  String get filterDateRange => 'Filter by date range';

  @override
  String couldNotLoadHistory(String error) {
    return 'Could not load service history: $error';
  }

  @override
  String get noServiceHistory => 'No service history yet.';

  @override
  String get noMatchingRequests => 'No requests match these filters.';

  @override
  String get costNotRecorded => 'Cost not recorded';

  @override
  String recordedCost(String cost) {
    return 'Cost: $cost';
  }

  @override
  String get selectLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';
}
