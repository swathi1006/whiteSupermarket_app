import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../database/mongo.dart';
import '../modal/product.dart';

class CartController extends GetxController {
  static CartController get to =>Get.find();
  RxList<Product> cart = RxList.empty();
  RxDouble cartTotal = RxDouble(0.0);
  TextEditingController searchbarController = TextEditingController();
  FocusNode searchBarFocusNode = FocusNode();

  void calculateCartTotal() {
    cartTotal.value = 0.0;
    for (var element in cart) {
      cartTotal.value += double.parse(element.offer_price) * element.cartCount.value;
    }
  }

  void addData(Product productData, int count) {
    productData.cartCount.value = count;
    cart.add(productData);
    calculateCartTotal();
  }



  int addItemToCart(Product p) {
    Product? product = cart.firstWhereOrNull((element) => element.id == p.id);
    if (product != null) {
      final index = cart.indexWhere((element) => element.id == p.id);
      cart[index].cartCount++;
      calculateCartTotal();
      updateCartItem(p.id ,cart[index].cartCount.value);
      return cart[index].cartCount.value;
    } else {
      p.cartCount.value = 1;
      cart.add(p);
      addCartItem(p);
      calculateCartTotal();
      return p.cartCount.value;
    }
  }

  int removeItemFromCart(Product p) {
    int index = cart.lastIndexWhere((element) => element.id == p.id);
    if (cart[index].cartCount > 1) {
      cart[index].cartCount--;
      calculateCartTotal();
      updateCartItem(p.id ,cart[index].cartCount.value);
      return cart[index].cartCount.value;
    } else {
      cart[index].cartCount.value = 0;
      cart.removeAt(index);
      //print('cart length: ${p.id}');
      deleteCartItem(p.id);
      calculateCartTotal();
      return 0;
    }
  }

  int removeAllItemFromCart(Product p) {
    int index = cart.lastIndexWhere((element) => element.id == p.id);
    cart.removeAt(index);
    deleteCartItem(p.id);
    calculateCartTotal();
    return 0;
  }
  void clearCart(){
    for(int i=0;i<cart.length;i++){
      cart[i].cartCount.value=0;
    }
    cart.clear();
    calculateCartTotal();
  }
}
