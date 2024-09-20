import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/global.dart';
import '../database/mongo.dart';
import '../modal/order.dart';
import '../modal/user.dart';
import '../modal/invoice.dart';
import '../modal/user_address.dart';
import '../util/colors.dart';
import '../view/login_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'login_controller.dart';

class MyAccountController extends GetxController {

  Rx<User?> user = Rx(null);
  RxList<Order> orders = RxList.empty();
  Rx<UserAddress?> defaultAddress = Rx(null);
  RxList<UserAddress> userAddresses = RxList.empty();
  GlobalKey<FormState> addAddressKey = GlobalKey();
  TextEditingController nameText = TextEditingController(text: UserName);
  TextEditingController mobileText = TextEditingController(text: phone);
  TextEditingController addLine1 = TextEditingController();
  TextEditingController addLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController state = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  RxBool istoggled = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getOrders();
    fetchUserAddresses();
  }

  bool scanning = false;
  //String coordinates = '';
  //String address = '';
  String Pincode = '';
  String AddLine2 = '';
  String City = '';
  String State = '';

  getLocation() async {
      scanning = true;
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      List<Placemark> result = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (result.isNotEmpty){
        //print(result);
        //address='${result[0].name},${result[0].street}, ${result[0].locality},${result[0].administrativeArea}, ${result[0].postalCode}, ${result[0].country}';
        Pincode ='${result[0].postalCode}';
        AddLine2 ='${result[0].subLocality}, ${result[0].locality}';
        City ='${result[0].subAdministrativeArea}';
        State ='${result[0].administrativeArea}';
      }
    } catch (e) {
      //print(e);
    }
      scanning = false;
  }

  checkPermission() async {
    //print("Checking Permission");
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return ;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //print("Permission Denied!");
        return ;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      //print("Permission Denied Forever!");
      return ;
    }
    await getLocation();
    nameText.text = UserName;
    mobileText.text = phone;
    //addLine1.text = address;
    addLine2.text = AddLine2;
    city.text = City;
    pincode.text = Pincode;
    state.text = State;
  }

  void getOrders() async {
    //print(globalorder);
    //print(globalorder.length);
    for(var order in globalorder){
      //print("userOrders");
      //print(order['id']);
      List<Item> items = [];
      for (var item in order['items']){
        items.add(
            Item(
                item['itemId'],
                item['itemName'],
                item['itemImage'],
                item['count'],
                item['price']
            )
        );
      }
      orders.add(
          Order(
              order['id'],
              order['orderDate'],
              order['status'],
              order['orderValue'],
              items,
          ));
    }
  }

  void fetchUserAddresses() async {
    for(var address in globaladdress){
      userAddresses.add(
        UserAddress(
          address['id'],
          address['name'],
          address['mobile'].toString(),
          address['addressLine1'].toString(),
          address['addressLine2'].toString(),
          address['state'],
          address['city'],
          address['pincode'],
          address['isDefault'],
      ),);

      setAddressDefault(address['id']);
    }
  }
  void addOrders(String Id,List<Item> items, double total, DateTime time) async{
    //print(Id);
    Order order = Order(
      Id,
      time,
      'Accepted',
      total,
      items,
    );
    addUserOrder(order);
    orders.add(Order(Id, time, 'Accepted', total, items));
    await MongoDB.getOrder();
  }




  void addInvoice(String id, String UserId,String userName, String mobile, String address, List<ItemInvoice> itemInvoice, double total, DateTime time) async{
    Invoice invoice = Invoice(
      id,
      UserId,
      userName,
      mobile,
      address,
      'Accepted',
      time,
      total,
      'Cash on Delivery',
      itemInvoice,
    );
    addOrderInvoice(invoice);
  }


  void addAddress() async {
    if (addAddressKey.currentState!.validate()) {
      String id = userAddresses.length.toString();
      userAddresses.add(UserAddress(id, nameText.text, mobileText.text, addLine1.text, addLine2.text, state.text, city.text, pincode.text, istoggled.value));
      UserAddress userAddress = UserAddress(id, nameText.text, mobileText.text, addLine1.text, addLine2.text, state.text, city.text, pincode.text, istoggled.value);
      addUserAddresstoServer(userAddress);
      if (istoggled.value) {
        setAddressDefault(id);
      }
      Get.back();
      addAddressKey.currentState!.reset();
      addLine1.clear();
      addLine2.clear();
      //city.clear();
      pincode.clear();
      //state.clear();
    }
  }
  void setAddressDefault(String id) async {
    final int index = userAddresses.indexWhere((element) => element.id == id);
    final userAddress = userAddresses[index];
    userAddresses.removeAt(index);
    userAddress.isDefault = true;
    for (int i = 0; i < userAddresses.length; i++) {
      userAddresses[i].isDefault = false;
    }
    userAddresses.insert(index, userAddress);
    defaultAddress.value = userAddress;
    //print(id);
  }

  showMyAddressesOverLay() async {
    Get.bottomSheet(
        SafeArea(
          child: Container(
            height: Get.height * 0.9,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: const BoxDecoration(color: white, borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Address',
                      style: TextStyle(color: primary, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, color: primary),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                Obx(
                  () => Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) => addressTile(index, userAddresses[index]),
                      itemCount: userAddresses.length,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showAddAddressDialog();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(primary),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(20),
                          topStart: Radius.circular(20),
                          topEnd: Radius.circular(20),
                          bottomStart: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  child: const Text('New Address', style: TextStyle(color: white)),
                )
              ],
            ),
          ),
        ),
        isScrollControlled: true);
  }

  Widget addressTile(int index, UserAddress address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: address.isDefault ? greylight.withOpacity(0.9) : greylight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        isThreeLine: true,
        onTap: () {
          setAddressDefault(address.id);
        },
        title: Text(address.name),
        subtitle: Text('${address.addressLine1}, ${address.addressLine2}\n${address.city}-${address.pincode}, ${address.state}'),
        trailing: address.isDefault
            ? Container(
                //child: const Text('Default', style: TextStyle(fontSize: 12),),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              Icon(Icons.check_box, color: primary, size: 23),
            ],
          ),
              )
            : null,
      ),
    );
  }

  showAddAddressDialog() async {

    Get.bottomSheet(
        SingleChildScrollView(
          child: Container(
            // height: Get.height * 0.55,
            decoration: const BoxDecoration(color: white, borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Form(
              key: addAddressKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    //borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    //shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child :Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 5),
                       const Text(
                        'Enter Address',
                        style: TextStyle(color: primary, fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: primary, size: 25),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Address",style: TextStyle(color: primary, fontSize: 25, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(white),
                            ),
                            child: const Row(
                                children :[
                                  Text("Auto Detect",style: TextStyle(color: primary, fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 5),
                                  Icon(Icons.my_location, color: primary, size: 20),
                                ]
                            ),
                            onPressed: () {
                              checkPermission();
                            },
                          ),
                        ],
                      ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration:  InputDecoration(
                        fillColor: Colors.grey[50],
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Pincode',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                        isDense: true
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'Pincode';
                      }
                      return null;
                    },
                    controller: pincode,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 6,
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    decoration:  InputDecoration(
                        fillColor: Colors.grey[50],
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'House/ Flat/ Office No',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                        isDense: true),
                    validator: (value) {
                      if (value == '') {
                        return 'Enter House/ Flat/ Office No';
                      }
                      return null;
                    },
                    controller: addLine1,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                        maxLines: 5,
                      decoration:  InputDecoration(fillColor: Colors.grey[50],
                          filled: true,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Road Name/ Area/ Colony',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                          isDense: true
                      ),
                      validator: (value) {
                        if (value == '') {
                          return 'Enter Road Name/ Area/ Colony';
                        }
                        return null;
                      },
                      controller: addLine2,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration:  InputDecoration(
                        fillColor: Colors.grey[50],
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'City',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                        isDense: true),
                    validator: (value) {
                      if (value == '') {
                        return 'City';
                      }
                      return null;
                    },
                    controller: city,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    enabled: true,
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.grey[50],
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'State',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                        isDense: true),
                    // initialValue: 'Kerala',
                    validator: (value) {
                      if (value == '') {
                        return 'State';
                      }
                      return null;
                    },
                    controller: state,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    enabled: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Use as default address",style: TextStyle(color: Colors.black87, fontSize: 18)),
                      Obx(() => IconButton(
                        icon: Icon(
                            istoggled.value ? Icons.toggle_on : Icons.toggle_off,
                            color: istoggled.value ? primary : Colors.grey,
                            size: 50
                        ),
                        onPressed: () {
                          istoggled.value = !istoggled.value;
                          //print(istoggled.value);
                        },
                      ))
                    ],


                  ),
                  const SizedBox(height: 20),
                  const Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Contact",style: TextStyle(color: primary, fontSize: 25, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Information provided here will be used for delivery updates",style: TextStyle(color: Colors.black87, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration:  InputDecoration(
                        fillColor: Colors.grey[50],
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Name',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                        isDense: true),
                    validator: (value) {
                      if (value == '') {
                        return 'Enter Name';
                      }
                      return null;
                    },
                    controller: nameText,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    enabled: true,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.grey[50],
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Phone Number',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                        isDense: true, counterText: ''),
                    validator: (value) {
                      if (value == '') {
                        return 'Enter Phone Number';
                      }
                      return null;
                    },
                    controller: mobileText,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    enabled: true,
                    maxLength: 10,
                  ),const SizedBox(height: 30),
                      const Text("Don't Worry! We belive in only sharing offers, not data.",style: TextStyle(color: Colors.black87, fontSize: 16)),
                      const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(Get.context!).size.width*.8,
                    child: ElevatedButton(
                      onPressed: () {
                        // showAddAddressDialog();
                        addAddress();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(primary),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.only(
                              bottomEnd: Radius.circular(20),
                              topStart: Radius.circular(20),
                              topEnd: Radius.circular(20),
                              bottomStart: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      child: const Text('Add Address',style: TextStyle(color: Colors.white)),
                    ),
                  )
                    ],
                  ),),
                ],
              ),
            ),
          ),
        ),
        isScrollControlled: true);
  }

  void cancelOrder(String id) async {
    final int index = orders.indexWhere((element) => element.id == id);
    final order = orders[index];
    orders.removeAt(index);
    order.status = 'Cancelled';
    orders.insert(index, order);

  }

  void viewInvoice(String id) async {
    final int index = orders.indexWhere((element) => element.id == id);
    final order = orders[index];
    List<Item> items = [];
    for (var item in order.items){
      items.add(
          Item(
              item.itemId,
              item.itemName,
              item.itemImage,
              item.count,
              item.price
          )
      );
    }
    generateInvoicePdf(items, order.orderValue, dateFormat.format(order.orderDate), order.id, order.status);
  }

  Future<void> generateInvoicePdf(List<Item> items, double totalAmount, String date, String id, String status) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text("WHITE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Cloud_Supermarket", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Invoice", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.normal)),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Invoice ID: $id"),
                    pw.SizedBox(height: 5),
                    pw.Text("Date: $date"),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Status: $status"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Sl No.'),
                    pw.Text('Item Name'),
                    pw.Text('Item Price'),
                    pw.Text('Item Count'),
                  ],
                ),
                ...items.asMap().entries.map((entry) => pw.TableRow(
                  children: [
                    pw.Text((entry.key + 1).toString()),
                    pw.Text(entry.value.itemName),
                    pw.Text(entry.value.price.toString()),
                    pw.Text(entry.value.count.toString()),
                  ],
                )).toList(),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text("Total Amount: $totalAmount"),
              ],
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void shareOrder(String id) async {
    final int index = orders.indexWhere((element) => element.id == id);
    final order = orders[index];
    List<Item> items = [];
    for (var item in order.items) {
      items.add(Item(item.itemId, item.itemName, item.itemImage, item.count, item.price));
    }
    final pdfBytes = await generateInvoicePdfShare(items, order.orderValue, dateFormat.format(order.orderDate), order.id, order.status);

    // Save the PDF file to a temporary directory
    final tempDir = await getTemporaryDirectory();
    //final tempDir = File("/storage/emulated/0/Download/");
    final pdfFile = File('${tempDir.path}/Invoice_$id.pdf');
    await pdfFile.writeAsBytes(pdfBytes);

    // Share the PDF file
    //Share.shareFiles([pdfFile.path], text: 'Invoice for Order ID: $id');
    Share.shareXFiles(
      [XFile(pdfFile.path)], // List of file paths
      text: 'Invoice for Order ID: $id', // Additional text to share
    );

  }

  Future<Uint8List> generateInvoicePdfShare(List<Item> items, double totalAmount, String date, String id, String status) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text("WHITE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Cloud_Supermarket", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Invoice", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.normal)),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Invoice ID: $id"),
                    pw.SizedBox(height: 5),
                    pw.Text("Date: $date"),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Status: $status"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Sl No.'),
                    pw.Text('Item Name'),
                    pw.Text('Item Price'),
                    pw.Text('Item Count'),
                  ],
                ),
                ...items.asMap().entries.map((entry) => pw.TableRow(
                  children: [
                    pw.Text((entry.key + 1).toString()),
                    pw.Text(entry.value.itemName),
                    pw.Text(entry.value.price.toString()),
                    pw.Text(entry.value.count.toString()),
                  ],
                )).toList(),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text("Total Amount: $totalAmount"),
              ],
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }


  void logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('phonenumber');
    LoginController loginController = LoginController();
    loginController.isLoggedIn(false);
    Get.offAll(() => LoginScreen());
    globalusers.clear();
    globalorder.clear();
    globalcart.clear();
    globaladdress.clear();
    UserId = '';
    phone = '';
  }
}
