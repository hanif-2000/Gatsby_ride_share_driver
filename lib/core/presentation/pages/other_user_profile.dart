import 'package:appkey_taxiapp_driver/core/presentation/widgets/profile_field_tile.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile({Key? key}) : super(key: key);
  static const routeName = '/OtherUserProfile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              SvgPicture.asset('assets/icons/auth/ic_back.svg'),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 121,
                          width: 121,
                          child: true
                              ? Image.asset(
                                  'assets/icons/profile/ic_personal_detail.png',
                                  height: 150,
                                  width: 150,
                                )
                              : Container(
                                  height: 150,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    color: greyF9F9F9,
                                    shape: BoxShape.circle,
                                    // image: DecorationImage(
                                    //   image: NetworkImage(BASE_URL +
                                    //       provider.profileUploadImage),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                        ),
                      ),
                      largeVerticalSpacing(),
                      ProfileFieldTile(
                        title: appLoc.firstName,
                        value: 'Alex',
                      ),
                      mediumVerticalSpacing(),
                      ProfileFieldTile(
                        title: appLoc.lastName,
                        value: 'Robin',
                      ),
                      mediumVerticalSpacing(),
                      ProfileFieldTile(
                        title: appLoc.mobileNumber,
                        value: '91+56434-54657',
                      ),
                      mediumVerticalSpacing(),
                      ProfileFieldTile(
                        title: appLoc.country,
                        value: 'France',
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
