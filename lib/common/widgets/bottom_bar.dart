import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/accounts/screens/account_screen.dart';
import 'package:amazon_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/main.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  int _page = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen()
  ];
  void updatePages(int value) {
    setState(() {
      _page = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePages,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: 42,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 5,
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                  ),
                ),
              ),
              child: const Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 42,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 5,
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                  ),
                ),
              ),
              child: const Icon(Icons.person_outline_outlined),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 42,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 5,
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                  ),
                ),
              ),
              child: badges.Badge(
                  badgeContent: Text(user.cart.length.toString()),
                  badgeStyle: const badges.BadgeStyle(
                    elevation: 0,
                    badgeColor: Colors.white,
                  ),
                  child: const Icon(Icons.shopping_cart_outlined)),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
