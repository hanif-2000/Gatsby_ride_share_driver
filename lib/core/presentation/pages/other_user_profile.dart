import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/profile_field_tile.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile({Key? key}) : super(key: key);
  static const routeName = '/OtherUserProfile';

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    // OrderProvider provider = Provider.of<OrderProvider>(context, listen: false);
    var provider = locator<LatestSocketProvider>();

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
                          child: CustomCacheNetworkImage(
                              img: provider.customerDataModel!.photo!,
                              size: deviceSize.width * .4)

                          //  Container(
                          //   height: 45,
                          //   width: 45,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: redD03B3B,
                          //     image: DecorationImage(
                          //       image: NetworkImage(
                          //         '$BASE_URL${provider.customerDetail!.data.photo}',
                          //       ),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),

                          // SizedBox(
                          //   height: 121,
                          //   width: 121,
                          //   child: true
                          //       ? Image.asset(
                          //           'assets/icons/profile/ic_personal_detail.png',
                          //           height: 150,
                          //           width: 150,
                          //         )
                          //       : Container(
                          //           height: 150,
                          //           width: 150,
                          //           decoration: const BoxDecoration(
                          //             color: greyF9F9F9,
                          //             shape: BoxShape.circle,
                          //             // image: DecorationImage(
                          //             //   image: NetworkImage(BASE_URL +
                          //             //       provider.profileUploadImage),
                          //             //   fit: BoxFit.cover,
                          //             // ),
                          //           ),
                          //         ),
                          // ),
                          ),
                      largeVerticalSpacing(),
                      ProfileFieldTile(
                        title: appLoc.firstName,
                        value:
                            provider.customerDataModel!.name.split(' ').first,
                      ),
                      mediumVerticalSpacing(),
                      ProfileFieldTile(
                        title: appLoc.lastName,
                        value: provider.customerDataModel!.name.split(' ').last,
                      ),
                      mediumVerticalSpacing(),
                      ProfileFieldTile(
                        title: appLoc.mobileNumber,
                        value: provider.customerDataModel!.phoneNumber,
                      ),
                      mediumVerticalSpacing(),
                      ProfileFieldTile(
                        title: appLoc.country,
                        value: 'Canada',
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
