import 'package:amazon_clone/models/sale.dart';
import 'package:charts_flutter_maintained/charts_flutter_maintained.dart '
    as chart;
import 'package:flutter/material.dart';

class CategoryProductChart extends StatelessWidget {
  final List<chart.Series<Sale, String>> seriesList;
  const CategoryProductChart({
    super.key,
    required this.seriesList,
  });

  @override
  Widget build(BuildContext context) {
    return chart.BarChart(
      seriesList,
      animate: true,
    );
  }
}
