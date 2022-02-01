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
      height: Dimens.instance.percentageScreenHeight(6),
      child: TextButton(
        child: _buildLabel(context),
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

  Widget _buildLabel(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.subtitle1?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
