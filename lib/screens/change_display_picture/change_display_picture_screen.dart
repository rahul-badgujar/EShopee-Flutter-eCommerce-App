import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';
import 'provider_models/body_model.dart';

class ChangeDisplayPictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChosenImage(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Change Display Picture"),
        ),
        body: Body(),
      ),
    );
  }
}
