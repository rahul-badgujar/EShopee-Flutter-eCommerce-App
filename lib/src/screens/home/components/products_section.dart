import 'package:eshopee/src/components/nothingtoshow_container.dart';
import 'package:eshopee/src/components/product_card.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/data_streams/data_streamer.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'section_tile.dart';

class ProductsSection extends StatelessWidget {
  final String sectionTitle;
  final DataStreamer<List<String>> productsStreamController;
  final String emptyListMessage;
  final Function onProductCardTapped;
  const ProductsSection({
    Key? key,
    required this.sectionTitle,
    required this.productsStreamController,
    this.emptyListMessage = "No Products to show here",
    required this.onProductCardTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SectionTile(
            title: sectionTitle,
            press: () {},
          ),
          // SizedBox(height: Dimens.instance.percentageScreenHeight(1)),
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
          final productIdsList = snapshot.data!;
          if (productIdsList.isEmpty) {
            return Center(
              child: NothingToShowContainer(
                secondaryMessage: emptyListMessage,
              ),
            );
          }
          return buildProductGrid(productIdsList);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return const Center(
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
      physics: Constants.appWideScrollablePhysics,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
