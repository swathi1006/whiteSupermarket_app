import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/controller/checkout_controller.dart';
import 'package:whitesupermarketapp/widgets/toast_message.dart';
import '../controller/cart_controller.dart';
import '../controller/home_controller.dart';
import '../controller/my_account_controller.dart';
import '../controller/item_view_controller.dart';
import '../controller/nav_drawer_controller.dart';
import '../database/global.dart';
import '../database/mongo.dart';
import '../modal/order.dart';
import '../modal/invoice.dart';
import '../modal/product.dart';
import '../util/colors.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  final NavDrawerController navDrawerController = Get.find();
  final ItemViewController itemViewController = Get.find();
  final HomeController homeController = Get.find();
  final CartController cartController = Get.find();
  final MyAccountController myAccountController = Get.find();
  final CheckoutController checkoutController = Get.put(CheckoutController());


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (checkoutController.pageIndex.value == 0) {
          return true;
        } else {
          checkoutController.previousStep();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          actions: [
            Flexible(
              child: IconButton(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  homeController.shareApp();
                },
                icon: const Icon(
                  Icons.share,
                  size: 20,
                ),
              ),
            ),
            Flexible(
              child: IconButton(
                onPressed: () {
                  navDrawerController.selectIndex(3);
                },
                icon: SizedBox(
                  height: 36,
                  width: 25,
                  child: Obx(
                        () => Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 16,
                            child: SvgPicture.asset(
                              'assets/logo/whitelogo.svg',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (cartController.cart.isNotEmpty)
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: secondary,shape: BoxShape.circle),
                              child: Text('${cartController.cart.length}',style: const TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: Obx(
          () => SafeArea(
            child: Column(
              children: [
                pageIndicator(),
                const SizedBox(height: 10),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: checkoutController.pageController,
                    children: [addressPage(), orderDetailsPage(), paymentPage()],
                  ),
                ),
                if (checkoutController.pageIndex.value == 0)
                  InkWell(
                    onTap: () {
                      if (myAccountController.defaultAddress.value != null) {
                        checkoutController.nextStep();
                      } else {
                        createToast('Please Select Delivery Address',Colors.black);
                      }
                    },
                    child: Container(
                      color: primary,
                      height: 50,
                      child: const Center(
                        child: Text(
                          'DELIVER HERE',
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
                  )
                else if (checkoutController.pageIndex.value == 1)
                  Container(
                    color: white,
                    height: 50,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₹${cartController.cartTotal.value.toStringAsFixed(1)}/-',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Text('Total Price')
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              checkoutController.nextStep();
                            },
                            child: Container(
                              color: primary,
                              child: const Center(
                                child: Text(
                                  'CONTINUE',
                                  style: TextStyle(color: white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (checkoutController.pageIndex.value == 2)
                  Container(
                    color: white,
                    height: 50,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₹${cartController.cartTotal.value.toStringAsFixed(1)}/-',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Text('Total Price')
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              List<Item> items = cartController.cart.map((product) => Item(
                                product.id,
                                product.item_name,
                                product.item_image,
                                product.cartCount.value,
                                double.parse(product.offer_price),
                              )).toList();

                              List<ItemInvoice> itemInvoice = cartController.cart.map((product) => ItemInvoice(
                                product.id,
                                product.item_code,
                                product.item_name,
                                double.parse(product.item_mrp),
                                double.parse(product.offer_price),
                                double.parse(product.discount),
                                product.cartCount.value,
                              )).toList();

                              String userName = myAccountController.defaultAddress.value!.name;
                              String mobile = myAccountController.defaultAddress.value!.mobile;
                              String address = myAccountController.defaultAddress.toString();
                              double total = cartController.cartTotal.value;
                              var time = DateTime.now();
                              String id = time.millisecondsSinceEpoch.toString();
                              myAccountController.addOrders(id, items, total, time);
                              myAccountController.addInvoice(id, UserId, userName, mobile, address, itemInvoice, total, time);
                              deleteCartItems();
                              checkoutController.nextStep();
                            },
                            child: Container(
                              color: primary,
                              child: const Center(
                                child: Text(
                                  'PLACE ORDER',
                                  style: TextStyle(color: white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pageIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
          /*BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, -3), // changes position of shadow
          ),*/
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: checkoutController.pageIndex.value == 0 ? secondary : primary),
              child: Text(
                '1',
                style: TextStyle(color: checkoutController.pageIndex.value == 0 ? black : white),
              ),
            ),
            SizedBox(width: Get.width * 0.2, child: const Divider(color: black26)),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: checkoutController.pageIndex.value == 1
                      ? secondary
                      : checkoutController.pageIndex.value == 0
                          ? white
                          : primary),
              child: Text(
                '2',
                style: TextStyle(
                    color: checkoutController.pageIndex.value == 1 || checkoutController.pageIndex.value == 0 ? black : white),
              ),
            ),
            SizedBox(width: Get.width * 0.2, child: const Divider(color: black26)),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: checkoutController.pageIndex.value == 2
                      ? secondary
                      : checkoutController.pageIndex.value < 2
                          ? white
                          : primary),
              child: Text(
                '3',
                style: TextStyle(
                    color: checkoutController.pageIndex.value == 2 || checkoutController.pageIndex.value < 2 ? black : white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
              /*BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, -3), // changes position of shadow
          ),*/
            ],
          ),
          child: const Text(
            'Confirm your Delivery Address',
            style: TextStyle(color: grey),
          ),
        ),
        const SizedBox(height: 5),
        if (myAccountController.defaultAddress.value != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
                /*BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, -3), // changes position of shadow
          ),*/
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myAccountController.defaultAddress.value!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      '${myAccountController.defaultAddress.value!.addressLine1}, ${myAccountController.defaultAddress.value!.addressLine2}',
                    ),
                    Text(
                      '${myAccountController.defaultAddress.value!.city}-${myAccountController.defaultAddress.value!.pincode}',
                    ),
                    Text(
                      myAccountController.defaultAddress.value!.state,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '+91${myAccountController.defaultAddress.value!.mobile}',
                    ),
                  ],
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white), // Set the background color to red
                    ),
                    onPressed: () {
                      myAccountController.showMyAddressesOverLay();
                    },
                    child: const Text('Edit',style: TextStyle(color: primary),)),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
                /*BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, -3), // changes position of shadow
          ),*/
              ],
            ),
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Column(
              children: [
                const Text(
                  'No Address found',
                  style: TextStyle(color: grey),
                ),
                ElevatedButton(
                  onPressed: () {
                    myAccountController.showAddAddressDialog();
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.only(
                              bottomEnd: Radius.circular(0),
                              topStart: Radius.circular(0),
                              topEnd: Radius.circular(20),
                              bottomStart: Radius.circular(20))))),
                  child: const Text('Add Address'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget orderDetailsPage() {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (myAccountController.defaultAddress.value != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  myAccountController.defaultAddress.value!.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '${myAccountController.defaultAddress.value!.addressLine1}, ${myAccountController.defaultAddress.value!.addressLine2}',
                ),
                Text(
                  '${myAccountController.defaultAddress.value!.city}-${myAccountController.defaultAddress.value!.pincode}',
                ),
                Text(
                  myAccountController.defaultAddress.value!.state,
                ),
                const SizedBox(height: 10),
                Text(
                  '+91${myAccountController.defaultAddress.value!.mobile}',
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),),
                    onPressed: () {
                      myAccountController.showMyAddressesOverLay();
                    },
                    child: const Text('Change Address',style: TextStyle(color: primary,))),
              ],
            ),
          ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, labelText: 'Coupon Code'),
                  enabled: false,
                ),
              ),
              const SizedBox(width: 8),
              const ElevatedButton(onPressed: null, child: Text('Apply'))
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: const Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.delivery_dining_rounded,
                    color: blue,
                  ),
                  SizedBox(width: 5),
                  Text('FREE Delivery Available')
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.money_rounded,
                    color: green,
                  ),
                  SizedBox(width: 5),
                  Text('Cash on Delivery Available')
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Obx(
          () => ListView.builder(
            itemBuilder: (ctx, index) => itemCard(cartController.cart[index]),
            itemCount: cartController.cart.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        )
      ],
    );
  }

  Widget itemCard(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white, // Change this to your desired color
          borderRadius: BorderRadius.circular(10), // Change this to your desired border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Change this to your desired shadow color
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3), // Change this to your desired offset
            ),
          ],
        ),
        child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 8,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              product.item_name,
                              style: const TextStyle(color:primary, fontSize: 15, fontWeight: FontWeight.w400),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Obx(() => Text(
                              '₹${(double.parse(product.offer_price) * int.parse(product.cartCount.value.toString()))}/-',                          style: const TextStyle(color: Colors.green, fontSize: 20),
                            )),
                            const SizedBox(height: 10),
                            Text(
                              '₹${product.item_mrp}',
                              style: const TextStyle(color: grey, decoration: TextDecoration.lineThrough, fontSize: 16),
                            ),
                            Obx(() => Text('Saving ₹${((double.parse(product.item_mrp) - double.parse(product.offer_price)).toDouble())*int.parse(product.cartCount.value.toString())}',
                              style: const TextStyle(color: green, fontSize: 16),
                            )),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: Column(
                        children: [
                          (product.item_image.toLowerCase() == "imgurl")
                              ? Image.asset(
                                  'assets/images/garam_masala.png',
                                  height: 100,
                                  width: 100,
                                )
                              : Image.memory(base64Decode(product.item_image),
                                  width: 100,
                                  height: 100,
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<int>(
                              isDense: true,
                              items: const [
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Qty: 1'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('Qty: 2'),
                                ),
                                DropdownMenuItem(
                                  value: 3,
                                  child: Text('Qty: 3'),
                                ),
                                DropdownMenuItem(
                                  value: 4,
                                  child: Text('Qty: 4'),
                                ),
                                DropdownMenuItem(
                                  value: 5,
                                  child: Text('Qty: 5'),
                                ),
                                DropdownMenuItem(
                                  value: 6,
                                  child: Text('Qty: 6'),
                                ),
                                DropdownMenuItem(
                                  value: 7,
                                  child: Text('Qty: 7'),
                                ),
                                DropdownMenuItem(
                                  value: 8,
                                  child: Text('Qty: 8'),
                                ),
                                DropdownMenuItem(
                                  value: 9,
                                  child: Text('Qty: 9'),
                                ),
                              ],
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Qty',
                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12)),
                              onChanged: (value) {
                                product.cartCount.value = value!;
                                cartController.calculateCartTotal();
                              },
                              value: product.cartCount.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
      )

    );
  }

  Widget paymentPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select a Payment Option',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              RadioListTile(
                value: 1,
                groupValue: checkoutController.selectedPaymentMethod.value,
                onChanged: (value) {
                  checkoutController.selectedPaymentMethod.value = value!;
                },
                title: const Text('Cash On Delivery'),
              ),
              const Divider(
                thickness: 1,
                color: black26,
              ),
              RadioListTile(
                value: 2,
                groupValue: checkoutController.selectedPaymentMethod.value,
                // onChanged: (value) {
                //   checkoutController.selectedPaymentMethod.value=value!;},
                onChanged: null,
                title: const Text('Credit/Debit Card'),
                toggleable: false,
              ),
              const Divider(
                thickness: 1,
                color: black26,
              ),
              RadioListTile(
                value: 3,
                groupValue: checkoutController.selectedPaymentMethod.value,
                // onChanged: (value) {
                //   checkoutController.selectedPaymentMethod.value=value!;},
                onChanged: null,
                title: const Text('Net Banking'),
                toggleable: false,
              ),
              const Divider(
                thickness: 1,
                color: black26,
              ),
              RadioListTile(
                value: 4,
                groupValue: checkoutController.selectedPaymentMethod.value,
                // onChanged: (value) {
                //   checkoutController.selectedPaymentMethod.value=value!;},
                onChanged: null,
                title: const Text('UPI'),
                toggleable: false,
              ),
              const Divider(
                thickness: 1,
                color: black26,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
