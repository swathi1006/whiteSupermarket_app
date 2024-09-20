import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/util/colors.dart';

import '../controller/my_account_controller.dart';
import '../controller/nav_drawer_controller.dart';
import '../database/global.dart';

class MyAccountScreen extends StatelessWidget {
  MyAccountScreen({Key? key}) : super(key: key);
  final MyAccountController controller = Get.find();
  final NavDrawerController navDrawerController = Get.find();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navDrawerController.selectIndex(0);
        return false;
      },
      child: Stack(
          children:[
        Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset('assets/images/4.png'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
              //color: greylight,
              borderRadius: BorderRadius.circular(10),
            ),
                height: Get.height * 0.30,
                width: Get.width,
                //color: secondary,
                child: Stack(
                  children: [
                    Container(
                      height: Get.height * 0.30,
                      width: Get.width,
                      padding: const EdgeInsets.only(left: 10,right:10 , top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 60,),
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, border: Border.all(color: primary.withOpacity(.8), width: 5)),
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                    radius: 53,
                                    backgroundImage: controller.user.value != null && controller.user.value!.profileImg != ''
                                        ? Image.network(
                                            controller.user.value!.profileImg,
                                            fit: BoxFit.cover,
                                          ).image
                                        : null,
                                    child: controller.user.value != null && controller.user.value!.profileImg != ''
                                        ? null
                                        : Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: CupertinoColors.lightBackgroundGray,
                                              border: Border.fromBorderSide(BorderSide(color: primary, width: 1)),
                                              /*gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  lightBlue,
                                                  secondary,
                                                ],
                                              ),*/
                                            ),
                                            child:  const Center(
                                              child:
                                                  Icon(
                                                    Icons.person_outline_rounded,
                                                    size: 50,
                                                  ),
                                            ),
                                          ),
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right:0.0),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.logout();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey.withOpacity(.5), width: 4),
                                    ),
                                    child:Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconTheme(
                                        data: IconThemeData(
                                          size: 25,
                                          color: Colors.grey.withOpacity(.8),
                                        ),
                                        child: const Icon(Icons. logout_rounded),
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 20),
                          Text(
                            controller.user.value != null && controller.user.value!.name != '' ? controller.user.value!.name : UserName,
                            style: const TextStyle(color: primary, fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            phone,
                            style: const TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height:20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    //color: secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children:  [
                          Text(
                            //globalorder.length.toString(),
                            globalorder.where((order) => order['status'] != 'Delivered' && order['status'] != 'Cancelled').length.toString(),                        style: const TextStyle(color: white, fontSize: 24),
                          ),
                          const Text(
                            'ORDERS',
                            style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    //color: lightBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children:  [
                          Text(globalorder.where((order) => order['status'] == 'Delivered').length.toString(),                        style: const TextStyle(color: white, fontSize: 24),),
                          const Text(
                            'DELIVERED',
                            style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  //color: greylight,
                  borderRadius: BorderRadius.circular(10),
                ),
                //padding: const EdgeInsets.symmetric(horizontal:10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15,),
                    GestureDetector(
                      onTap: () {
                        controller.showMyAddressesOverLay();
                      },
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:  [
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.28,),
                                      const Icon(Icons.location_on_outlined, size: 20, color: secondary),
                                      const SizedBox(width: 10,),
                                      const Text(
                                        'MY ADDRESS',
                                        style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    GestureDetector(
                      onTap: () {
                        navDrawerController.selectIndex(2);
                      },
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:  [
                                      SizedBox(width:MediaQuery.of(context).size.width * 0.28),
                                      const Icon(Icons.folder_open, size: 20, color: secondary),
                                      const SizedBox(width: 10,),
                                      const Text(
                                        'MY ORDERS',
                                        style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    GestureDetector(
                      onTap: () {
                        navDrawerController.selectIndex(3);
                      },
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:  [
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.28,
                                      ),
                                      SvgPicture.asset(
                                        'assets/logo/whitelogo.svg',
                                        color: secondary,
                                        height: 13,
                                        width: 13,
                                      ),
                                      const SizedBox(width: 10,),
                                      const Text(
                                        'MY CART',
                                        style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25,),
                  ],
                ),
              ),
            ),
            //const Spacer(),
            //Image.asset('assets/images/myaccount.png'),
          ],
        ),
        ),
      ],
      ),
    );
  }






}
