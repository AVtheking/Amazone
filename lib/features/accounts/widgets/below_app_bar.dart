import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BellowAppBar extends ConsumerWidget {
  const BellowAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Container(
      decoration: const BoxDecoration(
        gradient: GlobalVariables.appBarGradient,
      ),
      padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
      child: Row(children: [
        const Text(
          "Hello, ",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        Text(
          user.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        )
      ]),
    );
  }
}
