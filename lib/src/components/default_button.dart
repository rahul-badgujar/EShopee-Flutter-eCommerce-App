import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:flutter/material.dart';

typedef DefaultButtonOnPressCallback = Future<void> Function();

class DefaultButton extends StatelessWidget {
  final String label;
  final DefaultButtonOnPressCallback onPressed;
  final Color? color;
  const DefaultButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColorOfApp = Theme.of(context).primaryColor;
    return SizedBox(
      width: double.infinity,
      height: Dimens.instance.percentageScreenHeight(5),
      child: TextButton(
        child: _buildLabel(),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(color ?? primaryColorOfApp),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      label,
      style: TextStyle(
        fontSize: Dimens.instance.percentageScreenWidth(2),
        color: Colors.white,
      ),
    );
  }
}
