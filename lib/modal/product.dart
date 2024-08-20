import 'package:get/get.dart';

class Product {
  String id;
  String item_code;
  String item_name;
  String item_mrp;
  String offer_price;
  //String item_catogory;
  List<String> item_catogory;
  String discount;
  List<String> tags;
  //String tags;
  //String item_type;
  String item_image;
  RxInt cartCount = 0.obs;
  int instock_outstock_indication;
  String item_discription;
  double customerReview = 5;

  Product(
    this.id,
    this.item_code,
    this.item_name,
    this.item_mrp,
    this.offer_price,
    this.item_catogory,
    this.discount,
    this.tags,
    //this.item_type,
    this.item_image,
    this.instock_outstock_indication,
    this.item_discription,
  );


}
