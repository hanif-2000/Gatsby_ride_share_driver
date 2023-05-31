import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/profile/presentation/providers/profile_provider.dart';
import '../../../features/profile/presentation/providers/profile_state.dart';
import '../../static/assets.dart';
import '../../static/styles.dart';
import '../../utility/helper.dart';

class ProfileInformationDrawer extends StatelessWidget {
  const ProfileInformationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfileState>(
      stream: context.read<ProfileProvider>().fetchProfile(),
      builder: (context, state) {
        switch (state.data.runtimeType) {
          case ProfileLoading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ProfileFailure:
            final failure = (state.data as ProfileFailure).failure;
            logMe(failure);
            return const SizedBox.shrink();
          case ProfileLoaded:
            logMe("loaded");
            final data = (state.data as ProfileLoaded).data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                data.image.isEmpty
                    ? const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(userAvatarImage),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(mergePhotoUrl(data.image)),
                      ),
                Text(
                  data.name,
                  style: formTextFieldStyle,
                ),
                InkWell(
                  onTap: () {
                    ///TODO: Edit profile here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    ).then((value) {
                      if (value != null) {
                        context.read<ProfileProvider>().refreshProfile();
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      appLoc.editprofile,
                      style: titleNameStyle
                          .copyWith(color: greyB6B6B6, fontSize: 15)
                          .usePoppinsW4Font(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
