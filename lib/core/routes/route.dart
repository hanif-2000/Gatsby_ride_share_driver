import 'package:appkey_taxiapp_driver/core/presentation/pages/home_page/home_page.dart';
import 'package:appkey_taxiapp_driver/features/about_us/presentation/pages/aboutus_page.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/pages/contact_us_page.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/pages/create_profile.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/pages/forgot_password_page.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/pages/otp_page.dart';
import 'package:appkey_taxiapp_driver/features/history/presentation/pages/detail_history_page.dart';
import 'package:appkey_taxiapp_driver/features/history/presentation/pages/history_page.dart';
import 'package:appkey_taxiapp_driver/features/login/presentation/pages/login_page.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/pages/order_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/change_email_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/change_password_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/edit_vehicle_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/profile_page.dart';
import 'package:appkey_taxiapp_driver/features/signup/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import '../../features/history/data/models/history_response_model.dart';
import '../presentation/pages/splash_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashPage.routeName:
      return MaterialPageRoute(builder: (_) => const SplashPage());
    case HomePage.routeName:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case LoginPage.routeName:
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case SignUpPage.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpPage());
    case ForgotPasswordPage.routeName:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
    case ContactUsPage.routeName:
      return MaterialPageRoute(builder: (_) => const ContactUsPage());
    case CreateProfilePage.routeName:
      return MaterialPageRoute(builder: (_) => const CreateProfilePage());
    case OTPPage.routeName:
      return MaterialPageRoute(builder: (_) => const OTPPage());
    case AboutUsPage.routeName:
      return MaterialPageRoute(builder: (_) => const AboutUsPage());
    case ProfilePage.routeName:
      return MaterialPageRoute(builder: (_) => const ProfilePage());
    case EditVehiclePage.routeName:
      return MaterialPageRoute(builder: (_) => const EditVehiclePage());
    case EditProfilePage.routeName:
      return MaterialPageRoute(builder: (_) => const EditProfilePage());
    case ChangeEmailPage.routeName:
      return MaterialPageRoute(builder: (_) => const ChangeEmailPage());
    case ChangePasswordPage.routeName:
      return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
    case HistoryPage.routeName:
      return MaterialPageRoute(builder: (_) => const HistoryPage());
    case DetailHistoryPage.routeName:
      final args = settings.arguments as HistoryOrder;
      return MaterialPageRoute(
          builder: (_) => DetailHistoryPage(
                item: args,
              ));
    case OrderPage.routeName:
      final args = settings.arguments as OrderPageArguments;
      return MaterialPageRoute(
          builder: (_) => OrderPage(
                orderDetail: args.orderDetail,
                customerDetail: args.customerDetailModel,
              ));

    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}
