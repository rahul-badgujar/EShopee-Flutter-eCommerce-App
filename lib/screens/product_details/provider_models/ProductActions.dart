import 'package:flutter/material.dart';

class ProductActions extends ChangeNotifier {
  bool _productFavStatus = false;

  bool get productFavStatus {
    return _productFavStatus;
  }

  set initialProductFavStatus(bool status) {
    _productFavStatus = status;
  }

  set productFavStatus(bool status) {
    _productFavStatus = status;
    notifyListeners();
  }

  void switchProductFavStatus() {
    _productFavStatus = !_productFavStatus;
    notifyListeners();
  }
}
