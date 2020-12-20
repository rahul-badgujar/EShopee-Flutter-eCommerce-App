import 'package:e_commerce_app_flutter/components/product_short_detail_card.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              Text("Manage Your Products", style: headingStyle),
              Text("Swipe LEFT to Edit, Swipe RIGHT to Delete"),
              SizedBox(height: getProportionateScreenHeight(30)),
              Expanded(
                child: FutureBuilder(
                  future: ProductDatabaseHelper().getUsersProductsList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        //shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return buildProductsCard(snapshot.data[index]);
                        },
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Icon(Icons.error);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget buildProductsCard(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Dismissible(
        key: Key("this"),
        direction: DismissDirection.horizontal,
        background: Container(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          decoration: BoxDecoration(
            color: kTextColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: kPrimaryColor,
              ),
              Spacer(),
              Icon(
                Icons.delete,
                color: kPrimaryColor,
              ),
            ],
          ),
        ),
        child: ProductShortDetailCard(
          product: product,
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            print("delete");
          } else if (direction == DismissDirection.startToEnd) {
            print("edit");
          }
        },
      ),
    );
  }
}
