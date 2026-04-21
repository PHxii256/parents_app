// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'Be At Ease.';

  @override
  String get homeTab => 'Home';

  @override
  String get locationsTab => 'Locations';

  @override
  String get notificationsTab => 'Notifications';

  @override
  String get profileTab => 'Profile';

  @override
  String get returnAndEdit => 'Return and edit';

  @override
  String get requestSummaryFor => 'Request summary for';

  @override
  String get requestConfirmedTitle => 'Request Confirmed';

  @override
  String get lastRequestTitle => 'Last Request';

  @override
  String get undoLastRequest => 'Undo Last Request';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get switchLanguage => 'Language';

  @override
  String get languagePair => 'English / Arabic';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get accountTypeLabel => 'Account type';

  @override
  String get accountTypeParentGuardian => 'Parent / Guardian';

  @override
  String get accountTypeDriver => 'Driver';

  @override
  String get accountTypeAssistant => 'Assistant';

  @override
  String get loginButton => 'Login';

  @override
  String get forgotPasswordPrompt => 'Forgot Password? ';

  @override
  String get resetAction => 'Reset';

  @override
  String get verificationCodeTitle => 'Verification Code';

  @override
  String sentToEmail(Object email) {
    return 'Sent to: $email';
  }

  @override
  String get otpCodeSentSuccess => 'Code sent! Check your email.';

  @override
  String get otpDidNotReceiveCode => 'Didn\'t receive a code? ';

  @override
  String get otpResend => 'Resend';

  @override
  String otpResendIn(Object time) {
    return 'Resend in $time';
  }

  @override
  String get otpWrongCodeTryAgain => 'Wrong code, try again';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle => 'Enter your new password below.';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get validationFillAllFields => 'Please fill in all fields.';

  @override
  String get validationPasswordMinLength => 'Password must be at least 6 characters.';

  @override
  String get validationPasswordsDoNotMatch => 'Passwords do not match.';

  @override
  String get passwordResetSuccess => 'Password reset successfully!';

  @override
  String get quickActionsTitle => 'Quick Actions';

  @override
  String get students => 'Students';

  @override
  String get studentSearchHint => 'Search students by name';

  @override
  String get noStudentsAssignedYet => 'No students assigned yet.';

  @override
  String get noStudentsMatchingFilters => 'No students matching selected filters.';

  @override
  String get pinCodes => 'PIN codes';

  @override
  String get status => 'Status';

  @override
  String get comingToday => 'Coming Today';

  @override
  String get selectAMessage => 'Select a Message';

  @override
  String get send => 'Send';

  @override
  String get noNewMessages => 'No new messages';

  @override
  String get viewInGoogleMaps => 'View in Google Maps';

  @override
  String gradeWithNumber(Object number) {
    return 'Grade $number';
  }

  @override
  String get messageIHaveArrived => 'I Have arrived';

  @override
  String get messagePleaseHurryUp => 'Please Hurry Up';

  @override
  String get messagePleaseBeReadyAtPickupPoint => 'Please be ready at pickup point';

  @override
  String get messageIHaveLeft => 'I Have Left';

  @override
  String get messagePleaseWaitForUsWeAreComing => 'Please wait for us, we are coming';

  @override
  String get messageWeAreWaitingAtBusStop => 'We are waiting at the bus stop';

  @override
  String get quickMessagesTitle => 'Quick messages';

  @override
  String get customMessageLabel => 'Custom message';

  @override
  String get customMessageHint => 'Write a specific message';

  @override
  String get messageOkay => 'Okay';

  @override
  String get staffOpenInGoogleMaps => 'View In Google Maps';

  @override
  String get staffStartTrip => 'Start Trip';

  @override
  String get staffEndTrip => 'End Trip';

  @override
  String get tripActionConfirmTitle => 'Confirm Trip Action';

  @override
  String tripActionConfirmBody(Object action) {
    return 'Are you sure you want to $action?';
  }

  @override
  String get schoolCampusLabel => 'School Campus';

  @override
  String get schoolStopLabel => 'School Stop';

  @override
  String get locateStudent => 'Find location';

  @override
  String get studentBoardedBusLabel => 'Boarded Bus';

  @override
  String get studentDroppedOffLabel => 'Dropped off';

  @override
  String get studentsFilterTitle => 'Filter Students';

  @override
  String get studentsFilterClear => 'Clear';

  @override
  String get statusConfirmTitle => 'Confirm Action';

  @override
  String statusConfirmQuestion(Object studentName, Object actionText) {
    return 'Are you sure $studentName $actionText?';
  }

  @override
  String get statusParentNotificationNotice => 'A notification will be sent to the parent.';

  @override
  String get statusActionBoardedBusTrue => 'boarded the bus';

  @override
  String get statusActionBoardedBusFalse => 'has not boarded the bus';

  @override
  String get statusActionDroppedOffTrue => 'has been dropped off';

  @override
  String get statusActionDroppedOffFalse => 'has not been dropped off';

  @override
  String get callContactTitle => 'Call Guardian';

  @override
  String get primaryContactMother => 'Primary Contact (Mother)';

  @override
  String get secondaryContactFather => 'Secondary Contact (Father)';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get pinCodeTitle => 'Pin Code';

  @override
  String get absenceTitle => 'Absence';

  @override
  String get changePickupDropoff => 'Edit Stop Location';

  @override
  String get tripStatusTitle => 'Trip Status';

  @override
  String get onTheWay => 'On the way';

  @override
  String get noTripCurrently => 'No trip currently';

  @override
  String get youAreOffline => 'You\'re Offline';

  @override
  String get tripEtaUnitMin => 'min';

  @override
  String get assistantRoleLabel => '(Assistant)';

  @override
  String get driverRoleLabel => '(Driver)';

  @override
  String get nextPickup => '(Next Pickup)';

  @override
  String get homeAddressName => 'Home';

  @override
  String get homeAddressDesc => '123 Maple Street';

  @override
  String get grandmasHouseName => 'Grandma\'s House';

  @override
  String get grandmasHouseAddress => '789 Pine Lane';

  @override
  String get selectChildrenTitle => 'Select children';

  @override
  String get absenceDateTitle => 'Absence date';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get specificDate => 'Specific date';

  @override
  String get duration => 'Duration';

  @override
  String get markAsAbsentButton => 'Mark as absent';

  @override
  String get absenceSuccessfullyMarked => 'Absence successfully marked';

  @override
  String get absenceStudentStatusAbsent => 'Status: Absent';

  @override
  String get absenceStudentStatusPresent => 'Status: Present';

  @override
  String get absenceUndoAction => 'Undo Absence';

  @override
  String get shareChildPinCodeTitle => 'Share your child\'s pin code';

  @override
  String get pinCodeDescription => 'This pin code allows you or other people you trust to safely pick up your children by saying this code to the bus driver or assistant.';

  @override
  String get masterPinTitle => 'Master Pin';

  @override
  String get masterPinWarning => '(Do not share with anyone other than bus staff)';

  @override
  String get temporaryPinTitle => 'Temporary Pin';

  @override
  String get temporaryPinInfo => '(This PIN is safe to share and is valid for one day only)';

  @override
  String get temporaryPinCopied => 'Temporary PIN copied!';

  @override
  String get requestTitle => 'Request';

  @override
  String get changeRequestDateSubtitle => 'Tomorrow (Wednesday 16/3)';

  @override
  String get pickupLabel => 'Pickup';

  @override
  String get dropoffLabel => 'Dropoff';

  @override
  String get savedAddressesTitle => 'Saved Addresses';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get primaryLocationLabel => 'Primary';

  @override
  String get editLocations => 'Edit Locations';

  @override
  String get deleteLocation => 'Delete location';

  @override
  String get undoAction => 'Undo';

  @override
  String locationDeletedMessage(Object locationName) {
    return 'Deleted $locationName';
  }

  @override
  String get nextButton => 'Next';

  @override
  String get addLocationTitle => 'Add Location';

  @override
  String get addLocationDetailsTitle => 'Add Location Details';

  @override
  String get doneButton => 'Done';

  @override
  String get locationNameRequired => 'Location name is required';

  @override
  String get locationNameLabel => 'Location Name';

  @override
  String get locationNameHint => 'eg. Grandma\'s Home';

  @override
  String get addressOptionalLabel => 'Address (Optional)';

  @override
  String get addressOptionalHint => 'eg. Sakanat El-Maadi St.9 Building 31';

  @override
  String get confirmLocationButton => 'Confirm Location';

  @override
  String get pasteGoogleMapsLinkHint => 'Paste a Google Maps Link';

  @override
  String get clipboardEmptyPasteLink => 'Clipboard is empty, please copy a link before pasting';

  @override
  String get gmapsExampleHint => '(eg. https://maps.app.goo.gl/ydqDZZwsZRaRHWpH7)';

  @override
  String get accountInformationTitle => 'Account Information';

  @override
  String get yourEnrolledChildrenTitle => 'Your Enrolled Children';

  @override
  String get profileLoadError => 'Unable to load profile.';

  @override
  String get profileNameLabel => 'Name';

  @override
  String get profilePrimaryPhoneLabel => 'Primary Phone no.';

  @override
  String get profileSecondaryPhoneLabel => 'Secondary Phone no.';

  @override
  String nameLabel(Object name) {
    return 'Name: $name';
  }

  @override
  String primaryPhoneLabel(Object phone) {
    return 'Primary Phone: $phone';
  }

  @override
  String secondaryPhoneLabel(Object phone) {
    return 'Secondary Phone: $phone';
  }

  @override
  String get locationServicesDisabled => 'Location services are disabled.';

  @override
  String get locationPermissionDenied => 'Location permission denied.';

  @override
  String get locationPermissionRequired => 'Please turn on the location permission to view the map.';

  @override
  String get mapLocationTimeout => 'Couldn’t get your current location currently. please try again later.';

  @override
  String get mapLocationUnavailable => 'Couldn’t determine your current location. The map is centered on a default area.';

  @override
  String get mapLocatingInProgress => 'Getting your location…';

  @override
  String get mapLocationAlreadyLocating => 'Already getting your location. Please wait a moment.';

  @override
  String get mapPermissionPromptTitle => 'Location access required';

  @override
  String get mapPermissionPromptBody => 'To focus on your live location, please enable location services/permission in settings.';

  @override
  String get mapOpenSettingsButton => 'Open settings';

  @override
  String get invalidGoogleMapsLink => 'Couldn’t parse this Google Maps link. Please try another link.';

  @override
  String get noNotificationsYet => 'No notifications yet.';

  @override
  String get openStreetMapContributors => 'OpenStreetMap contributors';

  @override
  String get schoolSuffix => 'School';
}
