import 'package:get/get.dart';
import '../database/mongo.dart';
import '../view/login_screen.dart';
import '../view/main_screen.dart';
import 'login_controller.dart';

class SplashController extends GetxController {
  LoginController loginController = Get.put(LoginController());

  RxDouble opacity = RxDouble(0.0);

  @override
  onInit(){
    super.onInit();
    animateLogo();
  }

  animateLogo() async {
    await Future.delayed(Duration.zero);
    opacity.value=1;
    Future.delayed(const Duration(seconds: 5));
    await MongoDB.getBanners();
    await MongoDB.getTags();
    loginController.isLoggedIn.value
        ? Get.offAll(() => MainScreen())
        : Get.offAll(() => LoginScreen());
    //Get.offAll(() => LoginScreen());
    //Get.offAll(() => MainScreen());
  }
}
