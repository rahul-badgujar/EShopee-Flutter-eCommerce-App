import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshopee/src/components/async_progress_dialog.dart';
import 'package:eshopee/src/components/default_button.dart';
import 'package:eshopee/src/components/nothingtoshow_container.dart';
import 'package:eshopee/src/components/product_short_detail_card.dart';
import 'package:eshopee/src/models/cart_item_model.dart';
import 'package:eshopee/src/models/ordered_product_model.dart';
import 'package:eshopee/src/models/product_model.dart';
import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/data_streams/cart_items_stream.dart';
import 'package:eshopee/src/services/database/product_database_helper.dart';
import 'package:eshopee/src/services/database/user_database_helper.dart';
import 'package:eshopee/src/utils/ui_utils.dart';
import 'package:eshopee/src/utils/util_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'checkout_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final cartItemsStream = CartItemsStream();
  PersistentBottomSheetController? bottomSheetHandler;
  @override
  void initState() {
    super.initState();
    cartItemsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    cartItemsStream.dispose();
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
                  // SizedBox(height: Dimens.instance.percentageScreenHeight(1)),
                  Text(
                    "Your Cart",
                    style: PrimaryLightTheme.instance.textTheme
                        .getHeaderTextStyle(),
                  ),
                  SizedBox(height: Dimens.instance.percentageScreenHeight(1)),
                  SizedBox(
                    height: Dimens.instance.percentageScreenHeight(75),
                    child: Center(
                      child: buildCartItemsList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    cartItemsStream.reload();
    return Future<void>.value();
  }

  Widget buildCartItemsList() {
    return StreamBuilder<List<String>>(
      stream: cartItemsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cartItemsId = snapshot.data ?? <String>[];
          if (cartItemsId.isEmpty) {
            return const Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_cart.svg",
                secondaryMessage: "Your cart is empty",
              ),
            );
          }

          return Column(
            children: [
              DefaultButton(
                label: "Proceed to Payment",
                onPressed: () async {
                  bottomSheetHandler = Scaffold.of(context).showBottomSheet(
                    (context) {
                      return CheckoutCard(
                        onCheckoutPressed: checkoutButtonCallback,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: Dimens.instance.percentageScreenHeight(1)),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  physics: Constants.appWideScrollablePhysics,
                  itemCount: cartItemsId.length,
                  itemBuilder: (context, index) {
                    if (index >= cartItemsId.length) {
                      return SizedBox(
                          height: Dimens.instance.percentageScreenHeight(8));
                    }
                    return buildCartItemDismissible(
                        context, cartItemsId[index], index);
                  },
                ),
              ),
            ],
          );
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

  Widget buildCartItemDismissible(
      BuildContext context, String cartItemId, int index) {
    return Dismissible(
      key: Key(cartItemId),
      direction: DismissDirection.startToEnd,
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.65,
      },
      background: buildDismissibleBackground(),
      child: buildCartItem(cartItemId, index),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await showConfirmationDialog(
            context,
            "Remove Product from Cart?",
          );
          if (confirmation) {
            try {
              await UserDatabaseHelper().removeProductFromCart(cartItemId);
              showTextSnackbar(
                  context, "Product removed from cart successfully");
              await refreshPage();
              return true;
            } on FirebaseException catch (e) {
              Logger().w("Firebase Exception: $e");
              showTextSnackbar(context, "Firebase Exception: $e");
            } catch (e) {
              Logger().w("Unknown Exception: $e");
              showTextSnackbar(context, "Unknown Exception: $e");
            }
          }
        }
        return false;
      },
      onDismissed: (direction) {},
    );
  }

  Widget buildCartItem(String cartItemId, int index) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 4,
        top: 4,
        right: 4,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: UiPalette.textDarkShade(3).withOpacity(0.15)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder<Product?>(
        future: ProductDatabaseHelper().getProductWithID(cartItemId),
        builder: (context, snapshot) {
          final product = snapshot.data;
          if (product != null) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 8,
                  child: ProductShortDetailCard(
                    productId: product.id,
                    onPressed: () {
                      // TODO: add routing
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: product.id,
                          ),
                        ),
                      ); */
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: UiPalette.textDarkShade(3).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.arrow_drop_up,
                            color: UiPalette.textDarkShade(3),
                          ),
                          onTap: () async {
                            await arrowUpCallback(cartItemId);
                          },
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<CartItem?>(
                          future: UserDatabaseHelper()
                              .getCartItemFromId(cartItemId),
                          builder: (context, snapshot) {
                            int itemCount = 0;
                            final cartItem = snapshot.data;
                            if (cartItem != null) {
                              itemCount = cartItem.itemCount;
                            } else if (snapshot.hasError) {
                              final error = snapshot.error.toString();
                              Logger().e(error);
                            }
                            return Text(
                              "$itemCount",
                              style: TextStyle(
                                color: UiPalette.textDarkShade(3),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: UiPalette.textDarkShade(3),
                          ),
                          onTap: () async {
                            await arrowDownCallback(cartItemId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          } else {
            return const Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildDismissibleBackground() {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkoutButtonCallback() async {
    shutBottomSheet();
    final confirmation = await showConfirmationDialog(
      context,
      "This is just a Project Testing App so, no actual Payment Interface is available.\nDo you want to proceed for Mock Ordering of Products?",
    );
    if (confirmation == false) {
      return;
    }
    final orderFuture = UserDatabaseHelper().emptyCart();
    orderFuture.then((orderedProductsUid) async {
      final dateTime = DateTime.now();
      final formatedDateTime =
          "${dateTime.day}-${dateTime.month}-${dateTime.year}";
      List<OrderedProduct> orderedProducts = orderedProductsUid
          .map(
            (e) => OrderedProduct(
              data: <String, dynamic>{
                OrderedProduct.KEY_PRODUCT_UID: e,
                OrderedProduct.KEY_ORDER_DATE: formatedDateTime
              },
            ),
          )
          .toList();

      try {
        await UserDatabaseHelper().addToMyOrders(orderedProducts);
        showTextSnackbar(context, "Products ordered Successfully");
      } on FirebaseException catch (e) {
        Logger().e(e.toString());
        showTextSnackbar(context, 'Firebase Exception: $e');
      } catch (e) {
        Logger().e(e.toString());
        showTextSnackbar(context, e.toString());
      }
      await showDialog(
        context: context,
        builder: (context) {
          return AsyncProgressDialog(
            orderFuture,
            message: const Text("Placing the Order"),
          );
        },
      );
    }).catchError((e) {
      Logger().e(e.toString());
      showTextSnackbar(context, 'Something went wrong');
    });
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          orderFuture,
          message: const Text("Placing the Order"),
        );
      },
    );
    await refreshPage();
  }

  void shutBottomSheet() {
    bottomSheetHandler?.close();
  }

  Future<void> arrowUpCallback(String cartItemId) async {
    shutBottomSheet();
    final task = UserDatabaseHelper().increaseCartItemCount(cartItemId);
    task.then((_) async {
      await refreshPage();
    }).catchError((e) {
      Logger().e(e.toString());
      showTextSnackbar(context, 'Something went wrong');
    });
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          task,
          message: const Text("Please wait"),
        );
      },
    );
  }

  Future<void> arrowDownCallback(String cartItemId) async {
    shutBottomSheet();
    final task = UserDatabaseHelper().decreaseCartItemCount(cartItemId);
    task.then((_) async {
      await refreshPage();
    }).catchError((e) {
      Logger().e(e.toString());
      showTextSnackbar(context, 'Something went wrong');
    });
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          task,
          message: const Text("Please wait"),
        );
      },
    );
  }
}
