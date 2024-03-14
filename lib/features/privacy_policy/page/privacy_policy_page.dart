import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);
  static const routeName = '/privacypolicy';

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final WebViewController controller;

  var loadingPercentage = 0;
  var error = false;
  String url = "${BASE_URL}privacy";

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    controller.setBackgroundColor(whiteColor);

    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          log("on page started called ");
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (int progress) {
          showLoading();

          log("progress is:-->> $progress");
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (String url) {
          dismissLoading();
          log("on page finished called");
          setState(() {
            loadingPercentage = 100;
          });
        },
        onWebResourceError: (WebResourceError error) =>
            setState(() => this.error = true),
        onNavigationRequest: (NavigationRequest request) =>
            NavigationDecision.navigate,
      ),
    );
    controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || error == true) {
      return const Center(child: Text("Error."));
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
          ],
        ),
      ),
    );
  }
}















































// import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
// import 'package:appkey_taxiapp_driver/core/static/styles.dart';
// import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
// import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class PrivacyPolicyPage extends StatelessWidget {
//   const PrivacyPolicyPage({Key? key}) : super(key: key);
//   static const routeName = '/PrivacyPolicyPage';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             largeVerticalSpacing(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
//                 ),
//                 Text(
//                   appLoc.privacyPolicy,
//                   textAlign: TextAlign.center,
//                   style: titleStyle.copyWith(
//                     fontSize: fontLarge,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 30,
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: sizeMedium, vertical: 8),
//               child: Text(
//                 'Lorem ipsum dolor sit amet, consectetur adipiscing elittiam ut rutrum sapien. ',
//                 textAlign: TextAlign.center,
//                 style: titleStyle
//                     .copyWith(
//                       fontSize: 13,
//                     )
//                     .usePoppinsW4Font(),
//               ),
//             ),
//             mediumVerticalSpacing(),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '1. Nunc sagittis mattis Pellentesque',
//                     style: titleStyle
//                         .copyWith(
//                           fontSize: 15,
//                         )
//                         .usePoppinsW5Font(),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   mediumVerticalSpacing(),
//                   Text(
//                     '2. Curabitur, luctus faucibus risus eu,',
//                     style: titleStyle
//                         .copyWith(
//                           fontSize: 15,
//                         )
//                         .usePoppinsW5Font(),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   mediumVerticalSpacing(),
//                   Text(
//                     '3. Nunc sagittis mattis Pellentesque',
//                     style: titleStyle
//                         .copyWith(
//                           fontSize: 15,
//                         )
//                         .usePoppinsW5Font(),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   mediumVerticalSpacing(),
//                   Text(
//                     '4. Curabitur, luctus faucibus risus eu,',
//                     style: titleStyle
//                         .copyWith(
//                           fontSize: 15,
//                         )
//                         .usePoppinsW5Font(),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 13.0, top: 6, right: 10),
//                     child: Text(
//                       'Nunc sagittis mattis sollicitudin. Pellentesque eu fringilla leo. Aliquam congue lectus at sapien sodales fringilla. Maecenas mi dui, egestas sed erat quis, placerat auctor ligula.',
//                       textAlign: TextAlign.start,
//                       style: titleStyle
//                           .copyWith(
//                             fontSize: 12,
//                           )
//                           .usePoppinsW4Font(),
//                     ),
//                   ),
//                   mediumVerticalSpacing(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
