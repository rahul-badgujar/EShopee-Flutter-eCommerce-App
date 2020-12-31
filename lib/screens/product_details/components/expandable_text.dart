import 'package:flutter/material.dart';

import '../../../constants.dart';

class ExpandableText extends StatefulWidget {
  final String title;
  final String content;
  final int maxLines;
  const ExpandableText({
    Key key,
    @required this.title,
    @required this.content,
    this.maxLines = 3,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Divider(
          height: 8,
          thickness: 1,
          endIndent: 16,
        ),
        Text(
          widget.content,
          maxLines: expanded ? null : widget.maxLines,
          textAlign: TextAlign.left,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              expanded ^= true;
            });
          },
          child: Row(
            children: [
              Text(
                expanded == false ? "See more details" : "Show less details",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: kPrimaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
