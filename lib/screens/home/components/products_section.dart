import 'package:e_commerce_app_flutter/components/nothingtoshow_container.dart';
import 'package:e_commerce_app_flutter/components/product_card.dart';
import 'package:e_commerce_app_flutter/screens/home/components/section_tile.dart';
import 'package:e_commerce_app_flutter/services/data_streams/data_stream.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../size_config.dart';

class ProductsSection extends StatelessWidget {
  final String sectionTitle;
  final DataStream productsStreamController;
  final String emptyListMessage;
  final Function onProductCardTapped;
  const ProductsSection({
    Key key,
    @required this.sectionTitle,
    @required this.productsStreamController,
    this.emptyListMessage = "No Products to show here",
    @required this.onProductCardTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SectionTile(
            title: sectionTitle,
            press: () {},
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Expanded(
            child: buildProductsList(),
          ),
        ],
      ),
    );
  }

  Widget buildProductsList() {
    return StreamBuilder<List<String>>(
      stream: productsStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: NothingToShowContainer(
                secondaryMessage: emptyListMessage,
              ),
            );
          }
          return buildProductGrid(snapshot.data);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildProductGrid(List<String> productsId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: productsId.length,
      itemBuilder: (context, index) {
        return ProductCard(
          productId: productsId[index],
          press: () {
            onProductCardTapped.call(productsId[index]);
          },
        );
      },
    );
  }
}
