import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/provider/contact_us_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/contact_us_form.dart';
import 'package:provider/provider.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});
  static const routeName = '/ContactUsPage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<ContactUsProvider>(),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: ListView(
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/auth/ic_back.svg',
                        ),
                      ),
                    ),
                    mediumVerticalSpacing(),
                    SvgPicture.asset('assets/icons/profile/contact_us_img.svg'),
                    mediumVerticalSpacing(),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Text(
                        appLoc.contactUs,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ).usePoppinsW6Font(),
                      ),
                    ),
                    smallVerticalSpacing(),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Text(
                        appLoc.pleaseEnterYourDetail,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: grey7D7979,
                          fontWeight: FontWeight.w400,
                        ).usePoppinsW4Font(),
                      ),
                    ),
                  ],
                ),
              ),
              const FormContactUs(),
              mediumVerticalSpacing(),
            ],
          ),
        ),
      ),
    );
  }
}
