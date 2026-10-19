// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'فكس إت';

  @override
  String get residentSignIn => 'تسجيل دخول السكان';

  @override
  String get welcomeToFixIt => 'مرحباً بك في فكس إت';

  @override
  String get signInPrompt => 'سجّل الدخول باستخدام بيانات السكن.';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get apartmentNumber => 'رقم الشقة';

  @override
  String get sendVerificationCode => 'إرسال رمز التحقق';

  @override
  String get enterPhoneNumber => 'أدخل رقم هاتفك.';

  @override
  String get enterApartmentNumber => 'أدخل رقم شقتك.';

  @override
  String get residentDetailsNotRecognized => 'لم يتم التعرف على بيانات الساكن.';

  @override
  String otpRequestFailed(String error) {
    return 'تعذر طلب رمز التحقق: $error';
  }

  @override
  String prototypeResident(String phone, String apartment) {
    return 'بيانات الساكن التجريبية: $phone، الشقة $apartment';
  }

  @override
  String get verifyPhoneNumber => 'التحقق من رقم الهاتف';

  @override
  String get enterVerificationCode => 'أدخل رمز التحقق';

  @override
  String get mockCodeExplanation =>
      'يستخدم النموذج الأولي رمزاً تجريبياً ثابتاً.';

  @override
  String get prototypeCode => 'الرمز التجريبي: 123456';

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get verifyAndContinue => 'تحقق ومتابعة';

  @override
  String get backToSignIn => 'العودة إلى تسجيل الدخول';

  @override
  String get incorrectVerificationCode => 'رمز التحقق غير صحيح.';

  @override
  String otpVerificationFailed(String error) {
    return 'تعذر التحقق من الرمز: $error';
  }

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String welcomeResident(String name) {
    return 'مرحباً، $name';
  }

  @override
  String apartmentValue(String number) {
    return 'الشقة $number';
  }

  @override
  String get serviceRequests => 'طلبات الخدمة';

  @override
  String get createServiceRequest => 'إنشاء طلب خدمة';

  @override
  String get reportMaintenanceIssue => 'الإبلاغ عن مشكلة صيانة';

  @override
  String get myRequests => 'طلباتي';

  @override
  String get trackOpenRequests => 'متابعة الطلبات المفتوحة';

  @override
  String get serviceHistory => 'سجل الخدمات';

  @override
  String get reviewCompletedServices => 'مراجعة الخدمات المكتملة';

  @override
  String get apartmentSection => 'السكن';

  @override
  String get moveOutRequest => 'طلب إخلاء الشقة';

  @override
  String get startMoveOutRequest => 'بدء طلب إخلاء الشقة';

  @override
  String get residentProfile => 'ملف الساكن';

  @override
  String get viewResidentDetails => 'عرض بيانات الساكن';

  @override
  String get createRequestPlanned =>
      'سيتم توفير إنشاء طلب الخدمة في مرحلة لاحقة.';

  @override
  String get requestTrackingPlanned => 'ستتوفر متابعة الطلب في مرحلة لاحقة.';

  @override
  String get historyPlanned => 'سيتوفر سجل الخدمات في مرحلة لاحقة.';

  @override
  String get moveOutPlanned => 'ستتوفر طلبات إخلاء الشقة في مرحلة لاحقة.';

  @override
  String get profilePlanned => 'ستتوفر تفاصيل ملف الساكن في مرحلة لاحقة.';

  @override
  String get serviceCategory => 'فئة الخدمة';

  @override
  String get serviceType => 'نوع الخدمة';

  @override
  String get describeIssue => 'اشرح المشكلة';

  @override
  String get descriptionRequired => 'أضف وصفاً للمشكلة.';

  @override
  String get priority => 'الأولوية';

  @override
  String get priorityLow => 'منخفضة';

  @override
  String get priorityNormal => 'عادية';

  @override
  String get priorityHigh => 'مرتفعة';

  @override
  String get choosePreferredVisit => 'اختر موعد الزيارة المفضل (اختياري)';

  @override
  String preferredVisit(String date, String time) {
    return 'الموعد المفضل: $date $time';
  }

  @override
  String get submitRequest => 'إرسال الطلب';

  @override
  String get requestSubmitted => 'تم إرسال الطلب';

  @override
  String requestNumberSubmitted(String requestNumber) {
    return 'تم إرسال الطلب $requestNumber';
  }

  @override
  String get returnToDashboard => 'العودة إلى الصفحة الرئيسية';

  @override
  String get plumbing => 'السباكة';

  @override
  String get electrical => 'الكهرباء';

  @override
  String get maintenance => 'الصيانة العامة';

  @override
  String get cleaning => 'التنظيف';

  @override
  String get installation => 'التركيب';

  @override
  String get homeServices => 'خدمات منزلية';

  @override
  String get electricalUpgrade => 'تحسينات كهربائية';

  @override
  String get waterLeakage => 'تسرب مياه';

  @override
  String get drainBlockage => 'انسداد مصرف';

  @override
  String get pipeMaintenance => 'صيانة الأنابيب';

  @override
  String get waterPressureIssue => 'مشكلة ضغط المياه';

  @override
  String get commonAreaLighting => 'إنارة المناطق المشتركة';

  @override
  String get electricalFault => 'عطل كهربائي';

  @override
  String get switchMaintenance => 'صيانة مفتاح كهربائي';

  @override
  String get doorRepair => 'إصلاح باب';

  @override
  String get windowMaintenance => 'صيانة نافذة';

  @override
  String get corridorCleaning => 'تنظيف الممرات';

  @override
  String get commonAreaCleanliness => 'نظافة المناطق المشتركة';

  @override
  String get airConditionerInstallation => 'تركيب مكيف هواء';

  @override
  String get refrigeratorInstallation => 'تركيب ثلاجة';

  @override
  String get washingMachineInstallation => 'تركيب غسالة';

  @override
  String get furnitureAssembly => 'تركيب الأثاث';

  @override
  String get painting => 'الطلاء';

  @override
  String get minorRenovation => 'ترميم بسيط';

  @override
  String get additionalSockets => 'مقابس إضافية';

  @override
  String get customWiring => 'تمديدات كهربائية خاصة';

  @override
  String get additionalServices => 'خدمات إضافية';

  @override
  String get housemaid => 'خادمة منزل';

  @override
  String get babysitter => 'مربية أطفال';

  @override
  String get proxyDriver => 'سائق بديل';

  @override
  String get deepCleaning => 'تنظيف عميق';

  @override
  String get sampleDataNotice => 'بيانات تجريبية لأغراض النموذج الأولي.';

  @override
  String get statusAwaitingTenantConfirmation => 'بانتظار تأكيد المستأجر';

  @override
  String get statusClosedByTenant => 'أغلقه المستأجر';

  @override
  String get statusReopened => 'أعيد فتحه';

  @override
  String get technicianSignIn => 'تسجيل دخول الفني';

  @override
  String get technicianWorkspace => 'مساحة عمل الفني';

  @override
  String get technicianPrototypeAuthNotice =>
      'يستخدم الدخول التجريبي رقم الفني فقط، وهذا ليس مصادقة آمنة.';

  @override
  String get technicianLoginId => 'رقم دخول الفني';

  @override
  String get enterTechnicianId => 'أدخل رقم الفني.';

  @override
  String get technicianIdNotRecognized => 'لم يتم التعرف على رقم الفني.';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get demoTechnicianId => 'رقم الفني التجريبي: TECH-001';

  @override
  String get technicianJobs => 'مهام الفني';

  @override
  String get assignedJobs => 'المهام المسندة';

  @override
  String get workHistory => 'سجل الأعمال';

  @override
  String get sampleAssignmentsNotice =>
      'مهام تجريبية؛ تُحفظ التغييرات على هذا الجهاز فقط.';

  @override
  String get noAssignments => 'لا توجد مهام في هذه القائمة.';

  @override
  String get locationUnavailable => 'الموقع غير متاح';

  @override
  String couldNotLoadAssignments(String error) {
    return 'تعذر تحميل المهام: $error';
  }

  @override
  String get workCompletedAwaitingTenant =>
      'اكتمل العمل · بانتظار تأكيد المستأجر';

  @override
  String get jobDetails => 'تفاصيل المهمة';

  @override
  String couldNotLoadJob(String error) {
    return 'تعذر تحميل المهمة: $error';
  }

  @override
  String get assignmentNotFound => 'لم يتم العثور على المهمة.';

  @override
  String get completeWork => 'إكمال العمل';

  @override
  String get submitCompletion => 'إرسال الإكمال';

  @override
  String get proposalSaved => 'تم حفظ الاقتراح. يلزم اعتماد المستأجر والمسؤول.';

  @override
  String get sampleAssignmentNotice =>
      'مهمة تجريبية. لن يتأثر أي مقيم أو طلب حقيقي.';

  @override
  String get scheduledTime => 'الموعد المحدد';

  @override
  String get appointmentNotScheduled => 'لم يتم تحديد موعد';

  @override
  String get appointmentChangeProposal => 'اقتراح تغيير الموعد';

  @override
  String get technicianProposedAppointment => 'اقترح الفني موعداً جديداً';

  @override
  String get tenant => 'المستأجر';

  @override
  String get administrator => 'المسؤول';

  @override
  String get approved => 'تمت الموافقة';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get rejectNewTime => 'رفض الموعد الجديد';

  @override
  String get approveNewTime => 'الموافقة على الموعد الجديد';

  @override
  String get appointmentUnchangedUntilBothApprove =>
      'يبقى الموعد الحالي كما هو حتى يوافق المستأجر والمسؤول.';

  @override
  String get confirmWorkAndClose => 'تأكيد العمل وإغلاق الطلب';

  @override
  String get reopenRequest => 'إعادة فتح الطلب';

  @override
  String get reopenWindowExpired => 'انتهت مهلة إعادة الفتح البالغة 24 ساعة.';

  @override
  String get tenantConfirmationClosesRequest =>
      'يغلق المستأجر الطلب بعد تأكيد الإصلاح.';

  @override
  String get acceptAssignment => 'قبول المهمة';

  @override
  String get startWork => 'بدء العمل';

  @override
  String get proposeNewTime => 'اقتراح موعد جديد';

  @override
  String get markWorkComplete => 'تحديد العمل كمكتمل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get request => 'الطلب';

  @override
  String couldNotLoadProfile(String error) {
    return 'تعذر تحميل الملف: $error';
  }

  @override
  String get tenantDetails => 'بيانات المستأجر';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emiratesId => 'الهوية الإماراتية';

  @override
  String get apartmentDetails => 'بيانات الشقة';

  @override
  String get towerNumber => 'رقم البرج';

  @override
  String get floor => 'الطابق';

  @override
  String get address => 'العنوان';

  @override
  String get tenancyDetails => 'بيانات الإيجار';

  @override
  String get tenancyStart => 'بداية الإيجار';

  @override
  String get tenancyEnd => 'نهاية الإيجار';

  @override
  String get annualRent => 'الإيجار السنوي';

  @override
  String get paymentFrequency => 'دورية الدفع';

  @override
  String get securityDeposit => 'مبلغ التأمين';

  @override
  String get contractDetails => 'بيانات العقد';

  @override
  String get contractNumber => 'رقم العقد';

  @override
  String get landlord => 'المالك / مدير العقار';

  @override
  String get contractIssued => 'تاريخ إصدار العقد';

  @override
  String get contractExpires => 'تاريخ انتهاء العقد';

  @override
  String get closedCases => 'الحالات المغلقة';

  @override
  String couldNotLoadClosedCases(String error) {
    return 'تعذر تحميل الحالات المغلقة: $error';
  }

  @override
  String get raisedOn => 'تاريخ الطلب';

  @override
  String get approvedByManager => 'اعتمده المدير';

  @override
  String get technicianName => 'الفني';

  @override
  String get appointment => 'الموعد';

  @override
  String get fixDate => 'تاريخ الإصلاح';

  @override
  String get closingComments => 'ملاحظات الإغلاق';

  @override
  String get assignedTechnician => 'الفني المعيّن';

  @override
  String couldNotLoadMoveOut(String error) {
    return 'تعذر تحميل طلب الإخلاء: $error';
  }

  @override
  String get chooseMoveOutDate => 'اختر تاريخ الإخلاء';

  @override
  String get moveOutDate => 'تاريخ الإخلاء';

  @override
  String get moveOutDateRequired => 'اختر تاريخ الإخلاء.';

  @override
  String get moveOutReason => 'السبب';

  @override
  String get moveOutReasonRequired => 'أدخل سبب الإخلاء.';

  @override
  String get contactNumber => 'رقم التواصل';

  @override
  String get forwardingAddress => 'عنوان المراسلة';

  @override
  String get forwardingAddressRequired => 'أدخل عنوان المراسلة.';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get submitMoveOutRequest => 'إرسال طلب الإخلاء';

  @override
  String get moveOutSubmittedTitle => 'طلب الإخلاء الخاص بك';

  @override
  String get moveOutStatusReview => 'قيد المراجعة';

  @override
  String get moveOutStatusInspectionScheduled => 'تم تحديد موعد المعاينة';

  @override
  String get moveOutStatusInspectionCompleted => 'اكتملت المعاينة';

  @override
  String get moveOutStatusApproved => 'تمت الموافقة';

  @override
  String get moveOutStatusClosed => 'مغلق';

  @override
  String couldNotLoadRequests(String error) {
    return 'تعذر تحميل الطلبات: $error';
  }

  @override
  String get noRequestsYet => 'لا توجد طلبات خدمة حتى الآن.';

  @override
  String get requestDetails => 'تفاصيل الطلب';

  @override
  String get requestNotFound => 'لم يتم العثور على الطلب.';

  @override
  String couldNotLoadRequest(String error) {
    return 'تعذر تحميل الطلب: $error';
  }

  @override
  String get requestStatus => 'حالة الطلب';

  @override
  String get statusSavedOnDevice =>
      'الحالة المعروضة هي أحدث معلومات محفوظة على هذا الجهاز.';

  @override
  String get statusSubmitted => 'تم الإرسال';

  @override
  String get statusAccepted => 'تم القبول';

  @override
  String get statusAssigned => 'تم التعيين';

  @override
  String get statusAppointmentScheduled => 'تم تحديد موعد';

  @override
  String get statusInProgress => 'قيد التنفيذ';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusRejected => 'مرفوض';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get clearFilters => 'مسح عوامل التصفية';

  @override
  String get filterCategory => 'الفئة';

  @override
  String get allCategories => 'كل الفئات';

  @override
  String get filterStatus => 'الحالة';

  @override
  String get allStatuses => 'كل الحالات';

  @override
  String get filterDateRange => 'التصفية حسب نطاق التاريخ';

  @override
  String couldNotLoadHistory(String error) {
    return 'تعذر تحميل سجل الخدمات: $error';
  }

  @override
  String get noServiceHistory => 'لا يوجد سجل خدمات حتى الآن.';

  @override
  String get noMatchingRequests => 'لا توجد طلبات تطابق عوامل التصفية.';

  @override
  String get costNotRecorded => 'التكلفة غير مسجلة';

  @override
  String recordedCost(String cost) {
    return 'التكلفة: $cost';
  }

  @override
  String get selectLanguage => 'اللغة';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';
}
