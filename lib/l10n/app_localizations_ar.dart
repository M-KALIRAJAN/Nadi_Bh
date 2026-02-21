// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get about => 'حول';

  @override
  String get skip => 'تخطي';

  @override
  String get nadiBahrainServices => 'خدمات نادي البحرين';

  @override
  String get welcome => 'مرحبا!';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get signInWithOtp => 'تسجيل الدخول باستخدام OTP';

  @override
  String get signUp => 'تسجيل';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get or => 'أو';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get enterEmail => 'أدخل البريد الإلكتروني';

  @override
  String get sendEmail => 'إرسال البريد الإلكتروني';

  @override
  String get emailSentMessage => 'تم إرسال البريد الإلكتروني بنجاح';

  @override
  String get enterVerificationCode => 'أدخل رمز التحقق';

  @override
  String get otpSentMessage => 'لقد أرسلنا لك رمز تحقق مكون من 4 أرقام على';

  @override
  String get resendOtp => 'إعادة إرسال OTP';

  @override
  String resendOtpIn(Object seconds) {
    return 'إعادة إرسال OTP خلال 00:$seconds';
  }

  @override
  String get otpSignIn => 'تسجيل الدخول';

  @override
  String get enter4DigitOtp => 'الرجاء إدخال رمز OTP المكون من 4 أرقام';

  @override
  String get accountTypeTitle => 'نوع الحساب';

  @override
  String get individualAccount => 'حساب فردي';

  @override
  String get individualAccountDesc => 'إدارة خدماتك وملفك الشخصي بشكل مستقل.';

  @override
  String get familyAccount => 'حساب عائلي';

  @override
  String get familyAccountDesc =>
      'تسجيل وإدارة الخدمات لأعضاء العائلة المتعددين.';

  @override
  String get signUpTitle => 'سجل';

  @override
  String get accountVerificationTitle =>
      'قم بتأمين حسابك من خلال التحقق من الهوية';

  @override
  String get accountVerificationDesc1 =>
      'لضمان أعلى مستوى من الأمان والثقة داخل مجتمع Service Connect، نطلب من جميع المستخدمين إكمال عملية تحقق بسيطة من الهوية. هذا يساعد على الحماية من الاحتيال والحفاظ على بيئة آمنة للجميع.';

  @override
  String get accountVerificationDesc2 =>
      'نحن نقدر سلامتك وخصوصيتك. تتم معالجة معلوماتك بأمان وتستخدم فقط لأغراض التحقق.';

  @override
  String get continueButton => 'استمر';

  @override
  String get enterPhoneNumber => 'أدخل رقم الهاتف';

  @override
  String get pleaseEnterPhoneNumber => 'يرجى إدخال رقم الهاتف';

  @override
  String get phoneMustBe8Digits => 'يجب أن يتكون رقم الهاتف من 8 أرقام';

  @override
  String get sendOtp => 'إرسال رمز OTP';

  @override
  String get enterOtp => 'أدخل رمز OTP';

  @override
  String get enterValidOtp => 'أدخل رمز OTP صحيح';

  @override
  String get enterFullName => 'أدخل الاسم الكامل*';

  @override
  String get gender => 'الجنس*';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get createPassword => 'إنشاء كلمة المرور*';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور*';

  @override
  String get pleaseSelectRelationship => 'يرجى اختيار العلاقة';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get pickLocation => 'اختر الموقع';

  @override
  String get enterNumberOfKids => 'أدخل عدد الأطفال*';

  @override
  String get noOfBoys => 'عدد الأولاد*';

  @override
  String get noOfGirls => 'عدد البنات*';

  @override
  String get flat => 'شقة';

  @override
  String get villa => 'فيلا';

  @override
  String get office => 'مكتب';

  @override
  String get enterCity => 'أدخل مدينتك/منطقتك';

  @override
  String get enterBuilding => 'أدخل المبنى*';

  @override
  String get enterAptNo => 'أدخل رقم الشقة*';

  @override
  String get enterFloorNo => 'أدخل رقم الطابق*';

  @override
  String get selectBlock => 'اختر البلوك*';

  @override
  String get selectRoad => 'اختر الطريق*';

  @override
  String get pleaseSelectBlock => 'يرجى اختيار البلوك';

  @override
  String get pleaseSelectRoad => 'يرجى اختيار الطريق';

  @override
  String get continueBtn => 'متابعة';

  @override
  String get accountCreatedSuccessfully => 'تم إنشاء الحساب بنجاح';

  @override
  String get submitFailed => 'فشل الإرسال';

  @override
  String get failedToLoadBlocks => 'فشل تحميل البلوكات';

  @override
  String addMemberTitle(Object accountType, Object current, Object total) {
    return 'إضافة عضو $accountType $current من $total';
  }

  @override
  String get enterFamilyCount => 'أدخل عدد أفراد العائلة*';

  @override
  String get addMemberBtn => 'إضافة عضو';

  @override
  String get memberFullName => 'الاسم الكامل للعضو*';

  @override
  String get relationship => 'العلاقة*';

  @override
  String get selectRelationship => 'اختر العلاقة';

  @override
  String get selectGender => 'اختر الجنس';

  @override
  String get hideAddress => 'إخفاء العنوان';

  @override
  String get addAddress => 'إضافة عنوان';

  @override
  String get finish => 'إنهاء';

  @override
  String get allMembersAdded => 'تمت إضافة جميع الأعضاء بنجاح';

  @override
  String get father => 'الأب';

  @override
  String get mother => 'الأم';

  @override
  String get son => 'الابن';

  @override
  String get daughter => 'الابنة';

  @override
  String get addOther => 'إضافة أخرى';

  @override
  String get uploadIdTitle => 'تحميل بطاقة الهوية';

  @override
  String get uploadIdFrontTitle => 'الجانب الأمامي من بطاقة الهوية';

  @override
  String get uploadIdBackTitle => 'الجانب الخلفي من بطاقة الهوية';

  @override
  String get uploadIdSubtitle =>
      'تأكد من أن الاسم والصورة وتاريخ الانتهاء واضحة.';

  @override
  String get uploadIdError => 'يرجى تحميل كل من الصور الأمامية والخلفية';

  @override
  String get accountCreated => 'تم إنشاء الحساب';

  @override
  String get successfully => 'بنجاح!';

  @override
  String get accountCreatedDesc =>
      'مرحبًا بك في خدمات نادي البحرين. يمكنك الآن تسجيل الدخول إلى حسابك الجديد.';

  @override
  String get termsTitle => 'الشروط والأحكام';

  @override
  String get ourCommitments => 'التزاماتنا تجاهك';

  @override
  String get readFullTerms => 'اقرأ الشروط والأحكام كاملة';

  @override
  String get agreeTerms =>
      'لقد قرأت ووافقت على شروط وأحكام خدمة Connect وسياسة الخصوصية';

  @override
  String get completeRegistration => 'إكمال التسجيل';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navMyRequest => 'طلباتي';

  @override
  String get navLiveChat => 'الدردشة المباشرة';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get tapAgainToExit => 'اضغط مرة أخرى للخروج';

  @override
  String get quickAction => 'إجراء سريع';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get serviceOverview => 'نظرة عامة على الخدمة';

  @override
  String get details => 'تفاصيل';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get createRequest => 'إنشاء طلب';

  @override
  String get addPoint => 'إضافة نقطة';

  @override
  String get approvalNeeded => 'الموافقة مطلوبة';

  @override
  String get technicianApprovalMessage =>
      'يريد الفني بدء العمل. يرجى الموافقة.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get youAreAllCaughtUp => 'لقد تم عرض جميع الإشعارات!';

  @override
  String get pointsDetails => 'تفاصيل النقاط';

  @override
  String get yourCurrentPointsBalance => 'رصيد النقاط الحالي';

  @override
  String get pointsRequests => 'طلبات النقاط:';

  @override
  String get showMore => 'عرض المزيد';

  @override
  String get adminRequests => 'طلبات المدير:';

  @override
  String get pointHistory => 'سجل النقاط:';

  @override
  String get noHistoryFound => 'لا يوجد سجل';

  @override
  String get noFamilyPointsFound => 'لا توجد نقاط عائلية';

  @override
  String get familyPoints => 'نقاط العائلة';

  @override
  String get myRecentActivity => 'نشاطي الأخير';

  @override
  String get requestToPoints => 'طلب نقاط';

  @override
  String get admin => 'المدير';

  @override
  String get friend => 'صديق';

  @override
  String get mobileNumber => 'رقم الجوال*';

  @override
  String get mobileNumberRequired => 'رقم الجوال مطلوب';

  @override
  String get enterValidMobile => 'أدخل رقم جوال صحيح';

  @override
  String get enterPoints => 'أدخل النقاط*';

  @override
  String get pointsRequired => 'النقاط مطلوبة';

  @override
  String get enterValidPoints => 'أدخل نقاط صحيحة';

  @override
  String get positiveIntegerHint => 'أدخل قيمة رقمية موجبة للنقاط.';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get notesHint => 'لطلب خدمة جديدة.';

  @override
  String get submit => 'إرسال';

  @override
  String get pointsRequestSuccess => 'تم إرسال طلب النقاط بنجاح';

  @override
  String get selectServiceIssue => 'يرجى اختيار الخدمة والمشكلة';

  @override
  String get createServiceRequest => 'إنشاء طلب خدمة';

  @override
  String get serviceCategory => 'فئة الخدمة';

  @override
  String get selectServices => 'اختر الخدمة*';

  @override
  String get servicePointsRequired => 'النقاط المطلوبة للخدمة';

  @override
  String get serviceFree => 'الخدمة مجانية';

  @override
  String pointsLabel(Object points) {
    return '$points نقطة';
  }

  @override
  String get issueDetails => 'تفاصيل المشكلة';

  @override
  String get selectIssue => 'اختر المشكلة*';

  @override
  String get describeIssue => 'صف مشكلتك…';

  @override
  String get mediaUploadOptional => 'تحميل الوسائط (اختياري)';

  @override
  String imagesSelectedCount(Object count) {
    return '$count / 10 صور مختارة';
  }

  @override
  String get sendRequest => 'إرسال الطلب';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String requestIdLabel(Object id) {
    return 'رقم الطلب: $id';
  }

  @override
  String get requestSuccessTitle => 'تم إرسال طلب الخدمة بنجاح.';

  @override
  String get requestSuccessDesc =>
      'تم استلام رقم الطلب الخاص بك وهو قيد المعالجة';

  @override
  String get viewMyRequest => 'عرض طلباتي';

  @override
  String get myServiceRequest => 'طلباتي للخدمات';

  @override
  String get noRequestFound => 'لا توجد طلبات';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get total => 'الإجمالي';

  @override
  String get serviceRequestDetails => 'تفاصيل طلب الخدمة';

  @override
  String get complaintDetails => 'تفاصيل الشكوى';

  @override
  String get feedback => 'الملاحظات';

  @override
  String get requestSubmitted => 'تم إرسال الطلب';

  @override
  String get requestSubmittedDesc => 'تم إرسال طلب الخدمة بنجاح.';

  @override
  String get adminProcessing => 'المشرف يعالج الطلب';

  @override
  String get adminProcessingDesc => 'يقوم فريق نادي بمراجعة تفاصيل طلبك.';

  @override
  String get technicianAssigned => 'تم تعيين الفني';

  @override
  String get technicianAssignedDesc => 'تم تعيين فني لطلبك.';

  @override
  String get serviceInProgress => 'الخدمة قيد التنفيذ';

  @override
  String get serviceInProgressDesc => 'الفني يعمل على خدمتك';

  @override
  String get paymentInProgress => 'الدفع قيد التنفيذ';

  @override
  String get paymentInProgressDesc => 'في انتظار تأكيد الدفع.';

  @override
  String get serviceCompleted => 'اكتملت الخدمة';

  @override
  String get serviceCompletedDesc => 'تم إكمال الخدمة بنجاح.';

  @override
  String get submitted => 'تم الإرسال';

  @override
  String get accepted => 'تم القبول';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get paymentPending => 'بانتظار الدفع';

  @override
  String get completed => 'مكتمل';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get close => 'إغلاق';

  @override
  String get toPay => 'المبلغ المطلوب';

  @override
  String get profileDetails => 'تفاصيل الملف الشخصي';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get noProfileData => 'لا توجد بيانات';

  @override
  String get errorLoadingProfile => 'خطأ في تحميل الملف';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get building => 'المبنى';

  @override
  String get city => 'المدينة';

  @override
  String get floor => 'الطابق';

  @override
  String get apartment => 'الشقة';

  @override
  String get additionalInfo => 'معلومات إضافية';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get settings => 'الإعدادات';

  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get notification => 'الإشعارات';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get history => 'السجل';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get theme => 'المظهر';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get accountDelete => 'حذف الحساب';

  @override
  String get helpSupportTitle => 'المساعدة والدعم';

  @override
  String get sendEnquiry => 'أرسل لنا استفسار';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get messageLabel => 'الرسالة';

  @override
  String get submitButton => 'إرسال';

  @override
  String get nameValidation => 'الرجاء إدخال الاسم';

  @override
  String get emailValidation => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get emailInvalid => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get messageValidation => 'الرجاء إدخال الرسالة';

  @override
  String get enquirySuccess => 'تم إرسال الاستفسار بنجاح!';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get phoneValidation => 'الرجاء إدخال رقم الهاتف';

  @override
  String get deleteAccountTitle => 'حذف الحساب';

  @override
  String get deleteAccountDescription => 'حدد سببًا قبل حذف حسابك:';

  @override
  String get delete => 'حذف';

  @override
  String get pleaseSelectReason => 'يرجى اختيار سبب';
}
