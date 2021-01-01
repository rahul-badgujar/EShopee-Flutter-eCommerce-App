import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:flutter/material.dart';

enum ImageType {
  local,
  network,
}

class CustomImage {
  final ImageType imgType;
  final String path;
  CustomImage({this.imgType = ImageType.local, @required this.path});
  @override
  String toString() {
    return "Instance of Custom Image: {imgType: $imgType, path: $path}";
  }
}

class ProductDetails extends ChangeNotifier {
  List<CustomImage> _selectedImages = List<CustomImage>();
  ProductType _productType;
  List<String> _searchTags = List<String>();

  List<CustomImage> get selectedImages {
    return _selectedImages;
  }

  set initialSelectedImages(List<CustomImage> images) {
    _selectedImages = images;
  }

  set selectedImages(List<CustomImage> images) {
    _selectedImages = images;
    notifyListeners();
  }

  void setSelectedImageAtIndex(CustomImage image, int index) {
    if (index < _selectedImages.length) {
      _selectedImages[index] = image;
      notifyListeners();
    }
  }

  void addNewSelectedImage(CustomImage image) {
    _selectedImages.add(image);
    notifyListeners();
  }

  ProductType get productType {
    return _productType;
  }

  set initialProductType(ProductType type) {
    _productType = type;
  }

  set productType(ProductType type) {
    _productType = type;
    notifyListeners();
  }

  List<String> get searchTags {
    return _searchTags;
  }

  set searchTags(List<String> tags) {
    _searchTags = tags;
    notifyListeners();
  }

  set initSearchTags(List<String> tags) {
    _searchTags = tags;
  }

  void addSearchTag(String tag) {
    _searchTags.add(tag);
    notifyListeners();
  }

  void removeSearchTag({int index}) {
    if (index == null)
      _searchTags.removeLast();
    else
      _searchTags.removeAt(index);
    notifyListeners();
  }
}
