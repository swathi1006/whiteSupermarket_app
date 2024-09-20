import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whitesupermarketapp/modal/category.dart';
import '../database/global.dart';
import '../database/mongo.dart';
import '../modal/product.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxList<Product> products = RxList.empty();
  RxList<Category> categories = RxList.empty();
  final ScrollController productScrollController = ScrollController();
  final ScrollController mainScrollController = ScrollController();
  bool nextScroll = true;
  RxList<Product> gridChildren = RxList.empty();
  RxList<Product> gridChildrenOld = RxList.empty();
  TextEditingController searchbarController = TextEditingController();
  RxString label = 'All Products'.obs;
  TextEditingController labelController = TextEditingController();

  //TextEditingController tag = TextEditingController();
  FocusNode searchBarFocusNode = FocusNode();
  RxBool showSearchSuggestions = RxBool(false);
  RxBool showBlankSearchSuggestions = RxBool(false);
  RxList<String> searchSuggestions = RxList.empty();
  List<String> allProducts = [];
  RxBool showCategorySuggestions = false.obs;
  RxBool search = false.obs;


  //List<String> allProducts = ['Tea & Coffee','Soaps & Shampoo', 'Biscuits & Rusk', 'റവ,അരിപ്പൊടി', 'പപ്പടം', 'Powder', 'സോപ്പ് പൊടി', 'ചായ / കാപ്പി പൊടി', 'എണ്ണ', 'പുളി', 'Toothpaste', 'Hair Die', 'Battery', 'മസാലപ്പൊടികൾ', 'Pampers', 'Sanitary Napkin', 'Dish wash', 'വിനാഗിരി', 'പരിപ്പ്, പയർ', 'സോയാബീൻ', 'Harpic', 'സേമിയ', 'മുട്ട', 'യീസ്റ്റ്'];
  //List<String> allProducts = ['Apple', 'Bat', 'Cat', 'Door', 'Shampoo', 'ToothPaste', 'Shower Gel', 'Acid', 'Tiles Cleaner'];
  //List<String> allProducts = ['Soaps & Shampoo', 'Biscuits & Rusk', 'Rice flour & Semolina', 'Papadam', 'Powder', 'Soap powder', 'Tea & Coffee Powder', 'Oil', 'Tamarind', 'Toothpaste', 'Hair Die', 'Battery', 'Spice Powders', 'Pampers', 'Sanitary Napkin', 'Dish wash', 'Vinegar', 'Dal', 'Beans', 'Soybean', 'Harpic', 'Vermicelli', 'Egg', 'Yeast'];

  @override
  void onInit() {
    getProducts();
    getTags();
    super.onInit();
    ever(label, handleLabelChange);
  }

  void handleLabelChange(String newLabel) {
    labelController.text = newLabel;
  }
  void addProductToGrid(String itemCode) async{
    //print("addProductToGrid");
    //print(itemCode);

    var item = await collection_items!.findOne(where.eq('item_code', itemCode));
    if (item != null) {
      List<String> itemCategoryList = [];
      for (var itemCategory in item['item_catogory']) {
        itemCategoryList.add(itemCategory);
      }
      List<String> itemTagList = [];
      for (var itemTags in item['item_tags']) {
        itemTagList.add(itemTags);
      }
      //print(item['item_name']);
      Product newProduct = Product(
        item['_id'].toHexString(),
        item['item_code'],
        item['item_name'],
        item['item_mrp'].toString(),
        item['offer_price'].toString(),
        itemCategoryList,
        item['discount'].toString(),
        itemTagList,
        item['item_image'],
        item['stock_quantity'],
        item['item_discription'],
      );
      //print(newProduct.item_name);
      gridChildren.clear();
      gridChildren.add(newProduct);
    }
    //var product = products.firstWhere((product) => product.item_code == itemCode);
    //print(product.item_name);
    //gridChildren.clear();
    //gridChildren.add(product);
    //gridChildren.shuffle();
  }
  showAllProducts() {
    gridChildren.clear();
    gridChildren.addAll(products);
    //products.refresh();
    //print(products.length);
    //print(gridChildren.length);
  }

  void showProductCategory(String Category) async{
    category = Category;
    label.value = Category == "Detergents" ? "Cleaners & Detergents" : Category;
    //print(label.value);
    showCategorySuggestions.value = true;
    globalitems = await MongoDB.getCategoryItems(category);
    productScrollController.animateTo(
      productScrollController.offset+200,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    //print(globalitems.length);
    List<Product> filteredItems = [];
    for (var item in globalitems) {
      List<String> itemCategoryList=[];
      for(var itemCategory in item['item_catogory']) {
        itemCategoryList.add(itemCategory);
      }
      List<String> itemTagList=[];
      for(var itemTags in item['item_tags']) {
        itemTagList.add(itemTags);
      }
      //print(item['item_name']);
      filteredItems.add(
        Product(
          item['_id'].toHexString(),
          item['item_code'],
          item['item_name'],
          item['item_mrp'].toString(),
          item['offer_price'].toString(),
          itemCategoryList,
          item['discount'].toString(),
          itemTagList,
          item['item_image'],
          item['stock_quantity'],
          item['item_discription'],
        ),
      );
    }

    //List<Product> filteredItems;
    //filteredItems = products.where((item) => item.item_catogory.any((itemCategory) => itemCategory.startsWith(category))).toList();
    //print(filteredItems.length);
    //filteredItems.forEach((product) {
      //print(product.item_name);
    //});
    gridChildren.clear();
    gridChildren.addAll(filteredItems);
    globalitems = await MongoDB.getCategoryItems(category);
    productScrollController.addListener(_scrollListener);
    //final ScrollController scrollController = ScrollController();
  }

  searchProduct(String pattern) {
    searchSuggestions.clear();
    if (pattern != '') {
      showBlankSearchSuggestions(false);
      searchSuggestions.addAll(allProducts.where((element) => element.toLowerCase().startsWith(pattern.toLowerCase())));
      searchSuggestions.sort((a, b) => a.toString().compareTo(b.toString()));

    } else {
      showBlankSearchSuggestions(true);
      searchSuggestions.addAll(allProducts);
      searchSuggestions.sort((a, b) => a.toString().compareTo(b.toString()));
    }
    //setProductsBasedOnTagSearch(pattern);
  }

void setProductsBasedOnTagSearch() async{
  List<Product> filteredItems;
  if (searchbarController.text != '') {
    label.value = searchbarController.text;
    var items = await MongoDB.getTagItems(searchbarController.text);
    scrollDown();
    if (items.isNotEmpty) {
      search.value = true;
      gridChildren.clear();
      for (var item in items) {
        List<String> itemCategoryList = [];
        for (var itemCategory in item['item_catogory']) {
          itemCategoryList.add(itemCategory);
        }
        List<String> itemTagList = [];
        for (var itemTag in item['item_tags']) {
          itemTagList.add(itemTag);
        }
        //print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
        //print(item['item_name']);

        Product newProduct = Product(
          item['_id'].toHexString(),
          item['item_code'],
          item['item_name'],
          item['item_mrp'].toString(),
          item['offer_price'].toString(),
          itemCategoryList,
          item['discount'].toString(),
          itemTagList,
          item['item_image'],
          item['stock_quantity'],
          item['item_discription'],
        );

        bool productExists = gridChildren.any((product) => product.id == newProduct.id);
        if (!productExists) {
          gridChildrenOld.add(newProduct);
          //gridChildren.add(newProduct);
        }
        gridChildren.addAll(gridChildrenOld);
        gridChildrenOld.clear();
      }
    }

    globalitems = await MongoDB.getTagItems(searchbarController.text);
    productScrollController.addListener(_scrollListener);
    //filteredItems = products.where((item) =>item.tags.any((tag) =>tag.toLowerCase().startsWith(pattern.toLowerCase()))).cast<Product>().toList();
    //print(filteredItems.length);
    //filteredItems.forEach((product) {
     // print(product.item_name);
    //});
    //gridChildren.clear();
    //gridChildren.addAll(filteredItems);
  }
  else {
    gridChildren.clear();
    products.shuffle();
    gridChildren.addAll(products);
  }
}

  void scrollDown() {
    double currentOffset = productScrollController.offset;
    double newOffset = currentOffset + 350;
    productScrollController.animateTo(
      newOffset,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
  void scrollUp() {
    productScrollController.animateTo(
      0, // Scroll to the top of the screen
      duration: const Duration(seconds: 1), // Change the duration as needed
      curve: Curves.easeInOut, // Change the curve as needed
    );
  }

getTags() {
    for (var tags in globalTags) {
        allProducts.add(tags['tags']);
    }
    globalTags=[];
}
  getProducts() async {
    searchbarController.addListener(() {
      searchProduct(searchbarController.text);
    });
    searchBarFocusNode.addListener(() {
      if (searchBarFocusNode.hasFocus) {
        showSearchSuggestions(true);
      } else {
        showSearchSuggestions(false);
      }
    });
    getCategories();

    globalitems = await MongoDB.getItems();
    for (var item in globalitems) {
      List<String> itemCategoryList=[];
      for(var itemCategory in item['item_catogory']) {
        itemCategoryList.add(itemCategory);
      }
      List<String> itemTagList=[];
      for(var itemTags in item['item_tags']) {
        itemTagList.add(itemTags);
      }
      //print(item['item_name']);
      products.add(
        Product(
          item['_id'].toHexString(),
          item['item_code'],
          item['item_name'],
          item['item_mrp'].toString(),
          item['offer_price'].toString(),
          itemCategoryList,
          item['discount'].toString(),
          itemTagList,
          item['item_image'],
          item['stock_quantity'],
          item['item_discription'],
        ),
      );
    }
    //print(products.length);
    gridChildren.clear();
    gridChildren.addAll(products);
    globalitems = await MongoDB.getItems();
    productScrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    // print(scrollController.position.pixels);

    if (productScrollController.position.userScrollDirection == ScrollDirection.reverse) {
      final extentAfter = productScrollController.position.extentAfter;
      if (extentAfter < (productScrollController.position.minScrollExtent + 200)) {
        addNewProductsToList();
      }
    } else {
      final extentBefore = productScrollController.position.extentBefore;
      if (extentBefore < (productScrollController.position.maxScrollExtent )) {
        // mainScrollController.animateTo(mainScrollController.offset+extentBefore, duration: const Duration(milliseconds: 100), curve: Curves.linear);
        // mainScrollController.

        // mainScrollController.jumpTo(mainScrollController.offset + productScrollController.position.extentAfter);
      }
      //print('scroll up');
    }
  }

  addNewProductsToList() async {
    if (showCategorySuggestions.value == true) {
      //print(globalitems.length);
      for (var item in globalitems) {
        List<String> itemCategoryList=[];
        for(var itemCategory in item['item_catogory']) {
          itemCategoryList.add(itemCategory);
        }
        List<String> itemTagList=[];
        for(var itemTags in item['item_tags']) {
          itemTagList.add(itemTags);
        }
        //print(item['item_name']);
        Product newProduct = Product(
          item['_id'].toHexString(),
          item['item_code'],
          item['item_name'],
          item['item_mrp'].toString(),
          item['offer_price'].toString(),
          itemCategoryList,
          item['discount'].toString(),
          itemTagList,
          item['item_image'],
          item['stock_quantity'],
          item['item_discription'],
        );
        //print(newProduct.item_name);
        bool productExists = gridChildren.any((product) => product.id == newProduct.id);
        if (!productExists) {
          gridChildrenOld.add(newProduct);
        }

        gridChildren.addAll(gridChildrenOld);
        gridChildrenOld.clear();
        //gridChildren.shuffle();
      }
      globalitems = await MongoDB.getCategoryItems(category);
      Future.delayed(const Duration(milliseconds: 250)).then((value) {
      });
    }
    if(search.value){
      //print(globalitems.length);
      for (var item in globalitems) {
        List<String> itemCategoryList=[];
        for(var itemCategory in item['item_catogory']) {
          itemCategoryList.add(itemCategory);
        }
        List<String> itemTagList=[];
        for(var itemTags in item['item_tags']) {
          itemTagList.add(itemTags);
        }
        if (itemTagList.contains(searchbarController.text)) {
          //print(item['item_name']);
          Product newProduct = Product(
            item['_id'].toHexString(),
            item['item_code'],
            item['item_name'],
            item['item_mrp'].toString(),
            item['offer_price'].toString(),
            itemCategoryList,
            item['discount'].toString(),
            itemTagList,
            item['item_image'],
            item['stock_quantity'],
            item['item_discription'],
          );
          //print(newProduct.item_name);
          bool productExists = gridChildren.any((product) => product.id == newProduct.id);
          if (!productExists) {
            gridChildrenOld.add(newProduct);
          }
          gridChildren.addAll(gridChildrenOld);
          gridChildrenOld.clear();
        }
        //gridChildren.shuffle();
      }
      globalitems = await MongoDB.getTagItems(searchbarController.text);
      Future.delayed(const Duration(milliseconds: 250)).then((value) {
      });
    }
    else{
      //print(globalitems.length);
      for (var item in globalitems) {
        List<String> itemCategoryList=[];
        for(var itemCategory in item['item_catogory']) {
          itemCategoryList.add(itemCategory);
        }
        List<String> itemTagList=[];
        for(var itemTags in item['item_tags']) {
          itemTagList.add(itemTags);
        }
        //print(item['item_name']);
        Product newProduct = Product(
          item['_id'].toHexString(),
          item['item_code'],
          item['item_name'],
          item['item_mrp'].toString(),
          item['offer_price'].toString(),
          itemCategoryList,
          item['discount'].toString(),
          itemTagList,
          item['item_image'],
          item['stock_quantity'],
          item['item_discription'],
        );

        bool productExists = gridChildren.any((product) =>
        product.id == newProduct.id);
        if (!productExists) {
          gridChildrenOld.add(newProduct);
        }
        gridChildren.addAll(gridChildrenOld);
        gridChildrenOld.clear();
      }
      globalitems = await MongoDB.getItems();
    Future.delayed(const Duration(milliseconds: 250)).then((value) {
      });
    }
  }


  getCategories() {
    categories.add(Category('1', 'Rice & Grains', 'assets/category_images/C1.png'));
    categories.add(Category('2', 'Wheat, Rice Flour', 'assets/category_images/C2.png'));
    categories.add(Category('3', 'Coriander, Chili, Masala', 'assets/category_images/C3.png'));
    categories.add(Category('4', 'Oil & Other Ingredients', 'assets/category_images/C4.png'));
    categories.add(Category('5', 'Drinks', 'assets/category_images/C5.png'));
    categories.add(Category('6', 'Vegetables & Fruits', 'assets/category_images/C6.png'));
    categories.add(Category('7', 'Chips & Snacks', 'assets/category_images/C7.png'));
    categories.add(Category('8', 'Cosmetics', 'assets/category_images/C8.png'));
    categories.add(Category('9', 'Detergents', 'assets/category_images/C9.png'));
  }


  //getCategories() {
  // categories.add(Category('1', 'അരി, ധന്യങ്ങൾ', 'assets/category_images/C1.png'));
  //categories.add(Category('2', 'ആട്ട, അരിപ്പൊടി', 'assets/category_images/C2.png'));
  //  categories.add(Category('3', 'മല്ലി, മുളക്, മസാല', 'assets/category_images/C3.png'));
  //  categories.add(Category('4', 'എണ്ണ മറ്റ് ചേരുവകൾ', 'assets/category_images/C4.png'));
  //  categories.add(Category('5', 'പാനീയങ്ങൾ', 'assets/category_images/C5.png'));
  //  categories.add(Category('6', 'പച്ചക്കറി, പഴങ്ങൾ', 'assets/category_images/C6.png'));
  //  categories.add(Category('7', 'കറുമുറു', 'assets/category_images/C7.png'));
  //  categories.add(Category('8', 'സുന്ദരം', 'assets/category_images/C8.png'));
  // categories.add(Category('9', 'കഴുകാനും തുടക്കാനും', 'assets/category_images/C9.png'));
  //}

  shareApp() {
    Share.share('Check out this app https://example.com');
  }

  callHelp() async {
    if (!await launchUrl(Uri.parse('tel:+9181380 66143'))) {
      throw 'Could not launch tel:+918138066143';
    }
  }
}
