import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whitesupermarketapp/view/login_screen.dart';
import '../controller/login_controller.dart';
import '../database/global.dart';
import '../database/mongo.dart';
import '../util/colors.dart';
import 'main_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final LoginController controller = Get.put(LoginController());
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String otp = '';
  bool signup = false;
  Timer? resendTimer;
  RxBool otpSent = false.obs;
  RxBool otpResent = false.obs;

  void startResendTimer() {

    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (controller.resendSeconds.value == 0) {
        otpSent.value = true;
        timer.cancel();
      } else {
        controller.resendSeconds.value--;
      }
    });
  }

  void stopResendTimer() {
    resendTimer?.cancel();
    resendTimer = null;
  }

  sendotp() {
    otpSent.value = false;
    otp = generateOtp();
    controller.sendOtp(phoneController.text,otp);
    controller.resendSeconds.value = 60;
    startResendTimer();
  }


  String generateOtp() {
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return timestamp.substring(timestamp.length - 6);
  }

  @override
  Widget build(BuildContext context) {
    // controller.showLoginBottomSheet();
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /*SizedBox(height: Get.height * 0.1),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'Welcome to ', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: 'White Super Market',
                          style: TextStyle(color: primary, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),*/
                /*Carousel(
                  items: [
                    Image.asset('assets/images/intro_1.png'),
                    // Image.asset('assets/images/intro_2.png'),
                    Image.asset('assets/images/intro_3.png'),
                  ],
                  autoScroll: true,
                  indicatorBarColor: Colors.transparent,
                  stopAtEnd: true,
                  indicatorBarHeight: 0,
                  isCircle: false,
                  indicatorHeight: 1.75,
                  unActivatedIndicatorColor: Colors.grey.withOpacity(0.25),
                  activateIndicatorColor: primary,
                ),*/
                Image.asset('assets/images/white_supermarket_login.jpeg'),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    8.0, 8.0, 8.0, MediaQuery.of(context).viewInsets.bottom == 0 ? 70 : MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  // elevation: 10,
                  // shadowColor: Colors.black,
                  // shape: const RoundedRectangleBorder(
                  //   borderRadius: BorderRadiusDirectional.vertical(
                  //     top: Radius.circular(10),
                  //   ),
                  // ),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, -3),
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(3, 0),
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(-3, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                    child: Obx(
                          () => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(height: 5),
                          const Text('Sign Up to White super market'),
                          const SizedBox(height: 10),
                          Form(
                            key: controller.nameKey,
                            child: AnimatedContainer(
                              height: controller.mobileHeight.value,
                              duration: const Duration(milliseconds: 250),
                              child: AnimatedOpacity(
                                opacity: controller.showOtp.value || otpResent.value? 0 : 1,
                                duration: const Duration(milliseconds: 250),
                                child: TextFormField(
                                  controller: nameController,
                                  style: const TextStyle(fontSize: 17),
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter Your Name',
                                      counterText: ''),
                                  keyboardType: TextInputType.name,
                                  autofocus: true,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Enter Your name to sign up';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Form(
                            key: controller.mobileKey,
                            child: AnimatedContainer(
                              height: controller.mobileHeight.value,
                              duration: const Duration(milliseconds: 250),
                              child: AnimatedOpacity(
                                opacity: controller.showOtp.value || otpResent.value? 0 : 1,
                                duration: const Duration(milliseconds: 250),
                                child: TextFormField(
                                  controller: phoneController,
                                  style: const TextStyle(fontSize: 17),
                                  decoration: InputDecoration(
                                      isDense: true,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.only(left: 10, top: 12.5),
                                        child: const Text(
                                          '+91',
                                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      hintText: 'Enter Phone Number',
                                      counterText: ''),
                                  maxLength: 10,
                                  keyboardType: TextInputType.number,
                                  autofocus: true,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Enter Phone Number to sign upr';
                                    }
                                    if (value!.length < 10) {
                                      return 'Enter valid Phone Number';
                                    }
                                    return null;
                                  },
                                ),

                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Form(
                            key: controller.otpKey,
                            child: AnimatedContainer(
                              height: controller.otpHeight.value,
                              duration: const Duration(milliseconds: 250),
                              child: TextFormField(
                                controller: otpController,
                                focusNode: controller.otpFocusNode,
                                decoration: InputDecoration(
                                    border: controller.showOtp.value || otpResent.value? const OutlineInputBorder() : InputBorder.none,
                                    hintText: 'Enter OTP',
                                    prefixIcon: const SizedBox(
                                      width: 30,
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right:8.0),
                                      child: otpSent.value==false
                                          ? Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text("00:${controller.resendSeconds.value}"),
                                      )
                                          :TextButton(
                                        onPressed: (){
                                          otpResent.value = true;
                                          sendotp();
                                        },
                                        child: const Text("Resend OTP"),),),
                                    counterText: ''),
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == '') {
                                    return 'Enter OTP';
                                  }
                                  if (value!.length < 6) {
                                    return 'Enter valid OTP';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            height: controller.showOtp.value ? 10 : 0,
                            duration: const Duration(milliseconds: 250),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if ((controller.showOtp.value) || (otpResent.value)) {
                                otpResent.value = false;
                                if (controller.otpKey.currentState!.validate()) {
                                  if(otp== otpController.text) {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('phonenumber', phoneController.text);
                                    controller.isLoggedIn(true);
                                    phone=phoneController.text;
                                    while(!controller.dataFetched.value) {
                                      await Future.delayed(const Duration(seconds: 1));
                                    }
                                    controller.dataFetched.value = false;
                                    Get.offAll(() => MainScreen());
                                  } else {
                                    phone=phoneController.text;
                                    Get.snackbar('Error', 'Invalid OTP');
                                    //Get.offAll(() => LoginScreen());
                                  }
                                }
                              } else {
                                //print(phoneController.text);
                                var user1 = await collection_users?.findOne(where.eq('phone', phoneController.text));
                                if (user1 ==null){
                                  addUser(nameController.text, phoneController.text);
                                  signup=!signup;
                                  sendotp();
                                  await MongoDB.getuser(phoneController.text);
                                }
                                else{
                                  Get.snackbar('You number is already registered', 'Please login to continue');
                                  Get.offAll(() => LoginScreen());
                                }
                              }
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                    borderRadius: BorderRadiusDirectional.only(
                                        bottomEnd: Radius.circular(0),
                                        topStart: Radius.circular(0),
                                        topEnd: Radius.circular(20),
                                        bottomStart: Radius.circular(20))))),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),

                          Visibility(
                            visible: !signup,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                const Text("I already have an account. "),
                                const SizedBox(width: 5),
                                TextButton(
                                  onPressed: () {
                                    Get.offAll(() => LoginScreen());
                                  },
                                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
