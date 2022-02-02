import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final void Function(String) onSubmit;
  const SearchField({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiPalette.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "Search Products",
          prefixIcon: const Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(
              horizontal: Dimens.instance.percentageScreenWidth(2),
              vertical: Dimens.instance.percentageScreenWidth(3.4)),
        ),
        onSubmitted: onSubmit,
      ),
    );
  }
}
