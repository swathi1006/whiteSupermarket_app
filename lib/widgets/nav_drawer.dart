import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/controller/my_account_controller.dart';
import 'package:whitesupermarketapp/controller/nav_drawer_controller.dart';
import 'package:whitesupermarketapp/util/colors.dart';

import '../database/global.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer({Key? key}) : super(key: key);
  final NavDrawerController controller = Get.find();
  final MyAccountController myAccountController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(()=>Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: primary),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey, width: 2)),
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: myAccountController.user.value != null && myAccountController.user.value!.profileImg != ''
                              ? Image.network(
                            myAccountController.user.value!.profileImg,
                                  fit: BoxFit.cover,
                                ).image
                              : null,
                          child: myAccountController.user.value != null && myAccountController.user.value!.profileImg != ''
                              ? null
                              : Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.lightBlueAccent,
                                        secondary,
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person_outline_rounded,
                                      size: 50,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left :10.0),
                        child: Text(
                          myAccountController.user.value != null && myAccountController.user.value!.name != '' ? myAccountController.user.value!.name : UserName,
                          style: const TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Home'),
              selected: controller.selectedIndex.value == 0,
              selectedTileColor: Colors.grey.withOpacity(0.2),
              onTap: () {
                controller.selectIndex(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('Account'),
              selected: controller.selectedIndex.value == 1,
              selectedTileColor: Colors.grey.withOpacity(0.2),
              onTap: () {
                controller.selectIndex(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open_outlined),
              title: const Text('My Orders'),
              selected: controller.selectedIndex.value == 2,
              selectedTileColor: Colors.grey.withOpacity(0.2),
              onTap: () {
                controller.selectIndex(2);
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/logo/whitelogo.svg',height: 18,width: 18,color:controller.selectedIndex.value == 3?primary:Colors.grey ,),
              title: const Text('My Cart'),
              selected: controller.selectedIndex.value == 3,
              selectedTileColor: Colors.grey.withOpacity(0.2),
              onTap: () {
                controller.selectIndex(3);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Image.asset('assets/images/intro_3.png'),
            ),
          ],
        ),
      ),
    );
  }
}
