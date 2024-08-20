import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/controller/cart_controller.dart';
import 'package:whitesupermarketapp/controller/nav_drawer_controller.dart';
import 'package:whitesupermarketapp/util/colors.dart';


class CheckoutController extends GetxController {
  RxInt pageIndex = RxInt(0);
  final PageController pageController = PageController();
  RxInt selectedPaymentMethod = RxInt(1);

  void nextStep() {
    if (pageController.page! < 2) {
      pageController.jumpToPage(pageIndex.value + 1);
      // pageController.nextPage(duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
      //print(pageController.page);
      pageIndex.value = pageController.page!.toInt();
    } else if (pageController.page == 2.0) {
      placeOrder();
    }
  }

  void previousStep() {
    if (pageController.page! > 0) {
      pageController.jumpToPage(pageIndex.value - 1);
      // pageController.nextPage(duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
      //print(pageController.page);
      pageIndex.value = pageController.page!.toInt();
    }
  }

  void placeOrder() async {
    AssetImage successGif = const AssetImage('assets/gif/successfully_done.gif');
    CartController.to.clearCart();
    Get.dialog(
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(20),border: Border.all(color: primary,width: 2)),
              clipBehavior: Clip.hardEdge,
              height: Get.width * 0.75,
              width: Get.width * 0.75,
              child: Image(
                image: successGif,
                height: Get.width * 0.65,
                width: Get.width * 0.65,
              ),
            ),
          ),
        ),
        barrierColor: Colors.transparent);
    await Future.delayed(const Duration(milliseconds: 1500));
    successGif.evict();
    Get.back();
    Get.back();
    NavDrawerController.to.selectIndex(2);
    Get.snackbar('Order Placed', 'Your order has been placed successfully');
  }
}
