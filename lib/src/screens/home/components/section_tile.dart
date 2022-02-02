import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';

class SectionTile extends StatelessWidget {
  final String title;
  final GestureTapCallback press;
  const SectionTile({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: Dimens.instance.percentageScreenWidth(5),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
