import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/controller/cart_controller.dart';
import 'package:whitesupermarketapp/controller/item_view_controller.dart';
import 'package:whitesupermarketapp/controller/nav_drawer_controller.dart';
import 'package:whitesupermarketapp/view/checkout_screen.dart';
import 'package:whitesupermarketapp/widgets/cart_product_card.dart';

import '../controller/item_list_view_controller.dart';
import '../util/colors.dart';

class MyCartScreen extends StatelessWidget {
  MyCartScreen({Key? key}) : super(key: key);
  final CartController controller = Get.find();
  final ItemListViewController itemListViewController = Get.find();
  final ItemViewController itemViewController = Get.find();
  final NavDrawerController navDrawerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navDrawerController.selectIndex(0);
        return false;
      },
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: primary,
              // decoration: const BoxDecoration(
              //     color: primary, borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0,left:8,right:8),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Search My Cart',
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: textHintWhite),
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller.searchBarFocusNode.requestFocus();
                          },
                          icon: const Icon(
                            Icons.search,
                            color: white,
                          ))),
                  controller: controller.searchbarController,
                  focusNode: controller.searchBarFocusNode,
                  style: const TextStyle(color: white),
                  cursorColor: textHintWhite,
                ),
              ),
            ),
            // const SizedBox(height: 15),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: greylight,
                    borderRadius: BorderRadiusDirectional.only(
                        bottomEnd: Radius.circular(0),
                        topStart: Radius.circular(0),
                        topEnd: Radius.circular(0),
                        bottomStart: Radius.circular(0))),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: controller.cart.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                    mainAxisAlignment: controller.cart.isNotEmpty ? MainAxisAlignment.start : MainAxisAlignment.center,
                    children: [
                      if (controller.cart.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'My Cart: ${controller.cart.length} Item${controller.cart.length > 1 ? 's' : ''}',
                            style: const TextStyle(color: primary, fontSize: 16),
                          ),
                        ),
                        // const SizedBox(height: 15),
                        ListView.builder(
                          itemBuilder: (ctx, index) => CartProductCard(controller.cart[index], controller, itemViewController),
                          itemCount: controller.cart.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ] else ...[
                        SizedBox(height : MediaQuery.of(context).size.height * 0.1),
                        Image.asset('assets/images/empty_cart.png'),
                        const SizedBox(height: 20),
                        const Text(
                          'Oops! Your cart looks Empty.\nTo Start Shopping',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: primary, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              navDrawerController.selectIndex(0);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(white),
                                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                    borderRadius: BorderRadiusDirectional.only(
                                        bottomEnd: Radius.circular(25),
                                        topStart: Radius.circular(25),
                                        topEnd: Radius.circular(25),
                                        bottomStart: Radius.circular(25))))),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Go to Home',
                                style: TextStyle(fontSize: 16, color: primary),
                              ),
                            ),
                          ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.cart.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        Get.to(() => CheckoutScreen());
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Checkout',
                                        style: TextStyle(color: white),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Obx(
                                        () => Text(
                                          '₹${controller.cartTotal}',
                                          style: const TextStyle(color: white),
                                        ),
                                      ),
                                      const Center(
                                        child: Icon(
                                          Icons.arrow_forward_rounded,
                                          color: white,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
