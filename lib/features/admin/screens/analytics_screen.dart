import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/models/sale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int? totalEarning;
  List<Sale>? sales;

  getEarnings() async {
    var earnings = await ref.read(adminServiceProvider).getEarnings(context);
    totalEarning = earnings['totalEarning'];
    sales = earnings['sales'];
    setState(() {});
  }

  @override
  void initState() {
    getEarnings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return totalEarning == null || sales == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [Text("\$$sales")],
          );
  }
}
