import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/controller/cart_controller.dart';
import 'package:whitesupermarketapp/controller/item_view_controller.dart';
import 'package:whitesupermarketapp/modal/product.dart';
import 'package:whitesupermarketapp/util/colors.dart';
import 'package:whitesupermarketapp/view/item_view_screen.dart';


class ProductCard extends StatelessWidget {
  const ProductCard(this.product, this.cartController, this.itemViewController, this.fromProductDetailPage, {Key? key})
      : super(key: key);
  final Product product;
  final CartController cartController;
  final ItemViewController itemViewController;
  final bool fromProductDetailPage;

  bool isDouble(String str) {
    try {
      double.parse(str);
      return true;
    } catch (e) {
      return false;
    }
  }
 /* @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {*/
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        itemViewController.selectedProduct.value = product;
        if (fromProductDetailPage) {
          itemViewController.scrollController.jumpTo(0);
        }
        Get.to(() => ItemViewScreen());
      },
      child: SizedBox(
        height:700,
        child: Container(
           //height: 700,
          // width: (MediaQuery.of(context).size.width / 2) - 10,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white, // Change this to your desired color
            borderRadius: BorderRadius.circular(30), // Change this to your desired border radius

          ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (product.item_image.toLowerCase() == "item_image")
                              ? Image.asset('assets/images/garam_masala.png',
                                  height: 90,
                                  width: 90,
                                )
                              : Image.memory(base64Decode(product.item_image),
                                  width: 90,
                                  height: 90,
                                ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width *.3,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                        child: Text(
                          product.item_name.split(' ').take(6).join(' '),
                          style: const TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text('-----------------------------------', style: TextStyle(color: primary, fontWeight: FontWeight.w300)),],
                      ),
                      product.instock_outstock_indication<1
                          ?const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom:5.0),
                                child: Text('Out of Stock', style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w400)),
                              ),
                            ],
                          )
                        :Obx(()=> Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: product.cartCount.value == 0
                              ?
                          GestureDetector(
                            onTap: () {
                              addToCart();
                            },
                              child: SizedBox(
                                height: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom:5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/logo/whitelogo.svg',
                                          height: 13,
                                          color: secondary,

                                        ),
                                        const SizedBox(width: 5,),
                                        const Text('Add to Cart',style:TextStyle(color: primary,fontSize: 13,fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                  )

                              ),
                              )
                              : SizedBox(
                            height: 30,
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
                                            Text('-', style: TextStyle(color:Colors.red, fontWeight:FontWeight.bold, fontSize: 20)),
                                          ],
                                        )),
                                  ),
                                  Text(
                                        '${product.cartCount}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                                            Text('+', style: TextStyle(color:Colors.green, fontWeight:FontWeight.bold, fontSize: 20)),
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                                ),
                              ),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: secondary,
                    ),
                    margin: const EdgeInsets.only(top: 8,right: 8),
                    height: 50,
                    width: 50,
                    //color: secondary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('₹', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w300)),
                              Text(
                                product.item_mrp,
                                style: const TextStyle(color: Colors.white,fontSize: 9, decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [const Text('₹', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300)),
                              Text(product.offer_price.toString().contains('.') ?
                              '${product.offer_price}0 ' : product.offer_price,
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff999999),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0), // rectangular corner
                        topRight: Radius.circular(5), // curved corner
                        bottomRight: Radius.circular(5), // curved corner
                        bottomLeft: Radius.circular(0), // rectangular corner
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 25),
                    height: 18,
                    width: 60,
                    //color: secondary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        int.parse(product.discount) >= 9
                            ? Text('${product.discount}%', style: const TextStyle(color: white, fontSize: 10))
                            : Text('₹${(double.parse(product.item_mrp) - double.parse(product.offer_price)).toDouble()}',
                          style: const TextStyle(color: white, fontSize: 10),
                        ),
                        const Text(
                          ' OFF',
                          style: TextStyle(color: white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }



  void addToCart() {
      // product.cartCount++;
      product.cartCount.value = cartController.addItemToCart(product);
  }

  void removeFromCart() {
      // product.cartCount--;
      product.cartCount.value = cartController.removeItemFromCart(product);
  }
}
