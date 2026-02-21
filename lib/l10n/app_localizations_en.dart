// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get skip => 'Skip';

  @override
  String get nadiBahrainServices => 'Nadi Bahrain Services';

  @override
  String get welcome => 'Welcome!';

  @override
  String get getStarted => 'Get Started';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signInWithOtp => 'Sign In with OTP';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get or => 'OR';

  @override
  String get changePassword => 'Change your Password';

  @override
  String get enterEmail => 'Enter Email';

  @override
  String get sendEmail => 'Send Email';

  @override
  String get emailSentMessage => 'Email sent successfully';

  @override
  String get enterVerificationCode => 'Enter Verification code';

  @override
  String get otpSentMessage =>
      'We have sent you a 4 digit verification code on';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendOtpIn(Object seconds) {
    return 'Resend OTP in 00:$seconds';
  }

  @override
  String get otpSignIn => 'Sign In';

  @override
  String get enter4DigitOtp => 'Please enter 4 digit OTP';

  @override
  String get accountTypeTitle => 'Account Type';

  @override
  String get individualAccount => 'Individual Account';

  @override
  String get individualAccountDesc =>
      'Manage your services and profile independently.';

  @override
  String get familyAccount => 'Family Account';

  @override
  String get familyAccountDesc =>
      'Register and manage services for multiple family members.';

  @override
  String get signUpTitle => 'Sign up';

  @override
  String get accountVerificationTitle =>
      'Secure Your Account With ID Verification';

  @override
  String get accountVerificationDesc1 =>
      'To ensure the highest level of security and trust within the Service Connect community, we require all users to complete a simple identity verification process. This helps protect against fraud and maintain a safe environment for everyone.';

  @override
  String get accountVerificationDesc2 =>
      'We value your safety and privacy. Your information is securely processed and used only for verification purposes.';

  @override
  String get continueButton => 'Continue';

  @override
  String get enterPhoneNumber => 'Enter Phone Number';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter phone number';

  @override
  String get phoneMustBe8Digits => 'Phone number must be 8 digits';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get enterValidOtp => 'Enter valid OTP';

  @override
  String get enterFullName => 'Enter Full Name*';

  @override
  String get gender => 'Gender*';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get createPassword => 'Create Password*';

  @override
  String get confirmPassword => 'Confirm Password*';

  @override
  String get pleaseSelectRelationship => 'Please select relationship';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get pickLocation => 'Pick Location';

  @override
  String get enterNumberOfKids => 'Enter Number of kids*';

  @override
  String get noOfBoys => 'No of boys*';

  @override
  String get noOfGirls => 'No of girls*';

  @override
  String get flat => 'Flat';

  @override
  String get villa => 'Villa';

  @override
  String get office => 'Office';

  @override
  String get enterCity => 'Enter Your city/Area';

  @override
  String get enterBuilding => 'Enter Your Building*';

  @override
  String get enterAptNo => 'Enter Apt No*';

  @override
  String get enterFloorNo => 'Enter Floor No*';

  @override
  String get selectBlock => 'Select Your Block*';

  @override
  String get selectRoad => 'Select Your Road*';

  @override
  String get pleaseSelectBlock => 'Please select a block';

  @override
  String get pleaseSelectRoad => 'Please select a road';

  @override
  String get continueBtn => 'Continue';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully';

  @override
  String get submitFailed => 'Submit failed';

  @override
  String get failedToLoadBlocks => 'Failed to load blocks';

  @override
  String addMemberTitle(Object accountType, Object current, Object total) {
    return 'Add $accountType Member $current of $total';
  }

  @override
  String get enterFamilyCount => 'Enter Family Count*';

  @override
  String get addMemberBtn => 'Add Member';

  @override
  String get memberFullName => 'Member Full Name*';

  @override
  String get relationship => 'Relationship*';

  @override
  String get selectRelationship => 'Select relationship';

  @override
  String get selectGender => 'Select gender';

  @override
  String get hideAddress => 'Hide Address';

  @override
  String get addAddress => 'Add Address';

  @override
  String get finish => 'Finish';

  @override
  String get allMembersAdded => 'All members added successfully';

  @override
  String get father => 'Father';

  @override
  String get mother => 'Mother';

  @override
  String get son => 'Son';

  @override
  String get daughter => 'Daughter';

  @override
  String get addOther => 'Add Other';

  @override
  String get uploadIdTitle => 'Upload ID Card';

  @override
  String get uploadIdFrontTitle => 'Front Side of ID Card';

  @override
  String get uploadIdBackTitle => 'Back Side of ID Card';

  @override
  String get uploadIdSubtitle =>
      'Ensure your name, photo, and expiry date are clearly visible.';

  @override
  String get uploadIdError => 'Please upload both front and back images';

  @override
  String get accountCreated => 'Account Created';

  @override
  String get successfully => 'Successfully!';

  @override
  String get accountCreatedDesc =>
      'Welcome to Nadi Bahrain Services. You can now sign in to your new account.';

  @override
  String get termsTitle => 'Terms & Conditions';

  @override
  String get ourCommitments => 'Our Commitments To You';

  @override
  String get readFullTerms => 'Read the full Terms & Conditions';

  @override
  String get agreeTerms =>
      'I have read and agree to the Service Connect Terms & Conditions and Privacy Policy';

  @override
  String get completeRegistration => 'Complete Registration';

  @override
  String get navHome => 'Home';

  @override
  String get navMyRequest => 'My Request';

  @override
  String get navLiveChat => 'Live Chat';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get tapAgainToExit => 'Tap again to exit';

  @override
  String get quickAction => 'Quick Action';

  @override
  String get viewAll => 'View All';

  @override
  String get serviceOverview => 'Service Overview';

  @override
  String get details => 'Details';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get createRequest => 'Create Request';

  @override
  String get addPoint => 'Add point';

  @override
  String get approvalNeeded => 'Approval Needed';

  @override
  String get technicianApprovalMessage =>
      'Technician wants to start the work. Kindly approve.';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get youAreAllCaughtUp => 'You\'re all caught up!';

  @override
  String get pointsDetails => 'Points Details';

  @override
  String get yourCurrentPointsBalance => 'Your Current Points Balance';

  @override
  String get pointsRequests => 'Points Requests:';

  @override
  String get showMore => 'Show More';

  @override
  String get adminRequests => 'Admin Requests:';

  @override
  String get pointHistory => 'Point History:';

  @override
  String get noHistoryFound => 'No History Found';

  @override
  String get noFamilyPointsFound => 'No Family Points Found';

  @override
  String get familyPoints => 'Family Points';

  @override
  String get myRecentActivity => 'My Recent Activity';

  @override
  String get requestToPoints => 'Request To Points';

  @override
  String get admin => 'Admin';

  @override
  String get friend => 'Friend';

  @override
  String get mobileNumber => 'Mobile Number*';

  @override
  String get mobileNumberRequired => 'Mobile number required';

  @override
  String get enterValidMobile => 'Enter valid mobile number';

  @override
  String get enterPoints => 'Enter Points*';

  @override
  String get pointsRequired => 'Points required';

  @override
  String get enterValidPoints => 'Enter valid points';

  @override
  String get positiveIntegerHint =>
      'Enter a positive integer value for the points.';

  @override
  String get notesOptional => 'Notes (Optional)';

  @override
  String get notesHint => 'For new service request.';

  @override
  String get submit => 'Submit';

  @override
  String get pointsRequestSuccess => 'Points request sent successfully';

  @override
  String get selectServiceIssue => 'Please select service & issue';

  @override
  String get createServiceRequest => 'Create Service Request';

  @override
  String get serviceCategory => 'Service category';

  @override
  String get selectServices => 'Select Services*';

  @override
  String get servicePointsRequired => 'Service Points Required';

  @override
  String get serviceFree => 'Service Free';

  @override
  String pointsLabel(Object points) {
    return '$points Points';
  }

  @override
  String get issueDetails => 'Issue Details';

  @override
  String get selectIssue => 'Select Issue*';

  @override
  String get describeIssue => 'Describe your issue…';

  @override
  String get mediaUploadOptional => 'Media Upload (optional)';

  @override
  String imagesSelectedCount(Object count) {
    return '$count / 10 images selected';
  }

  @override
  String get sendRequest => 'Send Request';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String requestIdLabel(Object id) {
    return 'Request ID: $id';
  }

  @override
  String get requestSuccessTitle => 'Service request submitted successfully.';

  @override
  String get requestSuccessDesc =>
      'Your request id has been received and is being processed';

  @override
  String get viewMyRequest => 'View My Request';

  @override
  String get myServiceRequest => 'MY Service Request';

  @override
  String get noRequestFound => 'No request found';

  @override
  String get viewDetails => 'View Details';

  @override
  String get total => 'Total';

  @override
  String get serviceRequestDetails => 'Service Request Details';

  @override
  String get complaintDetails => 'Complaint Details';

  @override
  String get feedback => 'Feedback';

  @override
  String get requestSubmitted => 'Request Submitted';

  @override
  String get requestSubmittedDesc =>
      'Your service request has been successfully submitted.';

  @override
  String get adminProcessing => 'Admin Processing Request';

  @override
  String get adminProcessingDesc =>
      'Nadi team is reviewing the details of your request.';

  @override
  String get technicianAssigned => 'Technician Assigned';

  @override
  String get technicianAssignedDesc =>
      'A technician has been assigned to your request.';

  @override
  String get serviceInProgress => 'Service In Progress';

  @override
  String get serviceInProgressDesc => 'Technician is working on your service';

  @override
  String get paymentInProgress => 'Payment In Progress';

  @override
  String get paymentInProgressDesc => 'Waiting for payment confirmation.';

  @override
  String get serviceCompleted => 'Service Completed';

  @override
  String get serviceCompletedDesc => 'Service has been successfully completed.';

  @override
  String get submitted => 'Submitted';

  @override
  String get accepted => 'Accepted';

  @override
  String get inProgress => 'In Progress';

  @override
  String get paymentPending => 'Payment Pending';

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String get close => 'Close';

  @override
  String get toPay => 'To Pay';

  @override
  String get profileDetails => 'Profile Details';

  @override
  String get loading => 'Loading...';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get noProfileData => 'No profile data';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get building => 'Building';

  @override
  String get city => 'City';

  @override
  String get floor => 'Floor';

  @override
  String get apartment => 'Apartment';

  @override
  String get additionalInfo => 'Additional Info';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get settings => 'Settings';

  @override
  String get aboutApp => 'About App';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get notification => 'Notification';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get history => 'History';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get logout => 'Log Out';

  @override
  String get accountDelete => 'Account Delete';

  @override
  String get helpSupportTitle => 'Help & Support';

  @override
  String get sendEnquiry => 'Send us an Enquiry';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get messageLabel => 'Message';

  @override
  String get submitButton => 'Submit';

  @override
  String get nameValidation => 'Please enter your name';

  @override
  String get emailValidation => 'Please enter your email';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get messageValidation => 'Please enter a message';

  @override
  String get enquirySuccess => 'Enquiry submitted successfully!';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneValidation => 'Please enter your phone number';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountDescription =>
      'Select a reason before deleting your account:';

  @override
  String get delete => 'Delete';

  @override
  String get pleaseSelectReason => 'Please select a reason';
}
