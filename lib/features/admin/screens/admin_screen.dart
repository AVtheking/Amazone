import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/admin/screens/product_screen.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _page = 0;
  void onTap(int page) {
    setState(() {
      _page = page;
    });
  }

  List pages = [
    const ProductScreen(),
    const Text("Analytics"),
    const Text("inbox")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 120,
                  height: 40,
                  color: Colors.black,
                ),
              ),
              const Text(
                "Admin",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          currentIndex: _page,
          selectedItemColor: GlobalVariables.selectedNavBarColor,
          unselectedItemColor: GlobalVariables.unselectedNavBarColor,
          iconSize: 28,
          backgroundColor: GlobalVariables.backgroundColor,
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
                                  : GlobalVariables.backgroundColor))),
                  child: const Icon(Icons.home_outlined),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  width: 42,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 5,
                              color: _page == 1
                                  ? GlobalVariables.selectedNavBarColor
                                  : GlobalVariables.backgroundColor))),
                  child: const Icon(Icons.analytics_outlined),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  width: 42,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 5,
                              color: _page == 2
                                  ? GlobalVariables.selectedNavBarColor
                                  : GlobalVariables.backgroundColor))),
                  child: const Icon(Icons.all_inbox_outlined),
                ),
                label: ''),
          ]),
    );
  }
}
