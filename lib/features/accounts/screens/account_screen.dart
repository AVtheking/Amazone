import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/accounts/service/account_service.dart';
import 'package:amazon_clone/features/accounts/widgets/account_button.dart';
import 'package:amazon_clone/features/accounts/widgets/below_app_bar.dart';
import 'package:amazon_clone/features/accounts/widgets/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});
  void logOut(BuildContext context, WidgetRef ref) {
    ref.watch(accountServiceProvider).logOut(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  height: 45,
                  color: Colors.black,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Icons.notifications_outlined),
                    ),
                    Icon(Icons.search)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const BellowAppBar(),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              AccountButton(text: 'Your orders', onTap: () {}),
              AccountButton(text: 'Turn Seller', onTap: () {}),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              AccountButton(
                  text: 'Log Out',
                  onTap: () {
                    logOut(context, ref);
                  }),
              AccountButton(text: 'Your WishList', onTap: () {}),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Orders()
        ],
      ),
    );
  }
}
