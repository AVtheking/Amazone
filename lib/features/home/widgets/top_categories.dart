import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/home/screens/category_screen.dart';
import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});
  void navigateToCategoryScreen(BuildContext context, String category) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CategoryScreen(category: category)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
          itemExtent: 75,
          itemCount: GlobalVariables.categoryImages.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    navigateToCategoryScreen(context,
                        GlobalVariables.categoryImages[index]['title']!);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                          GlobalVariables.categoryImages[index]['image']!),
                    ),
                  ),
                ),
                Text(
                  GlobalVariables.categoryImages[index]['title']!,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w400),
                )
              ],
            );
          }),
    );
  }
}
