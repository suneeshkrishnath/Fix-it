import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Fix-it'**
  String get appName;

  /// No description provided for @residentSignIn.
  ///
  /// In en, this message translates to:
  /// **'Resident sign in'**
  String get residentSignIn;

  /// No description provided for @welcomeToFixIt.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Fix-it'**
  String get welcomeToFixIt;

  /// No description provided for @signInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your resident details.'**
  String get signInPrompt;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @apartmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Apartment number'**
  String get apartmentNumber;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get sendVerificationCode;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get enterPhoneNumber;

  /// No description provided for @enterApartmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your apartment number.'**
  String get enterApartmentNumber;

  /// No description provided for @residentDetailsNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'Resident details were not recognized.'**
  String get residentDetailsNotRecognized;

  /// No description provided for @otpRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not request a verification code: {error}'**
  String otpRequestFailed(String error);

  /// No description provided for @prototypeResident.
  ///
  /// In en, this message translates to:
  /// **'Prototype resident: {phone}, apartment {apartment}'**
  String prototypeResident(String phone, String apartment);

  /// No description provided for @verifyPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify phone number'**
  String get verifyPhoneNumber;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your verification code'**
  String get enterVerificationCode;

  /// No description provided for @mockCodeExplanation.
  ///
  /// In en, this message translates to:
  /// **'The prototype uses a fixed mock code.'**
  String get mockCodeExplanation;

  /// No description provided for @prototypeCode.
  ///
  /// In en, this message translates to:
  /// **'Prototype code: 123456'**
  String get prototypeCode;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify and continue'**
  String get verifyAndContinue;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @incorrectVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'The verification code is incorrect.'**
  String get incorrectVerificationCode;

  /// No description provided for @otpVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify the code: {error}'**
  String otpVerificationFailed(String error);

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @welcomeResident.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeResident(String name);

  /// No description provided for @apartmentValue.
  ///
  /// In en, this message translates to:
  /// **'Apartment {number}'**
  String apartmentValue(String number);

  /// No description provided for @serviceRequests.
  ///
  /// In en, this message translates to:
  /// **'Service requests'**
  String get serviceRequests;

  /// No description provided for @createServiceRequest.
  ///
  /// In en, this message translates to:
  /// **'Create service request'**
  String get createServiceRequest;

  /// No description provided for @reportMaintenanceIssue.
  ///
  /// In en, this message translates to:
  /// **'Report a maintenance issue'**
  String get reportMaintenanceIssue;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My requests'**
  String get myRequests;

  /// No description provided for @trackOpenRequests.
  ///
  /// In en, this message translates to:
  /// **'Track open requests'**
  String get trackOpenRequests;

  /// No description provided for @serviceHistory.
  ///
  /// In en, this message translates to:
  /// **'Service history'**
  String get serviceHistory;

  /// No description provided for @reviewCompletedServices.
  ///
  /// In en, this message translates to:
  /// **'Review completed services'**
  String get reviewCompletedServices;

  /// No description provided for @apartmentSection.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartmentSection;

  /// No description provided for @moveOutRequest.
  ///
  /// In en, this message translates to:
  /// **'Move-out request'**
  String get moveOutRequest;

  /// No description provided for @startMoveOutRequest.
  ///
  /// In en, this message translates to:
  /// **'Start a move-out request'**
  String get startMoveOutRequest;

  /// No description provided for @residentProfile.
  ///
  /// In en, this message translates to:
  /// **'Resident profile'**
  String get residentProfile;

  /// No description provided for @viewResidentDetails.
  ///
  /// In en, this message translates to:
  /// **'View resident details'**
  String get viewResidentDetails;

  /// No description provided for @createRequestPlanned.
  ///
  /// In en, this message translates to:
  /// **'Service request creation is planned for a later stage.'**
  String get createRequestPlanned;

  /// No description provided for @requestTrackingPlanned.
  ///
  /// In en, this message translates to:
  /// **'Request tracking is planned for a later stage.'**
  String get requestTrackingPlanned;

  /// No description provided for @historyPlanned.
  ///
  /// In en, this message translates to:
  /// **'Service history is planned for a later stage.'**
  String get historyPlanned;

  /// No description provided for @moveOutPlanned.
  ///
  /// In en, this message translates to:
  /// **'Move-out requests are planned for a later stage.'**
  String get moveOutPlanned;

  /// No description provided for @profilePlanned.
  ///
  /// In en, this message translates to:
  /// **'Resident profile details are planned for a later stage.'**
  String get profilePlanned;

  /// No description provided for @serviceCategory.
  ///
  /// In en, this message translates to:
  /// **'Service category'**
  String get serviceCategory;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service type'**
  String get serviceType;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get describeIssue;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a description of the issue.'**
  String get descriptionRequired;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @choosePreferredVisit.
  ///
  /// In en, this message translates to:
  /// **'Choose preferred visit time (optional)'**
  String get choosePreferredVisit;

  /// No description provided for @preferredVisit.
  ///
  /// In en, this message translates to:
  /// **'Preferred: {date} {time}'**
  String preferredVisit(String date, String time);

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get submitRequest;

  /// No description provided for @requestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request submitted'**
  String get requestSubmitted;

  /// No description provided for @requestNumberSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request {requestNumber} submitted'**
  String requestNumberSubmitted(String requestNumber);

  /// No description provided for @returnToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Return to dashboard'**
  String get returnToDashboard;

  /// No description provided for @plumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get plumbing;

  /// No description provided for @electrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get electrical;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @cleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get cleaning;

  /// No description provided for @installation.
  ///
  /// In en, this message translates to:
  /// **'Installation'**
  String get installation;

  /// No description provided for @homeServices.
  ///
  /// In en, this message translates to:
  /// **'Home Services'**
  String get homeServices;

  /// No description provided for @electricalUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Electrical Upgrade'**
  String get electricalUpgrade;

  /// No description provided for @waterLeakage.
  ///
  /// In en, this message translates to:
  /// **'Water leakage'**
  String get waterLeakage;

  /// No description provided for @drainBlockage.
  ///
  /// In en, this message translates to:
  /// **'Drain blockage'**
  String get drainBlockage;

  /// No description provided for @pipeMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Pipe maintenance'**
  String get pipeMaintenance;

  /// No description provided for @waterPressureIssue.
  ///
  /// In en, this message translates to:
  /// **'Water pressure issue'**
  String get waterPressureIssue;

  /// No description provided for @commonAreaLighting.
  ///
  /// In en, this message translates to:
  /// **'Common area lighting'**
  String get commonAreaLighting;

  /// No description provided for @electricalFault.
  ///
  /// In en, this message translates to:
  /// **'Electrical fault'**
  String get electricalFault;

  /// No description provided for @switchMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Switch maintenance'**
  String get switchMaintenance;

  /// No description provided for @doorRepair.
  ///
  /// In en, this message translates to:
  /// **'Door repair'**
  String get doorRepair;

  /// No description provided for @windowMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Window maintenance'**
  String get windowMaintenance;

  /// No description provided for @corridorCleaning.
  ///
  /// In en, this message translates to:
  /// **'Corridor cleaning'**
  String get corridorCleaning;

  /// No description provided for @commonAreaCleanliness.
  ///
  /// In en, this message translates to:
  /// **'Common area cleanliness'**
  String get commonAreaCleanliness;

  /// No description provided for @airConditionerInstallation.
  ///
  /// In en, this message translates to:
  /// **'Air conditioner installation'**
  String get airConditionerInstallation;

  /// No description provided for @refrigeratorInstallation.
  ///
  /// In en, this message translates to:
  /// **'Refrigerator installation'**
  String get refrigeratorInstallation;

  /// No description provided for @washingMachineInstallation.
  ///
  /// In en, this message translates to:
  /// **'Washing machine installation'**
  String get washingMachineInstallation;

  /// No description provided for @furnitureAssembly.
  ///
  /// In en, this message translates to:
  /// **'Furniture assembly'**
  String get furnitureAssembly;

  /// No description provided for @painting.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get painting;

  /// No description provided for @minorRenovation.
  ///
  /// In en, this message translates to:
  /// **'Minor renovation'**
  String get minorRenovation;

  /// No description provided for @additionalSockets.
  ///
  /// In en, this message translates to:
  /// **'Additional sockets'**
  String get additionalSockets;

  /// No description provided for @customWiring.
  ///
  /// In en, this message translates to:
  /// **'Custom wiring'**
  String get customWiring;

  /// No description provided for @additionalServices.
  ///
  /// In en, this message translates to:
  /// **'Additional Services'**
  String get additionalServices;

  /// No description provided for @housemaid.
  ///
  /// In en, this message translates to:
  /// **'Housemaid'**
  String get housemaid;

  /// No description provided for @babysitter.
  ///
  /// In en, this message translates to:
  /// **'Babysitter'**
  String get babysitter;

  /// No description provided for @proxyDriver.
  ///
  /// In en, this message translates to:
  /// **'Proxy driver'**
  String get proxyDriver;

  /// No description provided for @deepCleaning.
  ///
  /// In en, this message translates to:
  /// **'Deep cleaning'**
  String get deepCleaning;

  /// No description provided for @sampleDataNotice.
  ///
  /// In en, this message translates to:
  /// **'Sample data for prototype purposes.'**
  String get sampleDataNotice;

  /// No description provided for @statusAwaitingTenantConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Awaiting tenant confirmation'**
  String get statusAwaitingTenantConfirmation;

  /// No description provided for @statusClosedByTenant.
  ///
  /// In en, this message translates to:
  /// **'Closed by tenant'**
  String get statusClosedByTenant;

  /// No description provided for @statusReopened.
  ///
  /// In en, this message translates to:
  /// **'Reopened'**
  String get statusReopened;

  /// No description provided for @technicianSignIn.
  ///
  /// In en, this message translates to:
  /// **'Technician sign in'**
  String get technicianSignIn;

  /// No description provided for @technicianWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Technician workspace'**
  String get technicianWorkspace;

  /// No description provided for @technicianPrototypeAuthNotice.
  ///
  /// In en, this message translates to:
  /// **'Prototype access uses a technician ID only. This is not secure authentication.'**
  String get technicianPrototypeAuthNotice;

  /// No description provided for @technicianLoginId.
  ///
  /// In en, this message translates to:
  /// **'Technician login ID'**
  String get technicianLoginId;

  /// No description provided for @enterTechnicianId.
  ///
  /// In en, this message translates to:
  /// **'Enter your technician ID.'**
  String get enterTechnicianId;

  /// No description provided for @technicianIdNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'Technician ID was not recognized.'**
  String get technicianIdNotRecognized;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @demoTechnicianId.
  ///
  /// In en, this message translates to:
  /// **'Demo technician ID: TECH-001'**
  String get demoTechnicianId;

  /// No description provided for @technicianJobs.
  ///
  /// In en, this message translates to:
  /// **'Technician jobs'**
  String get technicianJobs;

  /// No description provided for @assignedJobs.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assignedJobs;

  /// No description provided for @workHistory.
  ///
  /// In en, this message translates to:
  /// **'Work history'**
  String get workHistory;

  /// No description provided for @sampleAssignmentsNotice.
  ///
  /// In en, this message translates to:
  /// **'Sample assignments; changes are saved on this device only.'**
  String get sampleAssignmentsNotice;

  /// No description provided for @noAssignments.
  ///
  /// In en, this message translates to:
  /// **'No assignments in this list.'**
  String get noAssignments;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get locationUnavailable;

  /// No description provided for @couldNotLoadAssignments.
  ///
  /// In en, this message translates to:
  /// **'Could not load assignments: {error}'**
  String couldNotLoadAssignments(String error);

  /// No description provided for @workCompletedAwaitingTenant.
  ///
  /// In en, this message translates to:
  /// **'Work completed · awaiting tenant confirmation'**
  String get workCompletedAwaitingTenant;

  /// No description provided for @jobDetails.
  ///
  /// In en, this message translates to:
  /// **'Job details'**
  String get jobDetails;

  /// No description provided for @couldNotLoadJob.
  ///
  /// In en, this message translates to:
  /// **'Could not load job: {error}'**
  String couldNotLoadJob(String error);

  /// No description provided for @assignmentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Assignment not found.'**
  String get assignmentNotFound;

  /// No description provided for @completeWork.
  ///
  /// In en, this message translates to:
  /// **'Complete work'**
  String get completeWork;

  /// No description provided for @submitCompletion.
  ///
  /// In en, this message translates to:
  /// **'Submit completion'**
  String get submitCompletion;

  /// No description provided for @proposalSaved.
  ///
  /// In en, this message translates to:
  /// **'Proposal saved. Tenant and administrator approval are required.'**
  String get proposalSaved;

  /// No description provided for @sampleAssignmentNotice.
  ///
  /// In en, this message translates to:
  /// **'Sample assignment. No real resident or service is affected.'**
  String get sampleAssignmentNotice;

  /// No description provided for @scheduledTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled time'**
  String get scheduledTime;

  /// No description provided for @appointmentNotScheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get appointmentNotScheduled;

  /// No description provided for @appointmentChangeProposal.
  ///
  /// In en, this message translates to:
  /// **'Appointment change proposal'**
  String get appointmentChangeProposal;

  /// No description provided for @technicianProposedAppointment.
  ///
  /// In en, this message translates to:
  /// **'Technician proposed a new appointment'**
  String get technicianProposedAppointment;

  /// No description provided for @tenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenant;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get pending;

  /// No description provided for @rejectNewTime.
  ///
  /// In en, this message translates to:
  /// **'Reject new time'**
  String get rejectNewTime;

  /// No description provided for @approveNewTime.
  ///
  /// In en, this message translates to:
  /// **'Approve new time'**
  String get approveNewTime;

  /// No description provided for @appointmentUnchangedUntilBothApprove.
  ///
  /// In en, this message translates to:
  /// **'The current appointment stays in place until both the tenant and administrator approve.'**
  String get appointmentUnchangedUntilBothApprove;

  /// No description provided for @confirmWorkAndClose.
  ///
  /// In en, this message translates to:
  /// **'Confirm work and close request'**
  String get confirmWorkAndClose;

  /// No description provided for @reopenRequest.
  ///
  /// In en, this message translates to:
  /// **'Reopen request'**
  String get reopenRequest;

  /// No description provided for @reopenWindowExpired.
  ///
  /// In en, this message translates to:
  /// **'The 24-hour reopen window has expired.'**
  String get reopenWindowExpired;

  /// No description provided for @tenantConfirmationClosesRequest.
  ///
  /// In en, this message translates to:
  /// **'The tenant closes the request after confirming the repair.'**
  String get tenantConfirmationClosesRequest;

  /// No description provided for @acceptAssignment.
  ///
  /// In en, this message translates to:
  /// **'Accept assignment'**
  String get acceptAssignment;

  /// No description provided for @startWork.
  ///
  /// In en, this message translates to:
  /// **'Start work'**
  String get startWork;

  /// No description provided for @proposeNewTime.
  ///
  /// In en, this message translates to:
  /// **'Propose new time'**
  String get proposeNewTime;

  /// No description provided for @markWorkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark work complete'**
  String get markWorkComplete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @couldNotLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile: {error}'**
  String couldNotLoadProfile(String error);

  /// No description provided for @tenantDetails.
  ///
  /// In en, this message translates to:
  /// **'Tenant details'**
  String get tenantDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emiratesId.
  ///
  /// In en, this message translates to:
  /// **'Emirates ID'**
  String get emiratesId;

  /// No description provided for @apartmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Apartment details'**
  String get apartmentDetails;

  /// No description provided for @towerNumber.
  ///
  /// In en, this message translates to:
  /// **'Tower number'**
  String get towerNumber;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @tenancyDetails.
  ///
  /// In en, this message translates to:
  /// **'Tenancy details'**
  String get tenancyDetails;

  /// No description provided for @tenancyStart.
  ///
  /// In en, this message translates to:
  /// **'Tenancy start'**
  String get tenancyStart;

  /// No description provided for @tenancyEnd.
  ///
  /// In en, this message translates to:
  /// **'Tenancy end'**
  String get tenancyEnd;

  /// No description provided for @annualRent.
  ///
  /// In en, this message translates to:
  /// **'Annual rent'**
  String get annualRent;

  /// No description provided for @paymentFrequency.
  ///
  /// In en, this message translates to:
  /// **'Payment frequency'**
  String get paymentFrequency;

  /// No description provided for @securityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get securityDeposit;

  /// No description provided for @contractDetails.
  ///
  /// In en, this message translates to:
  /// **'Contract details'**
  String get contractDetails;

  /// No description provided for @contractNumber.
  ///
  /// In en, this message translates to:
  /// **'Contract number'**
  String get contractNumber;

  /// No description provided for @landlord.
  ///
  /// In en, this message translates to:
  /// **'Landlord / property manager'**
  String get landlord;

  /// No description provided for @contractIssued.
  ///
  /// In en, this message translates to:
  /// **'Contract issued'**
  String get contractIssued;

  /// No description provided for @contractExpires.
  ///
  /// In en, this message translates to:
  /// **'Contract expires'**
  String get contractExpires;

  /// No description provided for @closedCases.
  ///
  /// In en, this message translates to:
  /// **'Closed cases'**
  String get closedCases;

  /// No description provided for @couldNotLoadClosedCases.
  ///
  /// In en, this message translates to:
  /// **'Could not load closed cases: {error}'**
  String couldNotLoadClosedCases(String error);

  /// No description provided for @raisedOn.
  ///
  /// In en, this message translates to:
  /// **'Raised on'**
  String get raisedOn;

  /// No description provided for @approvedByManager.
  ///
  /// In en, this message translates to:
  /// **'Approved by manager'**
  String get approvedByManager;

  /// No description provided for @technicianName.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get technicianName;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// No description provided for @fixDate.
  ///
  /// In en, this message translates to:
  /// **'Fix date'**
  String get fixDate;

  /// No description provided for @closingComments.
  ///
  /// In en, this message translates to:
  /// **'Closing comments'**
  String get closingComments;

  /// No description provided for @assignedTechnician.
  ///
  /// In en, this message translates to:
  /// **'Assigned technician'**
  String get assignedTechnician;

  /// No description provided for @couldNotLoadMoveOut.
  ///
  /// In en, this message translates to:
  /// **'Could not load move-out request: {error}'**
  String couldNotLoadMoveOut(String error);

  /// No description provided for @chooseMoveOutDate.
  ///
  /// In en, this message translates to:
  /// **'Choose move-out date'**
  String get chooseMoveOutDate;

  /// No description provided for @moveOutDate.
  ///
  /// In en, this message translates to:
  /// **'Move-out date'**
  String get moveOutDate;

  /// No description provided for @moveOutDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a move-out date.'**
  String get moveOutDateRequired;

  /// No description provided for @moveOutReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get moveOutReason;

  /// No description provided for @moveOutReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a reason for moving out.'**
  String get moveOutReasonRequired;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get contactNumber;

  /// No description provided for @forwardingAddress.
  ///
  /// In en, this message translates to:
  /// **'Forwarding address'**
  String get forwardingAddress;

  /// No description provided for @forwardingAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a forwarding address.'**
  String get forwardingAddressRequired;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @submitMoveOutRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit move-out request'**
  String get submitMoveOutRequest;

  /// No description provided for @moveOutSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your move-out request'**
  String get moveOutSubmittedTitle;

  /// No description provided for @moveOutStatusReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get moveOutStatusReview;

  /// No description provided for @moveOutStatusInspectionScheduled.
  ///
  /// In en, this message translates to:
  /// **'Inspection scheduled'**
  String get moveOutStatusInspectionScheduled;

  /// No description provided for @moveOutStatusInspectionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Inspection completed'**
  String get moveOutStatusInspectionCompleted;

  /// No description provided for @moveOutStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get moveOutStatusApproved;

  /// No description provided for @moveOutStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get moveOutStatusClosed;

  /// No description provided for @couldNotLoadRequests.
  ///
  /// In en, this message translates to:
  /// **'Could not load requests: {error}'**
  String couldNotLoadRequests(String error);

  /// No description provided for @noRequestsYet.
  ///
  /// In en, this message translates to:
  /// **'No service requests yet.'**
  String get noRequestsYet;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request details'**
  String get requestDetails;

  /// No description provided for @requestNotFound.
  ///
  /// In en, this message translates to:
  /// **'Request not found.'**
  String get requestNotFound;

  /// No description provided for @couldNotLoadRequest.
  ///
  /// In en, this message translates to:
  /// **'Could not load request: {error}'**
  String couldNotLoadRequest(String error);

  /// No description provided for @requestStatus.
  ///
  /// In en, this message translates to:
  /// **'Request status'**
  String get requestStatus;

  /// No description provided for @statusSavedOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Status shown is the latest information saved on this device.'**
  String get statusSavedOnDevice;

  /// No description provided for @statusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get statusSubmitted;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get statusAssigned;

  /// No description provided for @statusAppointmentScheduled.
  ///
  /// In en, this message translates to:
  /// **'Appointment scheduled'**
  String get statusAppointmentScheduled;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @filterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterCategory;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get allStatuses;

  /// No description provided for @filterDateRange.
  ///
  /// In en, this message translates to:
  /// **'Filter by date range'**
  String get filterDateRange;

  /// No description provided for @couldNotLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Could not load service history: {error}'**
  String couldNotLoadHistory(String error);

  /// No description provided for @noServiceHistory.
  ///
  /// In en, this message translates to:
  /// **'No service history yet.'**
  String get noServiceHistory;

  /// No description provided for @noMatchingRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests match these filters.'**
  String get noMatchingRequests;

  /// No description provided for @costNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Cost not recorded'**
  String get costNotRecorded;

  /// No description provided for @recordedCost.
  ///
  /// In en, this message translates to:
  /// **'Cost: {cost}'**
  String recordedCost(String cost);

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get selectLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
