import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class EditProductScreen extends StatelessWidget {
  final Product productToEdit;

  const EditProductScreen({Key key, this.productToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productToEdit == null ? "Add New Product" : "Edit Product"),
      ),
      body: Body(
        productToEdit: productToEdit,
      ),
    );
  }
}
