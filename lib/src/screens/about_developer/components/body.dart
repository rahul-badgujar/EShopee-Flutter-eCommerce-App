import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/database/app_review_database_helper.dart';
import 'package:eshopee/src/utils/util_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_review_dialog.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: Constants.appWideScrollablePhysics,
        child: Padding(
          padding: Dimens.defaultScaffoldBodyPadding,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
                Text(
                  "About Developer",
                  style:
                      PrimaryLightTheme.instance.textTheme.getHeaderTextStyle(),
                ),
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
                InkWell(
                  onTap: () async {
                    const String linkedInUrl =
                        "https://www.linkedin.com/in/imrb7here";
                    await launchUrl(linkedInUrl);
                  },
                  child: buildDeveloperAvatar(),
                ),
                SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
                const Text(
                  '" Rahul Badgujar "',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  "PCCoE Pune",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/github_icon.svg",
                        color: UiPalette.textDarkShade(3).withOpacity(0.75),
                      ),
                      color: UiPalette.textDarkShade(3),
                      iconSize: 40,
                      padding: const EdgeInsets.all(16),
                      onPressed: () async {
                        const String githubUrl = "https://github.com/imRB7here";
                        await launchUrl(githubUrl);
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/linkedin_icon.svg",
                        color: UiPalette.textDarkShade(3).withOpacity(0.75),
                      ),
                      iconSize: 40,
                      padding: const EdgeInsets.all(16),
                      onPressed: () async {
                        const String linkedInUrl =
                            "https://www.linkedin.com/in/imrb7here";
                        await launchUrl(linkedInUrl);
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/instagram_icon.svg",
                        color: UiPalette.textDarkShade(3).withOpacity(0.75),
                      ),
                      iconSize: 40,
                      padding: const EdgeInsets.all(16),
                      onPressed: () async {
                        const String instaUrl =
                            "https://www.instagram.com/_rahul.badgujar_";
                        await launchUrl(instaUrl);
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: Dimens.instance.percentageScreenHeight(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      color: UiPalette.textDarkShade(3).withOpacity(0.75),
                      iconSize: 50,
                      padding: const EdgeInsets.all(16),
                      onPressed: () {
                        submitAppReview(context, liked: true);
                      },
                    ),
                    const Text(
                      "Liked the app?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      padding: const EdgeInsets.all(16),
                      color: UiPalette.textDarkShade(3).withOpacity(0.75),
                      iconSize: 50,
                      onPressed: () {
                        submitAppReview(context, liked: false);
                      },
                    ),
                    const Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeveloperAvatar() {
    return CircleAvatar(
      radius: Dimens.instance.percentageScreenHeight(12),
      backgroundColor: UiPalette.textDarkShade(3).withOpacity(0.75),
      backgroundImage: const NetworkImage(
          'https://avatars.githubusercontent.com/u/44890430?v=4'),
    );
  }

  Future<void> launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Logger().i("LinkedIn URL was unable to launch");
      }
    } catch (e) {
      Logger().e("Exception while launching URL: $e");
    }
  }

  Future<void> submitAppReview(BuildContext context,
      {bool liked = true}) async {
    final prevReview =
        await AppReviewDatabaseHelper().getAppReviewOfCurrentUser();

    final updatedReview = await showDialog(
      context: context,
      builder: (context) {
        return AppReviewDialog(
          appReview: prevReview,
        );
      },
    );
    if (updatedReview != null) {
      updatedReview.liked = liked;
      try {
        await AppReviewDatabaseHelper().editAppReview(updatedReview);
        showTextSnackbar(context, "Feedback submitted successfully");
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        showTextSnackbar(context, e.toString());
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        showTextSnackbar(context, e.toString());
      }
    }
  }
}
