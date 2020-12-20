import 'package:e_commerce_app_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<Widget> items;

  const CustomBottomNavBar({
    Key key,
    @required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavBarStateProvider(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Color(0xFFDADADA).withOpacity(0.15),
            ),
          ],
        ),
        child: SafeArea(
          child: Consumer<BottomNavBarStateProvider>(
            builder: (context, state, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...List.generate(
                    items.length,
                    (index) => IconButton(
                      icon: items[index],
                      color: state.currentActiveItemIndex == index
                          ? kPrimaryColor
                          : kTextColor.withOpacity(0.42),
                      onPressed: () {
                        state.currentActiveItemIndex = index;
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class BottomNavBarStateProvider extends ChangeNotifier {
  int _currentActiveItemIndex = 0;
  int get currentActiveItemIndex => _currentActiveItemIndex;
  set currentActiveItemIndex(int index) {
    _currentActiveItemIndex = index;
    notifyListeners();
  }
}
