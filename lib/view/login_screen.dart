import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whitesupermarketapp/view/signup_screen.dart';
import 'package:whitesupermarketapp/widgets/toast_message.dart';
import '../controller/login_controller.dart';
import '../database/global.dart';
import '../database/mongo.dart';
import '../util/colors.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final LoginController controller = Get.put(LoginController());
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String otp = '';
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
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, -3), // changes position of shadow
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(3, 0), // changes position of shadow
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(-3, 0), // changes position of shadow
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
                            'Sign In',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(height: 5),
                          const Text('Sign In to White super market'),
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
                                  style: const TextStyle(fontSize: 17,color: primary,fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                      isDense: true,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.only(left: 10, top: 12.5),
                                        // width: 30,
                                        child: const Text(
                                          '+91',
                                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: primary),
                                        ),
                                      ),
                                      hintText: 'Enter Phone Number',
                                      counterText: ''),
                                  maxLength: 10,
                                  keyboardType: TextInputType.number,
                                  autofocus: true,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Enter Phone Number to sign in';
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
                                    style: const TextStyle(fontSize: 17,color: primary,fontWeight: FontWeight.w500),
                                    focusNode: controller.otpFocusNode,
                                    decoration: InputDecoration(
                                        border: controller.showOtp.value || otpResent.value ? const OutlineInputBorder() : InputBorder.none,
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
                              if ((controller.showOtp.value) || (otpResent.value)){
                                otpResent.value = false;
                                if (controller.otpKey.currentState!.validate()) {
                                  //print(otp);
                                  //print(otpController.text);
                                  //await MongoDB.getItems();
                                  if(otp== otpController.text) {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('phonenumber', phoneController.text);
                                    controller.isLoggedIn(true);
                                    phone=phoneController.text;
                                    while(!controller.dataFetched.value) {
                                      await Future.delayed(const Duration(seconds: 1));
                                    }
                                    controller.dataFetched.value = false;
                                    controller.showOtp.value = false;
                                    Get.offAll(() => MainScreen());
                                  } else {
                                    phone=phoneController.text;
                                    createToast('Invalid OTP', Colors.black);
                                    //Get.offAll(() => MainScreen());
                                  }
                                }
                              } else {
                                var user1 = await collection_users?.findOne(where.eq('phone', phoneController.text));
                                if (user1 !=null){
                                  sendotp();
                                  await MongoDB.getuser(phoneController.text);

                                  //otp = generateOtp();
                                  //controller.sendOtp(phoneController.text,otp);
                                  //startResendTimer();
                                }
                                else{
                                  Get.snackbar('Not a registered user.', ' Please sign up first.');
                                  Get.offAll(() => SignupScreen());
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              foregroundColor: MaterialStateProperty.all(primary),
                                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                    borderRadius: BorderRadiusDirectional.only(
                                        bottomEnd: Radius.circular(30),
                                        topStart: Radius.circular(30),
                                        topEnd: Radius.circular(30),
                                        bottomStart: Radius.circular(30))))),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              const SizedBox(width: 5),
                              TextButton(
                                onPressed: () {
                                  Get.offAll(() => SignupScreen());
                                },
                                child: const Text('Create Account', style: TextStyle(fontSize: 16, color: primary)),
                              ),
                            ],
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
