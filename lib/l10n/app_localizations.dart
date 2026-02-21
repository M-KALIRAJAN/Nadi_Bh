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

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @nadiBahrainServices.
  ///
  /// In en, this message translates to:
  /// **'Nadi Bahrain Services'**
  String get nadiBahrainServices;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signInWithOtp.
  ///
  /// In en, this message translates to:
  /// **'Sign In with OTP'**
  String get signInWithOtp;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change your Password'**
  String get changePassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @emailSentMessage.
  ///
  /// In en, this message translates to:
  /// **'Email sent successfully'**
  String get emailSentMessage;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification code'**
  String get enterVerificationCode;

  /// No description provided for @otpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We have sent you a 4 digit verification code on'**
  String get otpSentMessage;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in 00:{seconds}'**
  String resendOtpIn(Object seconds);

  /// No description provided for @otpSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get otpSignIn;

  /// No description provided for @enter4DigitOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter 4 digit OTP'**
  String get enter4DigitOtp;

  /// No description provided for @accountTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountTypeTitle;

  /// No description provided for @individualAccount.
  ///
  /// In en, this message translates to:
  /// **'Individual Account'**
  String get individualAccount;

  /// No description provided for @individualAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your services and profile independently.'**
  String get individualAccountDesc;

  /// No description provided for @familyAccount.
  ///
  /// In en, this message translates to:
  /// **'Family Account'**
  String get familyAccount;

  /// No description provided for @familyAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Register and manage services for multiple family members.'**
  String get familyAccountDesc;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpTitle;

  /// No description provided for @accountVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure Your Account With ID Verification'**
  String get accountVerificationTitle;

  /// No description provided for @accountVerificationDesc1.
  ///
  /// In en, this message translates to:
  /// **'To ensure the highest level of security and trust within the Service Connect community, we require all users to complete a simple identity verification process. This helps protect against fraud and maintain a safe environment for everyone.'**
  String get accountVerificationDesc1;

  /// No description provided for @accountVerificationDesc2.
  ///
  /// In en, this message translates to:
  /// **'We value your safety and privacy. Your information is securely processed and used only for verification purposes.'**
  String get accountVerificationDesc2;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhoneNumber;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @phoneMustBe8Digits.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 8 digits'**
  String get phoneMustBe8Digits;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @enterValidOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter valid OTP'**
  String get enterValidOtp;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter Full Name*'**
  String get enterFullName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender*'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password*'**
  String get createPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password*'**
  String get confirmPassword;

  /// No description provided for @pleaseSelectRelationship.
  ///
  /// In en, this message translates to:
  /// **'Please select relationship'**
  String get pleaseSelectRelationship;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @pickLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick Location'**
  String get pickLocation;

  /// No description provided for @enterNumberOfKids.
  ///
  /// In en, this message translates to:
  /// **'Enter Number of kids*'**
  String get enterNumberOfKids;

  /// No description provided for @noOfBoys.
  ///
  /// In en, this message translates to:
  /// **'No of boys*'**
  String get noOfBoys;

  /// No description provided for @noOfGirls.
  ///
  /// In en, this message translates to:
  /// **'No of girls*'**
  String get noOfGirls;

  /// No description provided for @flat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get flat;

  /// No description provided for @villa.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get villa;

  /// No description provided for @office.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get office;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter Your city/Area'**
  String get enterCity;

  /// No description provided for @enterBuilding.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Building*'**
  String get enterBuilding;

  /// No description provided for @enterAptNo.
  ///
  /// In en, this message translates to:
  /// **'Enter Apt No*'**
  String get enterAptNo;

  /// No description provided for @enterFloorNo.
  ///
  /// In en, this message translates to:
  /// **'Enter Floor No*'**
  String get enterFloorNo;

  /// No description provided for @selectBlock.
  ///
  /// In en, this message translates to:
  /// **'Select Your Block*'**
  String get selectBlock;

  /// No description provided for @selectRoad.
  ///
  /// In en, this message translates to:
  /// **'Select Your Road*'**
  String get selectRoad;

  /// No description provided for @pleaseSelectBlock.
  ///
  /// In en, this message translates to:
  /// **'Please select a block'**
  String get pleaseSelectBlock;

  /// No description provided for @pleaseSelectRoad.
  ///
  /// In en, this message translates to:
  /// **'Please select a road'**
  String get pleaseSelectRoad;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreatedSuccessfully;

  /// No description provided for @submitFailed.
  ///
  /// In en, this message translates to:
  /// **'Submit failed'**
  String get submitFailed;

  /// No description provided for @failedToLoadBlocks.
  ///
  /// In en, this message translates to:
  /// **'Failed to load blocks'**
  String get failedToLoadBlocks;

  /// No description provided for @addMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {accountType} Member {current} of {total}'**
  String addMemberTitle(Object accountType, Object current, Object total);

  /// No description provided for @enterFamilyCount.
  ///
  /// In en, this message translates to:
  /// **'Enter Family Count*'**
  String get enterFamilyCount;

  /// No description provided for @addMemberBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMemberBtn;

  /// No description provided for @memberFullName.
  ///
  /// In en, this message translates to:
  /// **'Member Full Name*'**
  String get memberFullName;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship*'**
  String get relationship;

  /// No description provided for @selectRelationship.
  ///
  /// In en, this message translates to:
  /// **'Select relationship'**
  String get selectRelationship;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get selectGender;

  /// No description provided for @hideAddress.
  ///
  /// In en, this message translates to:
  /// **'Hide Address'**
  String get hideAddress;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @allMembersAdded.
  ///
  /// In en, this message translates to:
  /// **'All members added successfully'**
  String get allMembersAdded;

  /// No description provided for @father.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get father;

  /// No description provided for @mother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get mother;

  /// No description provided for @son.
  ///
  /// In en, this message translates to:
  /// **'Son'**
  String get son;

  /// No description provided for @daughter.
  ///
  /// In en, this message translates to:
  /// **'Daughter'**
  String get daughter;

  /// No description provided for @addOther.
  ///
  /// In en, this message translates to:
  /// **'Add Other'**
  String get addOther;

  /// No description provided for @uploadIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload ID Card'**
  String get uploadIdTitle;

  /// No description provided for @uploadIdFrontTitle.
  ///
  /// In en, this message translates to:
  /// **'Front Side of ID Card'**
  String get uploadIdFrontTitle;

  /// No description provided for @uploadIdBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Back Side of ID Card'**
  String get uploadIdBackTitle;

  /// No description provided for @uploadIdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ensure your name, photo, and expiry date are clearly visible.'**
  String get uploadIdSubtitle;

  /// No description provided for @uploadIdError.
  ///
  /// In en, this message translates to:
  /// **'Please upload both front and back images'**
  String get uploadIdError;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account Created'**
  String get accountCreated;

  /// No description provided for @successfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully!'**
  String get successfully;

  /// No description provided for @accountCreatedDesc.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Nadi Bahrain Services. You can now sign in to your new account.'**
  String get accountCreatedDesc;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsTitle;

  /// No description provided for @ourCommitments.
  ///
  /// In en, this message translates to:
  /// **'Our Commitments To You'**
  String get ourCommitments;

  /// No description provided for @readFullTerms.
  ///
  /// In en, this message translates to:
  /// **'Read the full Terms & Conditions'**
  String get readFullTerms;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Service Connect Terms & Conditions and Privacy Policy'**
  String get agreeTerms;

  /// No description provided for @completeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get completeRegistration;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMyRequest.
  ///
  /// In en, this message translates to:
  /// **'My Request'**
  String get navMyRequest;

  /// No description provided for @navLiveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get navLiveChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @tapAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Tap again to exit'**
  String get tapAgainToExit;

  /// No description provided for @quickAction.
  ///
  /// In en, this message translates to:
  /// **'Quick Action'**
  String get quickAction;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @serviceOverview.
  ///
  /// In en, this message translates to:
  /// **'Service Overview'**
  String get serviceOverview;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @createRequest.
  ///
  /// In en, this message translates to:
  /// **'Create Request'**
  String get createRequest;

  /// No description provided for @addPoint.
  ///
  /// In en, this message translates to:
  /// **'Add point'**
  String get addPoint;

  /// No description provided for @approvalNeeded.
  ///
  /// In en, this message translates to:
  /// **'Approval Needed'**
  String get approvalNeeded;

  /// No description provided for @technicianApprovalMessage.
  ///
  /// In en, this message translates to:
  /// **'Technician wants to start the work. Kindly approve.'**
  String get technicianApprovalMessage;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotifications;

  /// No description provided for @youAreAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get youAreAllCaughtUp;

  /// No description provided for @pointsDetails.
  ///
  /// In en, this message translates to:
  /// **'Points Details'**
  String get pointsDetails;

  /// No description provided for @yourCurrentPointsBalance.
  ///
  /// In en, this message translates to:
  /// **'Your Current Points Balance'**
  String get yourCurrentPointsBalance;

  /// No description provided for @pointsRequests.
  ///
  /// In en, this message translates to:
  /// **'Points Requests:'**
  String get pointsRequests;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @adminRequests.
  ///
  /// In en, this message translates to:
  /// **'Admin Requests:'**
  String get adminRequests;

  /// No description provided for @pointHistory.
  ///
  /// In en, this message translates to:
  /// **'Point History:'**
  String get pointHistory;

  /// No description provided for @noHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No History Found'**
  String get noHistoryFound;

  /// No description provided for @noFamilyPointsFound.
  ///
  /// In en, this message translates to:
  /// **'No Family Points Found'**
  String get noFamilyPointsFound;

  /// No description provided for @familyPoints.
  ///
  /// In en, this message translates to:
  /// **'Family Points'**
  String get familyPoints;

  /// No description provided for @myRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'My Recent Activity'**
  String get myRecentActivity;

  /// No description provided for @requestToPoints.
  ///
  /// In en, this message translates to:
  /// **'Request To Points'**
  String get requestToPoints;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number*'**
  String get mobileNumber;

  /// No description provided for @mobileNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number required'**
  String get mobileNumberRequired;

  /// No description provided for @enterValidMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter valid mobile number'**
  String get enterValidMobile;

  /// No description provided for @enterPoints.
  ///
  /// In en, this message translates to:
  /// **'Enter Points*'**
  String get enterPoints;

  /// No description provided for @pointsRequired.
  ///
  /// In en, this message translates to:
  /// **'Points required'**
  String get pointsRequired;

  /// No description provided for @enterValidPoints.
  ///
  /// In en, this message translates to:
  /// **'Enter valid points'**
  String get enterValidPoints;

  /// No description provided for @positiveIntegerHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive integer value for the points.'**
  String get positiveIntegerHint;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'For new service request.'**
  String get notesHint;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @pointsRequestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Points request sent successfully'**
  String get pointsRequestSuccess;

  /// No description provided for @selectServiceIssue.
  ///
  /// In en, this message translates to:
  /// **'Please select service & issue'**
  String get selectServiceIssue;

  /// No description provided for @createServiceRequest.
  ///
  /// In en, this message translates to:
  /// **'Create Service Request'**
  String get createServiceRequest;

  /// No description provided for @serviceCategory.
  ///
  /// In en, this message translates to:
  /// **'Service category'**
  String get serviceCategory;

  /// No description provided for @selectServices.
  ///
  /// In en, this message translates to:
  /// **'Select Services*'**
  String get selectServices;

  /// No description provided for @servicePointsRequired.
  ///
  /// In en, this message translates to:
  /// **'Service Points Required'**
  String get servicePointsRequired;

  /// No description provided for @serviceFree.
  ///
  /// In en, this message translates to:
  /// **'Service Free'**
  String get serviceFree;

  /// No description provided for @pointsLabel.
  ///
  /// In en, this message translates to:
  /// **'{points} Points'**
  String pointsLabel(Object points);

  /// No description provided for @issueDetails.
  ///
  /// In en, this message translates to:
  /// **'Issue Details'**
  String get issueDetails;

  /// No description provided for @selectIssue.
  ///
  /// In en, this message translates to:
  /// **'Select Issue*'**
  String get selectIssue;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue…'**
  String get describeIssue;

  /// No description provided for @mediaUploadOptional.
  ///
  /// In en, this message translates to:
  /// **'Media Upload (optional)'**
  String get mediaUploadOptional;

  /// No description provided for @imagesSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} / 10 images selected'**
  String imagesSelectedCount(Object count);

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @requestIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Request ID: {id}'**
  String requestIdLabel(Object id);

  /// No description provided for @requestSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Service request submitted successfully.'**
  String get requestSuccessTitle;

  /// No description provided for @requestSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Your request id has been received and is being processed'**
  String get requestSuccessDesc;

  /// No description provided for @viewMyRequest.
  ///
  /// In en, this message translates to:
  /// **'View My Request'**
  String get viewMyRequest;

  /// No description provided for @myServiceRequest.
  ///
  /// In en, this message translates to:
  /// **'MY Service Request'**
  String get myServiceRequest;

  /// No description provided for @noRequestFound.
  ///
  /// In en, this message translates to:
  /// **'No request found'**
  String get noRequestFound;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @serviceRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Request Details'**
  String get serviceRequestDetails;

  /// No description provided for @complaintDetails.
  ///
  /// In en, this message translates to:
  /// **'Complaint Details'**
  String get complaintDetails;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @requestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted'**
  String get requestSubmitted;

  /// No description provided for @requestSubmittedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your service request has been successfully submitted.'**
  String get requestSubmittedDesc;

  /// No description provided for @adminProcessing.
  ///
  /// In en, this message translates to:
  /// **'Admin Processing Request'**
  String get adminProcessing;

  /// No description provided for @adminProcessingDesc.
  ///
  /// In en, this message translates to:
  /// **'Nadi team is reviewing the details of your request.'**
  String get adminProcessingDesc;

  /// No description provided for @technicianAssigned.
  ///
  /// In en, this message translates to:
  /// **'Technician Assigned'**
  String get technicianAssigned;

  /// No description provided for @technicianAssignedDesc.
  ///
  /// In en, this message translates to:
  /// **'A technician has been assigned to your request.'**
  String get technicianAssignedDesc;

  /// No description provided for @serviceInProgress.
  ///
  /// In en, this message translates to:
  /// **'Service In Progress'**
  String get serviceInProgress;

  /// No description provided for @serviceInProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Technician is working on your service'**
  String get serviceInProgressDesc;

  /// No description provided for @paymentInProgress.
  ///
  /// In en, this message translates to:
  /// **'Payment In Progress'**
  String get paymentInProgress;

  /// No description provided for @paymentInProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Waiting for payment confirmation.'**
  String get paymentInProgressDesc;

  /// No description provided for @serviceCompleted.
  ///
  /// In en, this message translates to:
  /// **'Service Completed'**
  String get serviceCompleted;

  /// No description provided for @serviceCompletedDesc.
  ///
  /// In en, this message translates to:
  /// **'Service has been successfully completed.'**
  String get serviceCompletedDesc;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get paymentPending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @toPay.
  ///
  /// In en, this message translates to:
  /// **'To Pay'**
  String get toPay;

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profileDetails;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @noProfileData.
  ///
  /// In en, this message translates to:
  /// **'No profile data'**
  String get noProfileData;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get errorLoadingProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @building.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get building;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartment;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get additionalInfo;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @accountDelete.
  ///
  /// In en, this message translates to:
  /// **'Account Delete'**
  String get accountDelete;

  /// No description provided for @helpSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportTitle;

  /// No description provided for @sendEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Send us an Enquiry'**
  String get sendEnquiry;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// No description provided for @nameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameValidation;

  /// No description provided for @emailValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailValidation;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @messageValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a message'**
  String get messageValidation;

  /// No description provided for @enquirySuccess.
  ///
  /// In en, this message translates to:
  /// **'Enquiry submitted successfully!'**
  String get enquirySuccess;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @phoneValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneValidation;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a reason before deleting your account:'**
  String get deleteAccountDescription;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @pleaseSelectReason.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason'**
  String get pleaseSelectReason;
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
