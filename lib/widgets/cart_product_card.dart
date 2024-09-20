import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/controller/cart_controller.dart';
import 'package:whitesupermarketapp/controller/item_view_controller.dart';
import 'package:whitesupermarketapp/modal/product.dart';
import 'package:whitesupermarketapp/view/item_view_screen.dart';

import '../util/colors.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard(this.product, this.cartController, this.itemViewController, {Key? key}) : super(key: key);
  final Product product;
  final CartController cartController;
  final ItemViewController itemViewController;

  /* @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {*/
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        itemViewController.selectedProduct.value = product;
        itemViewController.scrollController.jumpTo(0);
        Get.to(() => ItemViewScreen());
      },
      child: Container(
        // height: 200,
        // width: (MediaQuery.of(context).size.width / 2) - 10,
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white, // Change this to your desired color
            borderRadius: BorderRadius.circular(10), // Change this to your desired border radius
            /*boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Change this to your desired shadow color
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // Change this to your desired offset
              ),
            ],*/
          ),
         child:Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 7,
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      (product.item_image.toLowerCase().isEmpty)
                          ?Image.asset('assets/images/no-image-icon-15.png',
                              height: 100,
                              width: 100,
                            )
                          :Image.memory(base64Decode(product.item_image),
                              width: 100,
                              height: 100,
                            ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          product.item_name,
                          style: const TextStyle(color: primary, fontSize: 14, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Obx(() => Text(
                              '₹${(double.parse(product.offer_price) * int.parse(product.cartCount.value.toString()))}/-',
                              style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.w500),
                            )),
                            const SizedBox(width: 8),
                            Obx(() => Text(
                              '₹${(int.parse(product.item_mrp) * int.parse(product.cartCount.value.toString()))}/-',
                              style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                            )),
                          ],
                        ),
                        Obx(() => Text('Saving ₹${((double.parse(product.item_mrp) - double.parse(product.offer_price)).toDouble())*int.parse(product.cartCount.value.toString())}',
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        )),
                        const SizedBox(height: 5),
                        Row(
                          children: List.generate(5, (index) {
                            Color color = primary;
                            double review = product.customerReview;
                            int fullStars = review.floor();
                            bool hasHalfStar = review - fullStars > 0;
                            if (index < fullStars) {
                              return Icon(
                                Icons.star,
                                color: color,
                                size: 15,
                              );
                            } else if (hasHalfStar && index == fullStars) {
                              return Icon(
                                Icons.star_half,
                                color: color,
                                size: 15,
                              );
                            } else {
                              return Icon(
                                Icons.star_border,
                                color: color,
                                size: 15,
                              );
                            }
                          }),
                        ),
                        // Text(
                        //   '₹${product.mrp}',
                        //   style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                        // ),
                        // Text(
                        //   '${product.id}',
                        //   style: const TextStyle(color: Colors.grey),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Row(
                children: [
                  Flexible(
                    flex: 7,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              removeFromCart();
                            },
                            child: Container(
                                width: 30,
                                decoration: const BoxDecoration(
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('-', style: TextStyle(color:Colors.red, fontWeight:FontWeight.bold, fontSize: 25)),
                                  ],
                                )),
                          ),
                          /*TextButton(
                              onPressed: () {
                                removeFromCart();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(0.2)),
                                  foregroundColor: MaterialStateProperty.all(Colors.red),
                                  minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                      borderRadius: BorderRadiusDirectional.only(
                                          bottomEnd: Radius.circular(0),
                                          topStart: Radius.circular(7),
                                          topEnd: Radius.circular(0),
                                          bottomStart: Radius.circular(7))))),
                              child: const Text('-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),*/
                          Text(
                            '${product.cartCount}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          GestureDetector(
                            onTap: () {
                              addToCart();
                            },
                            child: Container(
                                width: 30,
                                decoration: const BoxDecoration(
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('+', style: TextStyle(color:Colors.green, fontWeight:FontWeight.bold, fontSize: 25)),
                                  ],
                                )
                            ),
                          ),
                          /*rTextButton(
                              onPressed: () {
                                addToCart();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green.withOpacity(0.2)),
                                  foregroundColor: MaterialStateProperty.all(Colors.green),
                                  minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                      borderRadius: BorderRadiusDirectional.only(
                                          bottomEnd: Radius.circular(7),
                                          topStart: Radius.circular(0),
                                          topEnd: Radius.circular(7),
                                          bottomStart: Radius.circular(0))))),
                              child: const Text('+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),*/
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // removeAllFromCart();
                          showRemoveItemFromCartDialog();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(primary),
                            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.only(
                                    bottomEnd: Radius.circular(25),
                                    topStart: Radius.circular(25),
                                    topEnd: Radius.circular(25),
                                    bottomStart: Radius.circular(25))))),
                        child: const Text('Remove From Cart', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                ],
              ),
            ),

          ],
        )
      ),
    );
  }

  void addToCart() {
    product.cartCount.value = cartController.addItemToCart(product);
  }

  void removeFromCart() {
    product.cartCount.value = cartController.removeItemFromCart(product);
  }

  void removeAllFromCart() {
    product.cartCount.value = cartController.removeAllItemFromCart(product);
  }

  showRemoveItemFromCartDialog() async {
    // showDialog<void>(
    //   context: context,
    //   barrierDismissible: true, // false = user must tap button, true = tap outside dialog
    //   builder: (BuildContext dialogContext) {
    //r
    //   },
    // );
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Remove Item', style: TextStyle(color: primary,fontWeight: FontWeight.w500)),
      content: Container(
        height: MediaQuery.of(Get.context!).size.height * 0.25,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 7,
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      (product.item_image.toLowerCase().isEmpty)
                          ?Image.asset('assets/images/no-image-icon-15.png',
                        height: 100,
                        width: 100,
                      )
                          :Image.memory(base64Decode(product.item_image),
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            product.item_name,
                            style: const TextStyle(color: primary, fontSize: 14, fontWeight: FontWeight.w500),
                            maxLines: 2,
                          ),
                        const SizedBox(height: 5),
                        Obx(() => Text('Saving ₹${((double.parse(product.item_mrp) - double.parse(product.offer_price))*product.cartCount.value).toDouble()}',
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        )),
                        //Obx(() => Text('Saving ₹${((double.parse(product.item_mrp) - double.parse(product.offer_price)).toDouble())*int.parse(product.cartCount.value.toString())}',
                        //  style: const TextStyle(color: Colors.red, fontSize: 12),
                        //)),
                        Row(
                          children: [
                            Obx(() => Text(
                              '₹${(double.parse(product.offer_price) * int.parse(product.cartCount.value.toString()))}/-',
                              style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.w500),
                            )),
                            const SizedBox(width: 8),

                          ],
                        ),
                        Obx(() => Text(
                          '₹${(int.parse(product.item_mrp) * int.parse(product.cartCount.value.toString()))}/-',
                          style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                        )),
                        const SizedBox(height: 5),
                        Row(
                          children: List.generate(5, (index) {
                            Color color = primary;
                            double review = product.customerReview;
                            int fullStars = review.floor();
                            bool hasHalfStar = review - fullStars > 0;
                            if (index < fullStars) {
                              return Icon(
                                Icons.star,
                                color: color,
                                size: 15,
                              );
                            } else if (hasHalfStar && index == fullStars) {
                              return Icon(
                                Icons.star_half,
                                color: color,
                                size: 15,
                              );
                            } else {
                              return Icon(
                                Icons.star_border,
                                color: color,
                                size: 15,
                              );
                            }
                          }),
                        ),
                        // Text(
                        //   '₹${product.mrp}',
                        //   style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                        // ),
                        // Text(
                        //   '${product.id}',
                        //   style: const TextStyle(color: Colors.grey),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('Do you want to remove this item from Cart?'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Yes', style: TextStyle(color: primary)),
          onPressed: () {
            removeAllFromCart();
            Get.back(); // Dismiss alert dialog
          },
        ),
        TextButton(
          child: const Text('No', style: TextStyle(color: primary)),
          onPressed: () {
            Get.back(); // Dismiss alert dialog
          },
        ),
      ],
    ));
  }

}
