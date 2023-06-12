import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/widgets/form_edit_bank.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_edit_provider.dart';
import '../providers/profile_provider.dart';
import '../../../../core/utility/injection.dart';

class EditBankPage extends StatefulWidget {
  static const String routeName = "EditBankPage";

  const EditBankPage({Key? key}) : super(key: key);

  @override
  State<EditBankPage> createState() => _EditBankPageState();
}

class _EditBankPageState extends State<EditBankPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => locator<ProfileProvider>()..setProfileData()),
        ChangeNotifierProxyProvider<ProfileProvider, ProfileEditProvider>(
          create: (_) => locator<ProfileEditProvider>(),
          update: (context, profile, edit) =>
          edit!..setupTextControllerValues(profile.profile!),
        )
      ],
      builder: (context, child) => Scaffold(
        key: locator<GlobalKey<ScaffoldState>>(),
        backgroundColor: whiteColor,
        // appBar: CustomAppTtitleBar(
        //   centerTitle: true,
        //   canBack: true,
        //   title: appLoc.profile.toUpperCase(),
        //   hideShadow: true,
        // ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Consumer<ProfileProvider>(builder: (context, provider, _) {
                if (provider.isLoadProfile) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView(
                    children: const [FormEditBank()],
                  );
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
