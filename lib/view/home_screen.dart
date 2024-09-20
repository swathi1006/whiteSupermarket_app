import 'dart:convert';
import 'package:auto_animated/auto_animated.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/controller/home_controller.dart';
import 'package:whitesupermarketapp/controller/item_list_view_controller.dart';
import 'package:whitesupermarketapp/controller/nav_drawer_controller.dart';
import 'package:whitesupermarketapp/util/colors.dart';
import 'package:whitesupermarketapp/widgets/category_card.dart';
import 'package:whitesupermarketapp/widgets/product_card.dart';
import '../controller/cart_controller.dart';
import '../controller/item_view_controller.dart';
import '../database/global.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {

  //final ScrollController scrollController = ScrollController();
  final ItemListViewController itemListViewController = Get.find();
  final ItemViewController itemViewController = Get.find();
  final HomeController controller = Get.find();
  final CartController cartController = Get.find();
  final NavDrawerController navDrawerController=Get.find();



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBarContainer(controller),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        // controller: controller.mainScrollController,
                        controller: controller.productScrollController,
                        child: Column(
                          children: [
                            ImageCarousel(banners: globalBanners),
                            //const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                children: [
                                  /*Container(
                                    decoration: const BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Limited Period Offer',
                                            style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),*/
                                    //child: ProductCard(controller.products[i], cartController, controller, true),
                                  //const SizedBox(height: 5),
                                  Container(
                                    //margin: const EdgeInsets.all(20),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: secondary, // Change this to your desired color
                                      borderRadius: BorderRadius.circular(10),),
                                    child:Column(
                                      children:[
                                         Padding(padding: const EdgeInsets.only(top: 15.0, bottom:10),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.91,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            //color: white,
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 4.0),
                                                    child: Text('Shop by Category', style: TextStyle(fontSize: 15, color: primary,fontWeight: FontWeight.w400),),
                                                  ),
                                                ],
                                              )),),
                                        const SizedBox(height: 5),
                                        GridView.builder(
                                    itemBuilder: (_, i) => CategoryCard(controller.categories[i], itemListViewController),
                                    itemCount: controller.categories.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                  ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    child: SizedBox(
                                      //height: 100,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: greylight,
                                                  borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children:  [
                                                    SvgPicture.asset(
                                                      'assets/category_images/pencil.svg',
                                                      height: 28,
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    const Text(
                                                      'SCHOOL CORNER',
                                                      style: TextStyle(color: primary, fontSize: 17, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      controller.showProductCategory('School Corner');
                                      controller.label.value = 'School Corner';
                                      //controller.handleLabelChange('School Corner');
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    child: SizedBox(
                                      //height: 100,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: greylight,
                                                    borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children:  [
                                                      SvgPicture.asset(
                                                        'assets/category_images/prayer.svg',
                                                        height: 28,
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      const Text(
                                                        'PRAYER CORNER',
                                                        style: TextStyle(color: primary, fontSize: 17, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      controller.showProductCategory('Prayer Corner');
                                      controller.label.value = 'Prayer Corner';

                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    child: SizedBox(
                                      //height: 100,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: greylight,
                                                  borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children:  [
                                                    SvgPicture.asset(
                                                      'assets/category_images/miscellaneous.svg',
                                                      height: 28,
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    const Text(
                                                      'MISCELLANEOUS',
                                                      style: TextStyle(color: primary, fontSize: 17, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      controller.showProductCategory('Miscellaneous');
                                      controller.label.value = 'Miscellaneous';
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                      decoration: const BoxDecoration(
                                          color: primary,
                                          borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(right:8.0,left:15.0,top:8.0,bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                             Text(
                                               controller.label.value,
                                              style: const TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              child: ElevatedButton(
                                                onPressed: () {

                                                  controller.showCategorySuggestions.value = false;
                                                  controller.label.value = 'All Products';
                                                  controller.showAllProducts();
                                                  controller.showSearchSuggestions.value = false;
                                                  controller.searchbarController.clear();
                                                  controller.search.value = false;
                                                  controller.scrollUp();

                                                },
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(secondary),
                                                    shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                                        borderRadius: BorderRadiusDirectional.only(
                                                            bottomEnd: Radius.circular(10),
                                                            topStart: Radius.circular(10),
                                                            topEnd: Radius.circular(10),
                                                            bottomStart: Radius.circular(10))))),
                                                child: const Text('View All' ,style: TextStyle(color: white,fontSize: 12),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    width: Get.width * 0.98,
                                    //padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      color: greylight, // Change this to your desired color
                                      borderRadius: BorderRadius.circular(10),),
                                    child: Obx(
                                      () => controller.gridChildren.isNotEmpty
                                      //controller.gridChildren
                                          ? LiveGrid.options(
                                              itemBuilder: buildAnimatedItem,
                                              // controller: controller.productScrollController,
                                              // reverse: true,
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2, childAspectRatio: 6 / 7),
                                              itemCount: controller.gridChildren.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),

                                              options: const LiveOptions(
                                                // Start animation after (default zero)
                                                delay: Duration(milliseconds: 100),

                                                // Show each item through (default 250)
                                                showItemInterval: Duration(milliseconds: 250),

                                                // Animation duration (default 250)
                                                showItemDuration: Duration(milliseconds: 250),

                                                // Animations starts at 0.05 visible
                                                // item fraction in sight (default 0.025)
                                                visibleFraction: 0.05,

                                                // Repeat the animation of the appearance
                                                // when scrolling in the opposite direction (default false)
                                                // To get the effect as in a showcase for ListView, set true
                                                reAnimateOnVisibility: false,
                                              ),
                                            )
                                          : const SizedBox(
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
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      if (controller.showSearchSuggestions.value)
                        SingleChildScrollView(
                          child: Container(
                            color: controller.showBlankSearchSuggestions.value ? black26 : white,
                            //height: Get.height,
                            width: Get.width,
                            child: Obx(
                              () => controller.showBlankSearchSuggestions.value
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(10))),
                                          padding: const EdgeInsets.only(bottom: 10),
                                          // color: white,
                                          child: Wrap(
                                            alignment: WrapAlignment.spaceEvenly,
                                            children: controller.allProducts
                                                .map((e) => GestureDetector(
                                                  child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                        child: Chip(
                                                            label: Text(
                                                          e,
                                                          style: const TextStyle(fontSize: 12),
                                                        )),
                                                      ),
                                                  onTap: () {
                                                    controller.searchbarController.text = e;
                                                    controller.searchBarFocusNode.requestFocus();
                                                    controller.searchBarFocusNode.unfocus(); // Close the keyboard
                                                    //print('${e}..........................');
                                                  },
                                                ))
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller.searchSuggestions.length,
                                      itemBuilder: (context, i) => searchListItem(controller.searchSuggestions[i], controller),
                                    ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => cartController.cart.isNotEmpty && !controller.showSearchSuggestions.value
              ? InkWell(
            onTap: (){navDrawerController.selectIndex(3);},
                child: Container(
                    decoration: const BoxDecoration(color: white),
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        //width:MediaQuery.of(context).size.width*.8,
                        height: 50,
                        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Obx(
                                    () => Text(
                                      '${cartController.cart.length} ITEMS',
                                      style: const TextStyle(
                                        color: white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,),
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      '₹${cartController.cartTotal}',
                                      style: const TextStyle(color: white,
                                        fontWeight: FontWeight.w500,),
                                    ),
                                  ),
                                ],
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Next',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.arrow_right,
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
    );
  }

  Widget searchListItem(String suggestion, HomeController controller) {
    return ListTile(
      title: Text(suggestion),
      trailing: const Icon(CupertinoIcons.arrow_up_left),
      onTap: () {
        controller.searchbarController.text = suggestion;
        controller.setProductsBasedOnTagSearch();
        controller.searchBarFocusNode.requestFocus();
        controller.searchBarFocusNode.unfocus();
      },
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
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          // Paste you Widget
          child: ProductCard(controller.gridChildren[i], cartController, itemViewController, false),
        ),
      );


}

class ImageCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> banners;

  ImageCarousel({required this.banners});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 500),
        autoPlayCurve: Curves.easeIn,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: (){
                //print(banner["item_code"]);
                var controller = Get.find<HomeController>();
                controller.addProductToGrid(banner["item_code"]);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.memory(base64Decode(banner['banner_img'])),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class SearchBarContainer extends StatelessWidget {
  const SearchBarContainer(
    this.controller, {
    Key? key,
  }) : super(key: key);
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            const BoxDecoration(color: primary),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 10,left: 30),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search from 10,000+ Products',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
                  suffixIcon: !controller.showBlankSearchSuggestions.value
                      ?IconButton(
                    onPressed:controller.search.value?
                        (){
                      controller.searchbarController.clear(); // Clear the text in the search bar
                    controller.showBlankSearchSuggestions.value = true; // Show the search suggestions
                    controller.search.value = false; // Hide the search icon
                    }
                    :(){
                      controller.searchbarController.clear();
                      controller.showBlankSearchSuggestions.value = true;
                    },
                    icon: const Icon(Icons.clear_outlined, color: white),)
                      :IconButton(
                      onPressed:() {
                        controller.search.value = true;
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
      );
  }
}
