import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/widgets/CustomStepper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/widgets/bank_detail_form.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/widgets/personal_detail_from.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/widgets/vehicle_detail_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/utility/injection.dart';

class CreateProfilePage extends StatelessWidget {
  const CreateProfilePage({Key? key}) : super(key: key);
  static const routeName = '/CreateProfile';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<CreateProfileProvider>(),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Consumer<CreateProfileProvider>(
            builder: (context, provider, _) {
              return ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 5 / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (provider.currentStep == 3) {
                                  provider.setCurrentStep(2);
                                } else if (provider.currentStep == 2) {
                                  provider.setCurrentStep(1);
                                } else {
                                  // Navigator.pop(context);
                                }
                              },
                              icon: SvgPicture.asset(
                                  'assets/icons/auth/ic_back.svg'),
                            ),
                            Text(
                              appLoc.createProfile,
                              textAlign: TextAlign.center,
                              style: titleStyle.copyWith(
                                fontSize: fontLarge,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        largeVerticalSpacing(),
                        const CustomStepper(),
                      ],
                    ),
                  ),
                  largeVerticalSpacing(),
                  // FormPersonalDetail(),

                  provider.currentStep == 1
                      ? const FormPersonalDetail()
                      : provider.currentStep == 2
                          ? const FormVehicleDetail()
                          : const FormBankDetail(),

                  // const SignUpForm(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
