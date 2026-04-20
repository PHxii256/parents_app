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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Be At Ease.'**
  String get appTagline;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @locationsTab.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locationsTab;

  /// No description provided for @notificationsTab.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @returnAndEdit.
  ///
  /// In en, this message translates to:
  /// **'Return and edit'**
  String get returnAndEdit;

  /// No description provided for @requestSummaryFor.
  ///
  /// In en, this message translates to:
  /// **'Request summary for'**
  String get requestSummaryFor;

  /// No description provided for @requestConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Confirmed'**
  String get requestConfirmedTitle;

  /// No description provided for @lastRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Last Request'**
  String get lastRequestTitle;

  /// No description provided for @undoLastRequest.
  ///
  /// In en, this message translates to:
  /// **'Undo Last Request'**
  String get undoLastRequest;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get switchLanguage;

  /// No description provided for @languagePair.
  ///
  /// In en, this message translates to:
  /// **'English / Arabic'**
  String get languagePair;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @forgotPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password? '**
  String get forgotPasswordPrompt;

  /// No description provided for @resetAction.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetAction;

  /// No description provided for @verificationCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCodeTitle;

  /// No description provided for @sentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Sent to: {email}'**
  String sentToEmail(Object email);

  /// No description provided for @otpCodeSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Code sent! Check your email.'**
  String get otpCodeSentSuccess;

  /// No description provided for @otpDidNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive a code? '**
  String get otpDidNotReceiveCode;

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get otpResend;

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {time}'**
  String otpResendIn(Object time);

  /// No description provided for @otpWrongCodeTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Wrong code, try again'**
  String get otpWrongCodeTryAgain;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password below.'**
  String get resetPasswordSubtitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// No description provided for @validationFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get validationFillAllFields;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get validationPasswordMinLength;

  /// No description provided for @validationPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validationPasswordsDoNotMatch;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get passwordResetSuccess;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActionsTitle;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @studentSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search students by name'**
  String get studentSearchHint;

  /// No description provided for @pinCodes.
  ///
  /// In en, this message translates to:
  /// **'PIN codes'**
  String get pinCodes;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @comingToday.
  ///
  /// In en, this message translates to:
  /// **'Coming Today'**
  String get comingToday;

  /// No description provided for @selectAMessage.
  ///
  /// In en, this message translates to:
  /// **'Select a Message'**
  String get selectAMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @noNewMessages.
  ///
  /// In en, this message translates to:
  /// **'No new messages'**
  String get noNewMessages;

  /// No description provided for @viewInGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'View in Google Maps'**
  String get viewInGoogleMaps;

  /// No description provided for @gradeWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Grade {number}'**
  String gradeWithNumber(Object number);

  /// No description provided for @messageIHaveArrived.
  ///
  /// In en, this message translates to:
  /// **'I Have arrived'**
  String get messageIHaveArrived;

  /// No description provided for @messagePleaseHurryUp.
  ///
  /// In en, this message translates to:
  /// **'Please Hurry Up'**
  String get messagePleaseHurryUp;

  /// No description provided for @messagePleaseBeReadyAtPickupPoint.
  ///
  /// In en, this message translates to:
  /// **'Please be ready at pickup point'**
  String get messagePleaseBeReadyAtPickupPoint;

  /// No description provided for @messageIHaveLeft.
  ///
  /// In en, this message translates to:
  /// **'I Have Left'**
  String get messageIHaveLeft;

  /// No description provided for @messagePleaseWaitForUsWeAreComing.
  ///
  /// In en, this message translates to:
  /// **'Please wait for us, we are coming'**
  String get messagePleaseWaitForUsWeAreComing;

  /// No description provided for @messageWeAreWaitingAtBusStop.
  ///
  /// In en, this message translates to:
  /// **'We are waiting at the bus stop'**
  String get messageWeAreWaitingAtBusStop;

  /// No description provided for @quickMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick messages'**
  String get quickMessagesTitle;

  /// No description provided for @customMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom message'**
  String get customMessageLabel;

  /// No description provided for @customMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write a specific message'**
  String get customMessageHint;

  /// No description provided for @messageOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get messageOkay;

  /// No description provided for @staffOpenInGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'View In Google Maps'**
  String get staffOpenInGoogleMaps;

  /// No description provided for @staffStartTrip.
  ///
  /// In en, this message translates to:
  /// **'Start Trip'**
  String get staffStartTrip;

  /// No description provided for @staffEndTrip.
  ///
  /// In en, this message translates to:
  /// **'End Trip'**
  String get staffEndTrip;

  /// No description provided for @schoolCampusLabel.
  ///
  /// In en, this message translates to:
  /// **'School Campus'**
  String get schoolCampusLabel;

  /// No description provided for @schoolStopLabel.
  ///
  /// In en, this message translates to:
  /// **'School Stop'**
  String get schoolStopLabel;

  /// No description provided for @locateStudent.
  ///
  /// In en, this message translates to:
  /// **'Find location'**
  String get locateStudent;

  /// No description provided for @studentBoardedBusLabel.
  ///
  /// In en, this message translates to:
  /// **'Boarded Bus'**
  String get studentBoardedBusLabel;

  /// No description provided for @studentDroppedOffLabel.
  ///
  /// In en, this message translates to:
  /// **'Dropped off'**
  String get studentDroppedOffLabel;

  /// No description provided for @statusConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Action'**
  String get statusConfirmTitle;

  /// No description provided for @statusConfirmQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure {studentName} {actionText}?'**
  String statusConfirmQuestion(Object studentName, Object actionText);

  /// No description provided for @statusParentNotificationNotice.
  ///
  /// In en, this message translates to:
  /// **'A notification will be sent to the parent.'**
  String get statusParentNotificationNotice;

  /// No description provided for @statusActionBoardedBusTrue.
  ///
  /// In en, this message translates to:
  /// **'boarded the bus'**
  String get statusActionBoardedBusTrue;

  /// No description provided for @statusActionBoardedBusFalse.
  ///
  /// In en, this message translates to:
  /// **'has not boarded the bus'**
  String get statusActionBoardedBusFalse;

  /// No description provided for @statusActionDroppedOffTrue.
  ///
  /// In en, this message translates to:
  /// **'has been dropped off'**
  String get statusActionDroppedOffTrue;

  /// No description provided for @statusActionDroppedOffFalse.
  ///
  /// In en, this message translates to:
  /// **'has not been dropped off'**
  String get statusActionDroppedOffFalse;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @pinCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Pin Code'**
  String get pinCodeTitle;

  /// No description provided for @absenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Absence'**
  String get absenceTitle;

  /// No description provided for @changePickupDropoff.
  ///
  /// In en, this message translates to:
  /// **'Change Stop Location'**
  String get changePickupDropoff;

  /// No description provided for @tripStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Status'**
  String get tripStatusTitle;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get onTheWay;

  /// No description provided for @noTripCurrently.
  ///
  /// In en, this message translates to:
  /// **'No trip currently'**
  String get noTripCurrently;

  /// No description provided for @youAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re Offline'**
  String get youAreOffline;

  /// No description provided for @tripEtaUnitMin.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get tripEtaUnitMin;

  /// No description provided for @assistantRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'(Assistant)'**
  String get assistantRoleLabel;

  /// No description provided for @driverRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'(Driver)'**
  String get driverRoleLabel;

  /// No description provided for @nextPickup.
  ///
  /// In en, this message translates to:
  /// **'(Next Pickup)'**
  String get nextPickup;

  /// No description provided for @homeAddressName.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeAddressName;

  /// No description provided for @homeAddressDesc.
  ///
  /// In en, this message translates to:
  /// **'123 Maple Street'**
  String get homeAddressDesc;

  /// No description provided for @grandmasHouseName.
  ///
  /// In en, this message translates to:
  /// **'Grandma\'s House'**
  String get grandmasHouseName;

  /// No description provided for @grandmasHouseAddress.
  ///
  /// In en, this message translates to:
  /// **'789 Pine Lane'**
  String get grandmasHouseAddress;

  /// No description provided for @selectChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Select children'**
  String get selectChildrenTitle;

  /// No description provided for @absenceDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Absence date'**
  String get absenceDateTitle;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @specificDate.
  ///
  /// In en, this message translates to:
  /// **'Specific date'**
  String get specificDate;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @markAsAbsentButton.
  ///
  /// In en, this message translates to:
  /// **'Mark as absent'**
  String get markAsAbsentButton;

  /// No description provided for @absenceSuccessfullyMarked.
  ///
  /// In en, this message translates to:
  /// **'Absence successfully marked'**
  String get absenceSuccessfullyMarked;

  /// No description provided for @absenceStudentStatusAbsent.
  ///
  /// In en, this message translates to:
  /// **'Status: Absent'**
  String get absenceStudentStatusAbsent;

  /// No description provided for @absenceStudentStatusPresent.
  ///
  /// In en, this message translates to:
  /// **'Status: Present'**
  String get absenceStudentStatusPresent;

  /// No description provided for @absenceUndoAction.
  ///
  /// In en, this message translates to:
  /// **'Undo Absence'**
  String get absenceUndoAction;

  /// No description provided for @shareChildPinCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your child\'s pin code'**
  String get shareChildPinCodeTitle;

  /// No description provided for @pinCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'This pin code allows you or other people you trust to safely pick up your children by saying this code to the bus driver or assistant.'**
  String get pinCodeDescription;

  /// No description provided for @masterPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Pin'**
  String get masterPinTitle;

  /// No description provided for @masterPinWarning.
  ///
  /// In en, this message translates to:
  /// **'(Do not share with anyone other than bus staff)'**
  String get masterPinWarning;

  /// No description provided for @temporaryPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Temporary Pin'**
  String get temporaryPinTitle;

  /// No description provided for @temporaryPinInfo.
  ///
  /// In en, this message translates to:
  /// **'(This PIN is safe to share and is valid for one day only)'**
  String get temporaryPinInfo;

  /// No description provided for @temporaryPinCopied.
  ///
  /// In en, this message translates to:
  /// **'Temporary PIN copied!'**
  String get temporaryPinCopied;

  /// No description provided for @requestTitle.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get requestTitle;

  /// No description provided for @changeRequestDateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow (Wednesday 16/3)'**
  String get changeRequestDateSubtitle;

  /// No description provided for @pickupLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickupLabel;

  /// No description provided for @dropoffLabel.
  ///
  /// In en, this message translates to:
  /// **'Dropoff'**
  String get dropoffLabel;

  /// No description provided for @savedAddressesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get savedAddressesTitle;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @primaryLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primaryLocationLabel;

  /// No description provided for @editLocations.
  ///
  /// In en, this message translates to:
  /// **'Edit Locations'**
  String get editLocations;

  /// No description provided for @deleteLocation.
  ///
  /// In en, this message translates to:
  /// **'Delete location'**
  String get deleteLocation;

  /// No description provided for @undoAction.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoAction;

  /// No description provided for @locationDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleted {locationName}'**
  String locationDeletedMessage(Object locationName);

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @addLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get addLocationTitle;

  /// No description provided for @addLocationDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Location Details'**
  String get addLocationDetailsTitle;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @locationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Location name is required'**
  String get locationNameRequired;

  /// No description provided for @locationNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Location Name'**
  String get locationNameLabel;

  /// No description provided for @locationNameHint.
  ///
  /// In en, this message translates to:
  /// **'eg. Grandma\'s Home'**
  String get locationNameHint;

  /// No description provided for @addressOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Address (Optional)'**
  String get addressOptionalLabel;

  /// No description provided for @addressOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'eg. Sakanat El-Maadi St.9 Building 31'**
  String get addressOptionalHint;

  /// No description provided for @confirmLocationButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocationButton;

  /// No description provided for @pasteGoogleMapsLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a Google Maps Link'**
  String get pasteGoogleMapsLinkHint;

  /// No description provided for @clipboardEmptyPasteLink.
  ///
  /// In en, this message translates to:
  /// **'Clipboard is empty, please copy a link before pasting'**
  String get clipboardEmptyPasteLink;

  /// No description provided for @gmapsExampleHint.
  ///
  /// In en, this message translates to:
  /// **'(eg. https://maps.app.goo.gl/ydqDZZwsZRaRHWpH7)'**
  String get gmapsExampleHint;

  /// No description provided for @accountInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformationTitle;

  /// No description provided for @yourEnrolledChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Enrolled Children'**
  String get yourEnrolledChildrenTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name: {name}'**
  String nameLabel(Object name);

  /// No description provided for @primaryPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary Phone: {phone}'**
  String primaryPhoneLabel(Object phone);

  /// No description provided for @secondaryPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Secondary Phone: {phone}'**
  String secondaryPhoneLabel(Object phone);

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please turn on the location permission to view the map.'**
  String get locationPermissionRequired;

  /// No description provided for @mapLocationTimeout.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t get your current location currently. please try again later.'**
  String get mapLocationTimeout;

  /// No description provided for @mapLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t determine your current location. The map is centered on a default area.'**
  String get mapLocationUnavailable;

  /// No description provided for @mapLocatingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Getting your location…'**
  String get mapLocatingInProgress;

  /// No description provided for @mapLocationAlreadyLocating.
  ///
  /// In en, this message translates to:
  /// **'Already getting your location. Please wait a moment.'**
  String get mapLocationAlreadyLocating;

  /// No description provided for @openStreetMapContributors.
  ///
  /// In en, this message translates to:
  /// **'OpenStreetMap contributors'**
  String get openStreetMapContributors;

  /// No description provided for @schoolSuffix.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolSuffix;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
