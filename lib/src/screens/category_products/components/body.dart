import 'package:enum_to_string/enum_to_string.dart';
import 'package:eshopee/src/components/nothingtoshow_container.dart';
import 'package:eshopee/src/components/product_card.dart';
import 'package:eshopee/src/components/rounded_icon_button.dart';
import 'package:eshopee/src/components/search_field.dart';
import 'package:eshopee/src/models/product_model.dart';
import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/data_streams/category_products_stream.dart';
import 'package:eshopee/src/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Body extends StatefulWidget {
  final ProductType productType;

  const Body({
    Key? key,
    required this.productType,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late final CategoryProductsStream categoryProductsStream;

  @override
  void initState() {
    super.initState();
    categoryProductsStream = CategoryProductsStream(widget.productType);
    categoryProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    categoryProductsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: Dimens.defaultScaffoldBodyPadding,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
                  buildHeadBar(),
                  SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
                  SizedBox(
                    height: Dimens.instance.percentageScreenHeight(13),
                    child: buildCategoryBanner(),
                  ),
                  SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
                  SizedBox(
                    height: Dimens.instance.percentageScreenHeight(68),
                    child: StreamBuilder<List<String>>(
                      stream: categoryProductsStream.stream,
                      builder: (context, snapshot) {
                        final productsId = snapshot.data;
                        if (productsId != null) {
                          if (productsId.isEmpty) {
                            return Center(
                              child: NothingToShowContainer(
                                secondaryMessage:
                                    "No Products in ${nameFromProductType(widget.productType)}",
                              ),
                            );
                          }
                          return buildProductsGrid(productsId);
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                    ),
                  ),
                  SizedBox(height: Dimens.instance.percentageScreenHeight(2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeadBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundedIconButton(
          iconData: Icons.arrow_back_ios,
          press: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 5),
        Expanded(
          child: SearchField(
            onSubmit: (value) async {
              final query = value.toString();
              if (query.isEmpty) return;

              try {
                // ignore: unused_local_variable
                final searchedProductsId = await ProductDatabaseHelper()
                    .searchInProducts(
                        query: query.toLowerCase(),
                        productType: widget.productType);
                // TODO: add routing
                /* await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultScreen(
                        searchQuery: query,
                        searchResultProductsId: searchedProductsId,
                        searchIn:
                            EnumToString.convertToString(widget.productType),
                      ),
                    ),
                  ); */
                await refreshPage();
              } catch (e) {
                final error = e.toString();
                Logger().e(error);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> refreshPage() {
    categoryProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildCategoryBanner() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bannerFromProductType()),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                UiPalette.primaryColor,
                BlendMode.hue,
              ),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              EnumToString.convertToString(widget.productType),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProductsGrid(List<String> productsId) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GridView.builder(
        physics: Constants.appWideScrollablePhysics,
        itemCount: productsId.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ProductCard(
            productId: productsId[index],
            press: () {
              // TODO: add routing
              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                    productId: productsId[index],
                  ),
                ),
              ).then(
                (_) async {
                  await refreshPage();
                },
              ); */
            },
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 2,
          mainAxisSpacing: 8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 12,
        ),
      ),
    );
  }

  String bannerFromProductType() {
    switch (widget.productType) {
      case ProductType.Electronics:
        return "assets/images/electronics_banner.jpg";
      case ProductType.Books:
        return "assets/images/books_banner.jpg";
      case ProductType.Fashion:
        return "assets/images/fashions_banner.jpg";
      case ProductType.Groceries:
        return "assets/images/groceries_banner.jpg";
      case ProductType.Art:
        return "assets/images/arts_banner.jpg";
      case ProductType.Others:
        return "assets/images/others_banner.jpg";
      default:
        return "assets/images/others_banner.jpg";
    }
  }
}
