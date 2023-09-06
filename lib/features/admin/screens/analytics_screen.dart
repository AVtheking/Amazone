import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/admin/widgets/category_product.dart';
import 'package:amazon_clone/models/sale.dart';
import 'package:charts_flutter_maintained/charts_flutter_maintained.dart';
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
            children: [
              Text("\$$totalEarning"),
              SizedBox(
                height: 250,
                child: CategoryProductChart(seriesList: [
                  Series(
                      id: "Sales",
                      data: sales!,
                      domainFn: (Sale sale, _) => sale.label,
                      measureFn: (Sale sale, _) => sale.earnings)
                ]),
              )
            ],
          );
  }
}
