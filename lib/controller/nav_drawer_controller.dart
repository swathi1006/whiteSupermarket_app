import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavDrawerController extends GetxController {
  static NavDrawerController get to =>Get.find();
  RxString title = RxString('Home');
  RxInt selectedIndex = RxInt(0);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  selectIndex(int index) {
    selectedIndex.value = index;
    setTitle(index);
    // Get.back();
    if(scaffoldKey.currentState!.isDrawerOpen){
      scaffoldKey.currentState!.closeDrawer();

    }
  }

  setTitle(int index) {
    switch (index) {
      case 0:
        title.value = 'Home';
        break;
      case 1:
        title.value = 'My Account';
        break;
      case 2:
        title.value = 'My Orders';
        break;
      case 3:
        title.value = 'My Cart';
        break;
    }
  }
}
