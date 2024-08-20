import 'dart:convert';
import 'package:auto_animated/auto_animated.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whitesupermarketapp/controller/cart_controller.dart';
import 'package:whitesupermarketapp/controller/home_controller.dart';
import 'package:whitesupermarketapp/controller/item_view_controller.dart';
import 'package:whitesupermarketapp/controller/nav_drawer_controller.dart';
import 'package:whitesupermarketapp/widgets/product_card.dart';
import '../controller/my_account_controller.dart';
import '../util/colors.dart';
import '../widgets/toast_message.dart';

class ItemViewScreen extends StatefulWidget {
  ItemViewScreen({Key? key}) : super(key: key);

  @override
  _ItemViewScreenState createState() => _ItemViewScreenState();
}

class _ItemViewScreenState extends State<ItemViewScreen> {


  final ItemViewController controller = Get.find<ItemViewController>();
  final MyAccountController myAccountController = Get.find();
  final CartController cartController = Get.find();
  final HomeController homeController = Get.find();
  final NavDrawerController navDrawerController = Get.find();


  @override
  void initState() {
    super.initState();

    controller.gridChildren.clear();
    controller.token.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.gridChildren.clear();
        controller.token.value = false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.selectedProduct.value!.item_name,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w400, fontSize: 18)),
          actions: [
            Flexible(
              child: IconButton(
                onPressed: () {
                  Share.share('${controller.selectedProduct.value!.item_name} at Price ₹${controller.selectedProduct.value!.offer_price} only on White CloudSupermarket App. Download the app now. https://play.google.com/store/apps/');
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
                  Navigator.pop(context);
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
        floatingActionButton: DraggableFab(
          child: Container(
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
            padding: const EdgeInsets.only(left:4,right:4,top:4,bottom:30),
            child: FloatingActionButton(
              backgroundColor: primary,
              onPressed: () {
                homeController.callHelp();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: const Icon(Icons.call,color: Colors.white),
            ),
          ),
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.callHelp();
          },
          child: const Icon(Icons.call),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,*/
        bottomNavigationBar: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: controller.bottomBarHeight.value,
            color: primary,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: controller.selectedProduct.value!.instock_outstock_indication == 0 ? null : () {
                          controller.selectedProduct.value!.cartCount.value =
                              cartController.removeItemFromCart(controller.selectedProduct.value!);
                          controller.update();
                        },
                        icon: const Icon(
                          Icons.remove,
                          color: white,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: Center(
                          child: Obx(
                            () => Text(
                              '${controller.selectedProduct.value!.cartCount}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:controller.selectedProduct.value!.instock_outstock_indication == 0? (){
                          createToast('This product is temporarily out of stock', Colors.red);
                        } : () {
                          controller.selectedProduct.value!.cartCount.value =
                              cartController.addItemToCart(controller.selectedProduct.value!);
                          controller.update();
                        },
                        icon: const Icon(
                          Icons.add,
                          color: white,

                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: controller.selectedProduct.value!.instock_outstock_indication == 0?(){
                      createToast('This product is temporarily out of stock',Colors.red);
                    }: () {
                      controller.selectedProduct.value!.cartCount.value =
                          cartController.addItemToCart(controller.selectedProduct.value!);
                      // controller.update();
                    },
                    child: Container(
                      color: secondary,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/logo/whitelogo.svg',
                              height: 14,
                              color: white,

                            ),
                            const SizedBox(width: 5,),
                            const Text('Add to Cart',style:TextStyle(color: white,fontSize: 15,fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Obx(
          () => CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: greylight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: (controller.selectedProduct.value!.item_image.toLowerCase() == "imgurl")
                            ? Image.asset(
                                "assets/images/garam_masala.png",
                                fit: BoxFit.fitWidth,
                              )
                            : Container(
                          padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
                                  child: Image.memory(base64Decode(controller.selectedProduct.value!.item_image),
                                      fit: BoxFit.fitWidth,
                                    ),
                                ),
                              ),
                            ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                           vertical: 30.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      controller.selectedProduct.value!.item_name,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration:  BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:40.0,right: 40.0,top: 2.0,bottom: 2.0),
                                      child: Text(
                                        "₹${controller.selectedProduct.value!.offer_price}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0,),
                                  Text(
                                    "₹${controller.selectedProduct.value!.item_mrp}",
                                    style: const TextStyle(
                                      color: black54,
                                      fontSize: 15,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "You are saving ₹${double.parse((double.parse(controller.selectedProduct.value!.item_mrp) - double.parse(controller.selectedProduct.value!.offer_price)).toStringAsFixed(2))}",
                                style: const TextStyle(
                                  color: black54,
                                ),
                              ),

                              controller.selectedProduct.value!.instock_outstock_indication == 0?
                              const Column(
                                children: [
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "Temporarily Out of Stock",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ): const Text(
                                "",
                                style: TextStyle(
                                  color: green,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                controller.selectedProduct.value!.item_discription,
                                style: const TextStyle(
                                  color: black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Customer review ${controller.selectedProduct.value!.customerReview}",
                                        style: const TextStyle(
                                          color: black54,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      /*Row(
                                        children: List.generate(5, (index) {
                                          Color color = primary;
                                          if (index  < controller.selectedProduct.value!.customerReview) {
                                            return Icon(
                                              Icons.star,
                                              color: color,
                                              size: 15,
                                            );
                                          } else if (index + 0.5 == controller.selectedProduct.value!.customerReview) {
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
                                      ),*/
                                      Row(
                                        children: List.generate(5, (index) {
                                          Color color = primary;
                                          double review = controller.selectedProduct.value!.customerReview;
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
                                    ],
                                  ),
                                ],
                              ),

                              Container(
                                  child: myAccountController.defaultAddress.value == null
                                      ?
                                  Column(
                                    children: [
                                      const SizedBox(height: 20.0,),
                                      GestureDetector(
                                        onTap: () {
                                          myAccountController.showMyAddressesOverLay();
                                        },
                                        child: Center(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width*.85,
                                              decoration: BoxDecoration(
                                                color: greylight,
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Center(child: Text('ADD ADDRESS',style: TextStyle(color: primary, fontWeight: FontWeight.w500,))),
                                              ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                    :Column(
                                    children: [
                                      const SizedBox(height: 10.0,),
                                      const Divider(
                                        color: black26,
                                        height: 10.0,
                                        thickness: 2.0,
                                      ),
                                      SizedBox(
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
                                                //const SizedBox(height: 10),
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
                                                child: const Text('Change',style: TextStyle(color: primary),)),
                                          ],
                                        ),
                                        /*Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: (myAccountController.defaultAddress.value) != null
                                            ? Container()
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Deliver to: ${controller.address["line1"]},",
                                                  ),
                                                  Text(
                                                    "${controller.address["pincode"]}",
                                                  ),
                                                  Text(
                                                    "${controller.address["line2"]}",
                                                    style: const TextStyle(
                                                      color: black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: white,
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          controller.isAddressSaved.value ? "Change" : "Add Address",
                                          style: const TextStyle(
                                            color: primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*/
                                      ),
                                      const Divider(
                                        color: black26,
                                        thickness: 2.0,
                                        height: 10.0,
                                      ),
                                      const SizedBox(height: 20.0,),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.local_shipping,
                                            color: blue,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text("FREE Delivery Available"),
                                        ],
                                      ),
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.payments,
                                            color: green,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text("Cash On Delivery Available"),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0,),
                                    ],
                                  )),

                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Similar Items",
                          style: TextStyle(
                            color: black54,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () {
                  controller.sortByTags(controller.selectedProduct.value!.tags);
                  return controller.gridChildren.isNotEmpty
                      ? LiveSliverGrid.options(
                          itemBuilder: buildAnimatedItem,
                          controller: controller.scrollController,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 6 / 7),
                          itemCount: controller.gridChildren.length,
                          // shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),

                          options: const LiveOptions(
                            // Start animation after (default zero)
                            delay: Duration(milliseconds: 100),

                            // Show each item through (default 250)
                            showItemInterval: Duration(milliseconds: 250),

                            // Animation duration (default 250)
                            showItemDuration: Duration(milliseconds: 250),

                            // Animations starts at 0.05 visible
                            // item fraction in sight (default 0.025)
                            visibleFraction: 0.025,

                            // Repeat the animation of the appearance
                            // when scrolling in the opposite direction (default false)
                            // To get the effect as in a showcase for ListView, set true
                            reAnimateOnVisibility: false,
                          ),
                        )
                      : const SliverToBoxAdapter(
                    child: SizedBox(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            CircularProgressIndicator(color: primary,),
                            SizedBox(height: 20),
                            Text('Loading...',),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build animated item (helper for all examples)
  Widget buildAnimatedItem(BuildContext context, int i, Animation<double> animation) =>
      // For example wrap with fade transition
      FadeTransition(
        key: UniqueKey(),
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        // And slide transition
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          // Paste you Widget
          child: Container(
            color: greylight,
              child: ProductCard(controller.gridChildren[i], cartController, controller, true)),
        ),
      );
}
