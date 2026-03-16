import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @mustnotempty.
  ///
  /// In en, this message translates to:
  /// **'The field must not be empty'**
  String get mustnotempty;

  /// No description provided for @loginfailure.
  ///
  /// In en, this message translates to:
  /// **'Login failure'**
  String get loginfailure;

  /// No description provided for @signupFailure.
  ///
  /// In en, this message translates to:
  /// **'Signup failure'**
  String get signupFailure;

  /// No description provided for @emailhasbeentaken.
  ///
  /// In en, this message translates to:
  /// **'Email has been taken'**
  String get emailhasbeentaken;

  /// No description provided for @registrationfailed.
  ///
  /// In en, this message translates to:
  /// **'registration failed'**
  String get registrationfailed;

  /// No description provided for @pickupcoordinateisempty.
  ///
  /// In en, this message translates to:
  /// **'pick up coordinate is empty'**
  String get pickupcoordinateisempty;

  /// No description provided for @dropoffcoordinateisempty.
  ///
  /// In en, this message translates to:
  /// **'drop off coordinate is empty'**
  String get dropoffcoordinateisempty;

  /// No description provided for @taxitypenotselected.
  ///
  /// In en, this message translates to:
  /// **'taxi type not selected'**
  String get taxitypenotselected;

  /// No description provided for @paymentmethodnotselected.
  ///
  /// In en, this message translates to:
  /// **'payment method is not selected'**
  String get paymentmethodnotselected;

  /// No description provided for @failedtocreateorder.
  ///
  /// In en, this message translates to:
  /// **'failed to create order'**
  String get failedtocreateorder;

  /// No description provided for @failedtocancelorder.
  ///
  /// In en, this message translates to:
  /// **'failed to cancel order'**
  String get failedtocancelorder;

  /// No description provided for @oldPasswordValidation.
  ///
  /// In en, this message translates to:
  /// **'the old password is wrong'**
  String get oldPasswordValidation;

  /// No description provided for @orderacceptedotherdriver.
  ///
  /// In en, this message translates to:
  /// **'order has been accepted by other driver'**
  String get orderacceptedotherdriver;

  /// No description provided for @ordernotfound.
  ///
  /// In en, this message translates to:
  /// **'order not found'**
  String get ordernotfound;

  /// No description provided for @orderhascancelled.
  ///
  /// In en, this message translates to:
  /// **'order has cancelled'**
  String get orderhascancelled;

  /// No description provided for @sorry.
  ///
  /// In en, this message translates to:
  /// **'Sorry'**
  String get sorry;

  /// No description provided for @confirmationpwdnotmatch.
  ///
  /// In en, this message translates to:
  /// **'confirmation password not match'**
  String get confirmationpwdnotmatch;

  /// No description provided for @failedtochangeprofile.
  ///
  /// In en, this message translates to:
  /// **'failed to change profile'**
  String get failedtochangeprofile;

  /// No description provided for @emailinvalid.
  ///
  /// In en, this message translates to:
  /// **'Email address is invalid'**
  String get emailinvalid;

  /// No description provided for @phoneinvalid.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is invalid'**
  String get phoneinvalid;

  /// No description provided for @emailnotmatch.
  ///
  /// In en, this message translates to:
  /// **'Email address is not match'**
  String get emailnotmatch;

  /// No description provided for @pwdresetfail.
  ///
  /// In en, this message translates to:
  /// **'password reset failed'**
  String get pwdresetfail;

  /// No description provided for @passwordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password should contain upper,lower,digit and Special character and minimum 8 character long!'**
  String get passwordInvalid;

  /// No description provided for @confirmPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password and confirm password must be same!'**
  String get confirmPasswordInvalid;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @personalDetail.
  ///
  /// In en, this message translates to:
  /// **'Personal Detail'**
  String get personalDetail;

  /// No description provided for @vehicleDetail.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Detail'**
  String get vehicleDetail;

  /// No description provided for @bankDetail.
  ///
  /// In en, this message translates to:
  /// **'Bank Detail'**
  String get bankDetail;

  /// No description provided for @login_with_facebook.
  ///
  /// In en, this message translates to:
  /// **'Login with Facebook'**
  String get login_with_facebook;

  /// No description provided for @emailaddress.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailaddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotpassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotpassword;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP Code sent to '**
  String get enterOTP;

  /// No description provided for @didntReceiveOTP.
  ///
  /// In en, this message translates to:
  /// **'Don’t receive OTP code ? '**
  String get didntReceiveOTP;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @createyouraccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account by filling the following information below'**
  String get createyouraccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?  '**
  String get dontHaveAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account?  '**
  String get haveAccount;

  /// No description provided for @iAgreeOn.
  ///
  /// In en, this message translates to:
  /// **'I agree on '**
  String get iAgreeOn;

  /// No description provided for @term.
  ///
  /// In en, this message translates to:
  /// **'Term '**
  String get term;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and '**
  String get and;

  /// No description provided for @conditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get conditions;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'success'**
  String get success;

  /// No description provided for @changepassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changepassword;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your Password'**
  String get resetPassword;

  /// No description provided for @resendOTP.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendOTP;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP send successfully!'**
  String get otpSent;

  /// No description provided for @otpVerifySuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully!'**
  String get otpVerifySuccess;

  /// No description provided for @pleaseEnterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your official email to get a verification code.'**
  String get pleaseEnterYourEmailAddress;

  /// No description provided for @atLeastEightCharacter.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters, with uppercase and lowercase letters'**
  String get atLeastEightCharacter;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting!'**
  String get waiting;

  /// No description provided for @waitForTheReside.
  ///
  /// In en, this message translates to:
  /// **'Please wait for the rides to come'**
  String get waitForTheReside;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Profile'**
  String get createProfile;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @uploadDL.
  ///
  /// In en, this message translates to:
  /// **'Upload Driving Licence'**
  String get uploadDL;

  /// No description provided for @uploadId.
  ///
  /// In en, this message translates to:
  /// **'Upload ID Proof'**
  String get uploadId;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @vehicleName.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Name'**
  String get vehicleName;

  /// No description provided for @vehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Vehicle number'**
  String get vehicleNumber;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @insuranceNumber.
  ///
  /// In en, this message translates to:
  /// **'Insurance Number'**
  String get insuranceNumber;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @accountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolderName;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termConditions.
  ///
  /// In en, this message translates to:
  /// **'Term and conditions'**
  String get termConditions;

  /// No description provided for @pleaseEnterYourDetail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your detail'**
  String get pleaseEnterYourDetail;

  /// No description provided for @pleaseEnterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your message'**
  String get pleaseEnterMessage;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// No description provided for @messageSent.
  ///
  /// In en, this message translates to:
  /// **'Message Sent'**
  String get messageSent;

  /// No description provided for @yourMessageHasBeenSent.
  ///
  /// In en, this message translates to:
  /// **'your message has been sent'**
  String get yourMessageHasBeenSent;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @totalFare.
  ///
  /// In en, this message translates to:
  /// **'Total Fare'**
  String get totalFare;

  /// No description provided for @rideType.
  ///
  /// In en, this message translates to:
  /// **'Ride Type'**
  String get rideType;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @tripDetail.
  ///
  /// In en, this message translates to:
  /// **'Trip Detail'**
  String get tripDetail;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @rateYourPassenger.
  ///
  /// In en, this message translates to:
  /// **'Rate your passenger ?'**
  String get rateYourPassenger;

  /// No description provided for @yourFeedbackWillHelp.
  ///
  /// In en, this message translates to:
  /// **'Your feedback will help'**
  String get yourFeedbackWillHelp;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @findNextRide.
  ///
  /// In en, this message translates to:
  /// **'Find Next Ride'**
  String get findNextRide;

  /// No description provided for @getReceipt.
  ///
  /// In en, this message translates to:
  /// **'Get Receipt'**
  String get getReceipt;

  /// No description provided for @continuee.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @phonenumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phonenumber;

  /// No description provided for @appname.
  ///
  /// In en, this message translates to:
  /// **'taxi app'**
  String get appname;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get profile;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @we.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get we;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @callataxi.
  ///
  /// In en, this message translates to:
  /// **'call a taxi'**
  String get callataxi;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @choosetaxi.
  ///
  /// In en, this message translates to:
  /// **'Choose a taxi'**
  String get choosetaxi;

  /// No description provided for @selectpaymentmethod.
  ///
  /// In en, this message translates to:
  /// **'select payment method'**
  String get selectpaymentmethod;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash payment'**
  String get cash;

  /// No description provided for @creditdebit.
  ///
  /// In en, this message translates to:
  /// **'Credit / debit payment'**
  String get creditdebit;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editprofile;

  /// No description provided for @changephoto.
  ///
  /// In en, this message translates to:
  /// **'change photo'**
  String get changephoto;

  /// No description provided for @doyouwanttochangeit.
  ///
  /// In en, this message translates to:
  /// **'change it?'**
  String get doyouwanttochangeit;

  /// No description provided for @emailaddresschange.
  ///
  /// In en, this message translates to:
  /// **'e-mail address change'**
  String get emailaddresschange;

  /// No description provided for @pleaseenteranewemailaddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new email address'**
  String get pleaseenteranewemailaddress;

  /// No description provided for @pleasetryagain.
  ///
  /// In en, this message translates to:
  /// **'please try again'**
  String get pleasetryagain;

  /// No description provided for @reenteremailaddress.
  ///
  /// In en, this message translates to:
  /// **'Re-enter email address'**
  String get reenteremailaddress;

  /// No description provided for @paymentmethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentmethod;

  /// No description provided for @taxitype.
  ///
  /// In en, this message translates to:
  /// **'Taxi type'**
  String get taxitype;

  /// No description provided for @historydetail.
  ///
  /// In en, this message translates to:
  /// **'history detail'**
  String get historydetail;

  /// No description provided for @therearenopastorders.
  ///
  /// In en, this message translates to:
  /// **'there are no past orders'**
  String get therearenopastorders;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get loading;

  /// No description provided for @startingpoint.
  ///
  /// In en, this message translates to:
  /// **'Starting point'**
  String get startingpoint;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @typeoftaxi.
  ///
  /// In en, this message translates to:
  /// **'Type of taxi'**
  String get typeoftaxi;

  /// No description provided for @meter.
  ///
  /// In en, this message translates to:
  /// **'meter'**
  String get meter;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total;

  /// No description provided for @selectimagesource.
  ///
  /// In en, this message translates to:
  /// **'select image source'**
  String get selectimagesource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'gallery'**
  String get gallery;

  /// No description provided for @wouldyouliketocancel.
  ///
  /// In en, this message translates to:
  /// **'Would you like to cancel?'**
  String get wouldyouliketocancel;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @wouldyouliketologout.
  ///
  /// In en, this message translates to:
  /// **'Would you like to log out?'**
  String get wouldyouliketologout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @registersuccessfully.
  ///
  /// In en, this message translates to:
  /// **'register successfully'**
  String get registersuccessfully;

  /// No description provided for @successfullyregistered.
  ///
  /// In en, this message translates to:
  /// **'正常に登録されました'**
  String get successfullyregistered;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get origin;

  /// No description provided for @ordercreatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'order created successfully'**
  String get ordercreatedsuccessfully;

  /// No description provided for @ordercanceled.
  ///
  /// In en, this message translates to:
  /// **'order canceled'**
  String get ordercanceled;

  /// No description provided for @curentlyOfline.
  ///
  /// In en, this message translates to:
  /// **'Currently offline'**
  String get curentlyOfline;

  /// No description provided for @offLine.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offLine;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @customerCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Customer\'s current location'**
  String get customerCurrentLocation;

  /// No description provided for @customerDestination.
  ///
  /// In en, this message translates to:
  /// **'Customer\'s destination'**
  String get customerDestination;

  /// No description provided for @refuseTheOrder.
  ///
  /// In en, this message translates to:
  /// **'Do you refuse the order?'**
  String get refuseTheOrder;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Depart'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'arrive'**
  String get arrival;

  /// No description provided for @thankyou.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thankyou;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'Vehicle dispatching completed.'**
  String get end;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @savedialog.
  ///
  /// In en, this message translates to:
  /// **'data has been saved'**
  String get savedialog;

  /// No description provided for @isonlineNow.
  ///
  /// In en, this message translates to:
  /// **'Is online now'**
  String get isonlineNow;

  /// No description provided for @haveYouArrive.
  ///
  /// In en, this message translates to:
  /// **'Have you arrived ?'**
  String get haveYouArrive;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @pleaseCheckYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please check your email.'**
  String get pleaseCheckYourEmail;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @customerplace.
  ///
  /// In en, this message translates to:
  /// **'customer\'s place'**
  String get customerplace;

  /// No description provided for @destinationplace.
  ///
  /// In en, this message translates to:
  /// **'destination place'**
  String get destinationplace;

  /// No description provided for @meetcustomer.
  ///
  /// In en, this message translates to:
  /// **'Were you able to meet the customer?'**
  String get meetcustomer;

  /// No description provided for @waitcustconfirmation.
  ///
  /// In en, this message translates to:
  /// **'waiting customer confirmation'**
  String get waitcustconfirmation;

  /// No description provided for @tokenExpired.
  ///
  /// In en, this message translates to:
  /// **'Token is Expired'**
  String get tokenExpired;

  /// No description provided for @pleaseloginAgain.
  ///
  /// In en, this message translates to:
  /// **'Please Login Again !'**
  String get pleaseloginAgain;

  /// No description provided for @seater.
  ///
  /// In en, this message translates to:
  /// **'seater'**
  String get seater;

  /// No description provided for @gotadriver.
  ///
  /// In en, this message translates to:
  /// **'Got a driver'**
  String get gotadriver;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Hi, Welcome Back! '**
  String get welcome;

  /// No description provided for @signInAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account.'**
  String get signInAccount;

  /// No description provided for @newemailaddress.
  ///
  /// In en, this message translates to:
  /// **'Enter new email address'**
  String get newemailaddress;

  /// No description provided for @hintnewemailaddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new email address'**
  String get hintnewemailaddress;

  /// No description provided for @entertoconfirm.
  ///
  /// In en, this message translates to:
  /// **'(Enter again for confirmation)'**
  String get entertoconfirm;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @confirmpassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmpassword;

  /// No description provided for @enteryournewpwd.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get enteryournewpwd;

  /// No description provided for @carType.
  ///
  /// In en, this message translates to:
  /// **'Car Type'**
  String get carType;

  /// No description provided for @carModel.
  ///
  /// In en, this message translates to:
  /// **'Car Model'**
  String get carModel;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get people;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @departToCustomerPlace.
  ///
  /// In en, this message translates to:
  /// **'Start Ride to Pickup Location'**
  String get departToCustomerPlace;

  /// No description provided for @arriveAtCustomerPlace.
  ///
  /// In en, this message translates to:
  /// **'Reached Pickup Location'**
  String get arriveAtCustomerPlace;

  /// No description provided for @departToDestination.
  ///
  /// In en, this message translates to:
  /// **'Start Trip'**
  String get departToDestination;

  /// No description provided for @arriveAtDestination.
  ///
  /// In en, this message translates to:
  /// **'Reached to destination'**
  String get arriveAtDestination;

  /// No description provided for @endTrip.
  ///
  /// In en, this message translates to:
  /// **'End Trip'**
  String get endTrip;

  /// No description provided for @yesIhave.
  ///
  /// In en, this message translates to:
  /// **'Yes, I have.'**
  String get yesIhave;

  /// No description provided for @nocontactcust.
  ///
  /// In en, this message translates to:
  /// **'No. Contact the customer.'**
  String get nocontactcust;

  /// No description provided for @profileupdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileupdated;

  /// No description provided for @orderaccepted.
  ///
  /// In en, this message translates to:
  /// **'Order accepted'**
  String get orderaccepted;

  /// No description provided for @pwdreset.
  ///
  /// In en, this message translates to:
  /// **'Password created successfully!'**
  String get pwdreset;

  /// No description provided for @declineOrder.
  ///
  /// In en, this message translates to:
  /// **'Decline the order ?'**
  String get declineOrder;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
