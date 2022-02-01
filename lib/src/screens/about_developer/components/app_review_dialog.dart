import 'package:eshopee/src/components/default_button.dart';
import 'package:eshopee/src/models/app_review_model.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';

class AppReviewDialog extends StatelessWidget {
  final AppReview appReview;
  const AppReviewDialog({
    Key? key,
    required this.appReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(
        child: Text(
          "Feedback",
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Center(
          child: TextFormField(
            initialValue: appReview.feedback,
            decoration: const InputDecoration(
              hintText: "Feedback for App",
              labelText: "Feedback (optional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (value) {
              appReview.feedback = value;
            },
            maxLines: null,
            maxLength: 150,
          ),
        ),
        SizedBox(height: Dimens.instance.percentageScreenHeight(4)),
        Center(
          child: DefaultButton(
            label: "Submit",
            onPressed: () {
              Navigator.pop(context, appReview);
              return Future<void>.value();
            },
          ),
        ),
      ],
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
    );
  }
}
