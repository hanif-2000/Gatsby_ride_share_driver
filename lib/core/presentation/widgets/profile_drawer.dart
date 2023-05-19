import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/login/presentation/pages/login_page.dart';
import '../../../features/profile/presentation/providers/profile_provider.dart';
import '../../../features/profile/presentation/providers/profile_state.dart';
import '../../static/assets.dart';
import '../../static/styles.dart';
import '../../utility/helper.dart';
import 'custom_list_tile.dart';

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
              return CustomListTile(
                onTap: () {},
                titlePadding: const EdgeInsets.only(left: 10),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                enableDivider: false,
                leading: data.image.isEmpty
                    ? CircleAvatar(
                        radius: 33,
                        backgroundImage: AssetImage(userAvatarImage),
                      )
                    : CircleAvatar(
                        radius: 33,
                        backgroundImage:
                            NetworkImage(mergePhotoUrl(data.image)),
                      ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: formTextFieldStyle,
                    ),
                    Text(
                      data.phoneNumber,
                      style: formTextFieldStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.email,
                          style: formTextFieldStyle,
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              );
          }
          return const SizedBox.shrink();
        });
  }
}
