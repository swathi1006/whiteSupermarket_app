import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/controller/item_list_view_controller.dart';
import 'package:whitesupermarketapp/modal/category.dart';
import 'package:whitesupermarketapp/util/colors.dart';
import 'package:whitesupermarketapp/view/item_list_view_screen.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(this.category,this.itemListViewController, {Key? key}) : super(key: key);

  final Category category;
  final ItemListViewController itemListViewController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(20),
              topStart: Radius.circular(20),
              topEnd: Radius.circular(20),
              bottomStart: Radius.circular(20)),
        ),
        clipBehavior: Clip.hardEdge,
        //color: secondary,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  category.imgUrl,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Container(
              height: 40,
              constraints: const BoxConstraints(minWidth: double.maxFinite),
              color: primary,
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      category.name=="Detergents"? "Cleaners & Detergents":category.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  )),
            )
          ],
        ),
      ),
      onTap: () {
        //controller.showProductCategory(category.name);
        itemListViewController.showProductCategory(category.name);
        itemListViewController.categoryController.text = category.name;

        Get.to(() => ItemListViewScreen());
      },
    );
  }
}
