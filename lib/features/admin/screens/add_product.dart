import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_text_widget.dart';
import 'package:amazon_clone/common/widgets/sign_up_button.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/utlis.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final AdminService _adminService = AdminService();
  final _addProductFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  String category = 'Mobiles';
  List<File> images = [];
  void selectProductImage() async {
    final res = await pickImage();

    setState(() {
      images = res;
    });
  }

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];
  void sellProduct(BuildContext context) {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      _adminService.sellProduct(
        context: context,
        name: _nameController.text,
        description: _descriptionController.text,
        price: int.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        category: category,
        images: images,
        ref: ref,
      );
    }
  }

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
          title: const Text(
            "Add Product",
            style: TextStyle(
                color: Colors.black, fontSize: 23, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                images.isEmpty
                    ? DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(7),
                        dashPattern: const [10, 5],
                        child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                InkWell(
                                  onTap: selectProductImage,
                                  child: const Icon(
                                    Icons.folder_open_outlined,
                                    size: 45,
                                  ),
                                ),
                                Text(
                                  "Select Product Images",
                                  style: TextStyle(color: Colors.grey.shade400),
                                )
                              ],
                            )),
                      )
                    : CarouselSlider(
                        items: images
                            .map((e) => Builder(
                                builder: (context) => Image.file(
                                      e,
                                      fit: BoxFit.cover,
                                      height: 200,
                                    )))
                            .toList(),
                        options:
                            CarouselOptions(viewportFraction: 1, height: 200)),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: _nameController, hintText: "Product Name"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: "Description",
                  maxLines: 7,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _priceController,
                  hintText: "Price",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _quantityController,
                  hintText: "Quantity",
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SignUpButton(
                    onTap: () {
                      sellProduct(context);
                    },
                    text: "Sell"),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
