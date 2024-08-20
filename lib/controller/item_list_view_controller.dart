import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/global.dart';
import '../database/mongo.dart';
import '../modal/product.dart';
import 'cart_controller.dart';
import 'home_controller.dart';
import 'item_view_controller.dart';

class ItemListViewController extends GetxController {
  final CartController cartController = Get.put(CartController());
  final ItemViewController itemViewController = Get.put(ItemViewController());
  final HomeController homeController = Get.put(HomeController());

  RxList<Product> get products => homeController.products;
  final ScrollController productScrollController = ScrollController();
  RxList<Product> gridChildren = RxList.empty();
  RxList<Product> gridChildrenOld = RxList.empty();
  bool nextScroll = true;
  RxBool isAddressSaved = true.obs;
  RxBool token = false.obs;
  RxDouble bottomBarHeight = RxDouble(60);
  Rx<Product?> selectedProduct = Rx(null);
  TextEditingController categoryController = TextEditingController();


  void showProductCategory(String Category) async{
    category = Category;
    globalitems = await MongoDB.getCategoryItems(category);
    for (var item in globalitems) {
      if (item['item_catogory'].contains(category)) {
        List<String> itemCategoryList = [];
        for (var itemCategory in item['item_catogory']) {
          itemCategoryList.add(itemCategory);
        }
        List<String> itemTagList = [];
        for (var itemTags in item['item_tags']) {
          itemTagList.add(itemTags);
        }
        Product newProduct = Product(
          item['_id'].toHexString(),
          item['item_code'],
          item['item_name'],
          item['item_mrp'].toString(),
          item['offer_price'].toString(),
          itemCategoryList,
          item['discount'].toString(),
          itemTagList,
          item['item_image'],
          item['stock_quantity'],
          item['item_discription'],
        );
        bool productExists = gridChildren.any((product) =>
        product.id == newProduct.id);
        if (!productExists) {
          gridChildren.add(newProduct);
        }
      }
    }
  }

  shareApp() {
    Share.share('Check out this app https://example.com');
  }

  callHelp() async {
    if (!await launchUrl(Uri.parse('tel:+9181380 66143'))) {
      throw 'Could not launch tel:+918138066143';
    }
  }
}
