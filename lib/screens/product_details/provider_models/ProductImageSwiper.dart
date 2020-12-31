import 'package:flutter/material.dart';

class ProductImageSwiper extends ChangeNotifier {
  int _currentImageIndex = 0;
  int get currentImageIndex {
    return _currentImageIndex;
  }

  set currentImageIndex(int index) {
    _currentImageIndex = index;
    notifyListeners();
  }
}
