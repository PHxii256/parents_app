// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTagline => 'خليك مطمن.';

  @override
  String get homeTab => 'الرئيسية';

  @override
  String get locationsTab => 'الأماكن';

  @override
  String get notificationsTab => 'الإشعارات';

  @override
  String get profileTab => 'الملف الشخصي';

  @override
  String get returnAndEdit => 'العودة والتعديل';

  @override
  String get requestSummaryFor => 'ملخص الطلب لـ';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get switchLanguage => 'تبديل اللغة';

  @override
  String get languagePair => 'الإنجليزي/العربية';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get forgotPasswordPrompt => 'هل نسيت كلمة المرور؟ ';

  @override
  String get resetAction => 'نغير';

  @override
  String get verificationCodeTitle => 'رمز التحقق';

  @override
  String sentToEmail(Object email) {
    return 'تم الإرسال إلى: $email';
  }

  @override
  String get otpCodeSentSuccess => 'تم إرسال الرمز! تحقق من بريدك الإلكتروني.';

  @override
  String get otpDidNotReceiveCode => 'لم يصلك رمز؟ ';

  @override
  String get otpResend => 'إعادة الإرسال';

  @override
  String otpResendIn(Object time) {
    return 'إعادة الإرسال خلال $time';
  }

  @override
  String get otpWrongCodeTryAgain => 'رمز غير صحيح، حاول مرة أخرى';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordSubtitle => 'أدخل كلمة المرور الجديدة .';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get resetPasswordButton => 'إعادة تعيين كلمة المرور';

  @override
  String get validationFillAllFields => 'يرجى ملء جميع الحقول.';

  @override
  String get validationPasswordMinLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل.';

  @override
  String get validationPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get passwordResetSuccess => 'تمت إعادة تعيين كلمة المرور بنجاح!';

  @override
  String get quickActionsTitle => 'إجراءات سريعة';

  @override
  String get staffOpenInGoogleMaps => 'عرض في خرائط جوجل';

  @override
  String get staffEndTrip => 'إنهاء الرحلة';

  @override
  String get studentBoardedBusLabel => 'ركب الأتوبيس';

  @override
  String get studentDroppedOffLabel => 'تم توصيله';

  @override
  String get statusConfirmTitle => 'تأكيد الإجراء';

  @override
  String statusConfirmQuestion(Object studentName, Object actionText) {
    return 'هل أنت متأكد أن $studentName $actionText؟';
  }

  @override
  String get statusParentNotificationNotice => 'سيتم إرسال إشعار إلى ولي الأمر.';

  @override
  String get statusActionBoardedBusTrue => 'ركب الأتوبيس';

  @override
  String get statusActionBoardedBusFalse => 'لم يركب الأتوبيس';

  @override
  String get statusActionDroppedOffTrue => 'تم توصيله';

  @override
  String get statusActionDroppedOffFalse => 'لم يتم توصيله';

  @override
  String get commonYes => 'نعم';

  @override
  String get commonNo => 'لا';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get pinCodeTitle => 'رمز PIN';

  @override
  String get absenceTitle => 'الغياب';

  @override
  String get changePickupDropoff => 'تغيير نقطة الركوب/النزول';

  @override
  String get tripStatusTitle => 'حالة الرحلة';

  @override
  String get onTheWay => 'في الطريق';

  @override
  String get noTripCurrently => 'لا توجد رحلة حالياً';

  @override
  String get youAreOffline => 'أنت غير متصل';

  @override
  String get tripEtaUnitMin => 'د';

  @override
  String get assistantRoleLabel => '(المشرفة)';

  @override
  String get driverRoleLabel => '(السائق)';

  @override
  String get nextPickup => '(الركوب التالي)';

  @override
  String get homeAddressName => 'المنزل';

  @override
  String get homeAddressDesc => '123 شارع مابل';

  @override
  String get grandmasHouseName => 'منزل الجدة';

  @override
  String get grandmasHouseAddress => '789 شارع باين';

  @override
  String get selectChildrenTitle => 'اختر الأطفال';

  @override
  String get absenceDateTitle => 'تاريخ الغياب';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get sunday => 'الأحد';

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'غداً';

  @override
  String get specificDate => 'تاريخ محدد';

  @override
  String get duration => 'المدة';

  @override
  String get markAsAbsentButton => 'تحديد كغياب';

  @override
  String get shareChildPinCodeTitle => 'شارك رمز PIN لطفلك';

  @override
  String get pinCodeDescription => 'يتيح لك هذا الرمز أو للأشخاص الذين تثق بهم استلام أطفالك بأمان عبر قول هذا الرمز لسائق الحافلة أو المشرف.';

  @override
  String get masterPinTitle => 'رمز PIN الرئيسي';

  @override
  String get masterPinWarning => '(لا تشاركه مع أي شخص غير طاقم الحافلة)';

  @override
  String get temporaryPinTitle => 'رمز PIN مؤقت';

  @override
  String get temporaryPinInfo => '(هذا الرمز آمن للمشاركة وصالح ليوم واحد فقط)';

  @override
  String get temporaryPinCopied => 'تم نسخ الرمز المؤقت!';

  @override
  String get requestTitle => 'طلب';

  @override
  String get changePickupDropoffFor => 'تغيير نقطة الركوب أو النزول لـ';

  @override
  String get changeRequestDateSubtitle => 'غداً (الأربعاء 16/3)';

  @override
  String get pickupLabel => 'الركوب';

  @override
  String get dropoffLabel => 'النزول';

  @override
  String get savedAddressesTitle => 'العناوين المحفوظة';

  @override
  String get addNewAddress => 'إضافة عنوان جديد';

  @override
  String get nextButton => 'التالي';

  @override
  String get addLocationTitle => 'إضافة موقع';

  @override
  String get addLocationDetailsTitle => 'إضافة تفاصيل الموقع';

  @override
  String get doneButton => 'تم';

  @override
  String get locationNameRequired => 'اسم الموقع مطلوب';

  @override
  String get locationNameLabel => 'اسم الموقع';

  @override
  String get locationNameHint => 'مثال: منزل الجدة';

  @override
  String get addressOptionalLabel => 'العنوان (اختياري)';

  @override
  String get addressOptionalHint => 'مثال: سكنات المعادي شارع 9 عمارة 31';

  @override
  String get confirmLocationButton => 'تأكيد الموقع';

  @override
  String get pasteGoogleMapsLinkHint => 'الصق رابط خرائط جوجل';

  @override
  String get clipboardEmptyPasteLink => 'الحافظة فارغة، يرجى نسخ رابط قبل اللصق';

  @override
  String get gmapsExampleHint => '(مثال: https://maps.app.goo.gl/ydqDZZwsZRaRHWpH7)';

  @override
  String get accountInformationTitle => 'معلومات الحساب';

  @override
  String get yourEnrolledChildrenTitle => 'الأطفال المسجلون لديك';

  @override
  String nameLabel(Object name) {
    return 'الاسم: $name';
  }

  @override
  String primaryPhoneLabel(Object phone) {
    return 'الهاتف الأساسي: $phone';
  }

  @override
  String secondaryPhoneLabel(Object phone) {
    return 'الهاتف الثانوي: $phone';
  }

  @override
  String get locationServicesDisabled => 'خدمات الموقع غير مفعلة.';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الموقع.';

  @override
  String get locationPermissionRequired => 'يرجى تفعيل إذن الموقع لعرض الخريطة.';

  @override
  String get openStreetMapContributors => 'مساهمو OpenStreetMap';
}
