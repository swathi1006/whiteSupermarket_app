import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whitesupermarketapp/util/colors.dart';
import 'package:whitesupermarketapp/util/theme.dart';
import 'package:whitesupermarketapp/view/splash_screen.dart';
import 'database/global.dart';
import 'database/mongo.dart';

Future<void> main() async {
  Map<String, dynamic> dbAndCollection = await MongoDB.connect();
  db = dbAndCollection['db'];
  collection_items = dbAndCollection['collection_items'];
  collection_banners = dbAndCollection['collection_banners'];
  runApp(const MyApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Get.put(ItemListViewController());

    return GetMaterialApp(
      title: 'White Supermarket',
      debugShowCheckedModeBanner: false,
      theme: myTheme.copyWith(colorScheme: myTheme.colorScheme.copyWith(secondary: secondary)),
      home: SplashScreen(),
    );
  }
}
