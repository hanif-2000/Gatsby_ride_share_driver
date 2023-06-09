import 'package:appkey_taxiapp_driver/core/presentation/pages/job_completed_page.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../static/enums.dart';
import '../../utility/validation_helper.dart';
import '../../../features/order_detail/presentation/widget/custom_rating_bar.dart';

class GiveRatingScreen extends StatelessWidget {
  const GiveRatingScreen({Key? key}) : super(key: key);
  static const routeName = '/GiveRatingScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            largeVerticalSpacing(),
            largeVerticalSpacing(),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
              ),
            ),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: greenF0F9F1,
                border: Border.all(color: greenF0F9F1),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red),
              ),
            ),
            Text(
              'Johan Green',
              textAlign: TextAlign.center,
              style: titleStyle
                  .copyWith(
                    fontSize: 18,
                  )
                  .usePoppinsW5Font(),
            ),
            largeVerticalSpacing(),
            Text(
              appLoc.rateYourPassenger,
              textAlign: TextAlign.center,
              style: titleStyle
                  .copyWith(
                    fontSize: 25,
                  )
                  .usePoppinsW5Font(),
            ),
            smallVerticalSpacing(),
            Text(
              appLoc.yourFeedbackWillHelp,
              textAlign: TextAlign.center,
              style: titleStyle
                  .copyWith(fontSize: 17, color: greyA2A0A8)
                  .usePoppinsW4Font(),
            ),
            mediumVerticalSpacing(),
            const CustomRatingBar(
              initialRating: 4,
              itemSize: 40,
            ),
            largeVerticalSpacing(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  CustomTextField(
                    maxLine: 5,
                    placeholder: appLoc.pleaseEnterMessage,
                    title: appLoc.pleaseEnterMessage,
                    // controller: provider.firstNameController,
                    controller: TextEditingController(),
                    inputType: TextInputType.multiline,
                    // isError: provider.firstNameError,
                    isError: false,
                    fieldValidator: ValidationHelper(
                      loc: appLoc,
                      // isError: (bool value) => provider.setFirstNameError = value,
                      isError: (bool value) {},
                      typeField: TypeField.name,
                    ).validate(),
                  ),
                  largeVerticalSpacing(),
                  largeVerticalSpacing(),
                  CustomButton(
                    text: Text(
                      appLoc.submit,
                      style: txtButtonStyle,
                    ),
                    event: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.pushNamed(context, JobCompletedPage.routeName);
                      // if (provider.formKey.currentState!.validate()) {
                      //   submit();
                      // }
                    },
                    buttonHeight: 48,
                    isRounded: true,
                    bgColor: blackColor,
                  ),
                  largeVerticalSpacing(),
                  CustomButton(
                    text: Text(
                      appLoc.skip,
                      style: txtButtonStyle.copyWith(color: blackColor),
                    ),
                    event: () {
                      Navigator.pop(context);
                    },
                    showBorder: true,
                    buttonHeight: 48,
                    isRounded: true,
                    bgColor: Colors.white,
                  ),
                  largeVerticalSpacing(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
