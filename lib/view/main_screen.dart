import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/controller/nav_drawer_controller.dart';
import 'package:whitesupermarketapp/view/home_screen.dart';
import 'package:whitesupermarketapp/view/my_account_screen.dart';
import 'package:whitesupermarketapp/view/my_cart_screen.dart';
import 'package:whitesupermarketapp/view/my_order_screen.dart';
import '../controller/cart_controller.dart';
import '../controller/home_controller.dart';
import '../controller/item_list_view_controller.dart';
import '../controller/item_view_controller.dart';
import '../controller/my_account_controller.dart';
import '../util/colors.dart';
import '../widgets/nav_drawer.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  final NavDrawerController navDrawerController = Get.put(NavDrawerController());
  final ItemViewController itemViewController = Get.put(ItemViewController());
  final ItemListViewController itemListViewController = Get.put(ItemListViewController());
  final HomeController homeController = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());
  final MyAccountController myAccountController = Get.put(MyAccountController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (homeController.showSearchSuggestions.value) {
            homeController.searchBarFocusNode.unfocus();
            return false;
          }
          return true;
        },
        child: Scaffold(
          key: navDrawerController.scaffoldKey,
          drawer: NavDrawer(),
          appBar: AppBar(
            title: Text(navDrawerController.title.value),
            actions: [
              Flexible(
                child: IconButton(
                  onPressed: () {
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
          floatingActionButton: !homeController.showSearchSuggestions.value
              ? DraggableFab(
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
                    padding: const EdgeInsets.only(left:4,right:4,top:4,bottom:45),
                    child: FloatingActionButton(

                      backgroundColor: primary,
                      onPressed: () {
                        homeController.callHelp();
                      },
                      child: const Icon(Icons.call, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                )
              : null,
          body: [
            HomeScreen(),
            MyAccountScreen(),
            MyOrderScreen(),
            MyCartScreen(),
          ][navDrawerController.selectedIndex.value],
        ),
      ),
    );
  }
}
