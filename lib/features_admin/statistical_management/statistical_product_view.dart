import 'package:ecommerce_flutter/models/product_model.dart';
import 'package:ecommerce_flutter/services/product_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticalProductView extends HookWidget {
  const StatisticalProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();

    Future<List<ProductModel>> fetchProducts() =>
        productService.fetchProducts();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Product Statistics',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.'));
          } else {
            final products = snapshot.data!;
            final categoryCounts = <String, int>{};
            final favoriteCounts = <String, int>{};

            for (var product in products) {
              categoryCounts[product.category] =
                  (categoryCounts[product.category] ?? 0) + 1;
              favoriteCounts[product.name] = product.favoriteUserIds.length;
            }

            // Sort favorite counts and get top 3
            final topFavorites = favoriteCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final top3Favorites = topFavorites.take(3).toList();

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products by Category',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: CategoryChart(categoryCounts: categoryCounts),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Top 3 Favorite Products',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),
                  TopFavoritesList(favoriteCounts: top3Favorites),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class CategoryChart extends StatelessWidget {
  final Map<String, int> categoryCounts;

  const CategoryChart({Key? key, required this.categoryCounts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> categories = categoryCounts.keys.toList();
    final List<double> values =
        categoryCounts.values.map((e) => e.toDouble()).toList();
    final maxY = values.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= categories.length) return Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    categories[value.toInt()],
                    style: TextStyle(
                      color: ColorUtils.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: maxY > 5 ? maxY / 5 : 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: ColorUtils.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          categories.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: values[index],
                color: ColorUtils.primaryColor,
                width: 22,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopFavoritesList extends StatelessWidget {
  final List<MapEntry<String, int>> favoriteCounts;

  const TopFavoritesList({Key? key, required this.favoriteCounts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: favoriteCounts.length,
      itemBuilder: (context, index) {
        final product = favoriteCounts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: ColorUtils.primaryColor,
            child: Text(
              '${index + 1}',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            product.key,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            '${product.value} likes',
            style: TextStyle(color: ColorUtils.primaryColor),
          ),
        );
      },
    );
  }
}
