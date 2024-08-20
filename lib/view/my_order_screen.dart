import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whitesupermarketapp/modal/order.dart';
import 'package:whitesupermarketapp/util/colors.dart';
import 'package:whitesupermarketapp/controller/nav_drawer_controller.dart';
import '../controller/my_account_controller.dart';
import '../database/mongo.dart';

class MyOrderScreen extends StatelessWidget {
  MyOrderScreen({Key? key}) : super(key: key);

  final MyAccountController controller = Get.find();
  final NavDrawerController navDrawerController = Get.find();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navDrawerController.selectIndex(0);
        return false;
      },
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Orders',
                    style: TextStyle(color: grey),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                      onPressed: (){
                        NavDrawerController.to.selectIndex(0);
                      },
                      child:
                      const Text('Shop More',
                        style: TextStyle(color: primary, fontSize: 18),),),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) => orderCard(index, controller.orders[index]),
                itemCount: controller.orders.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderCard(int index, Order order) {
    return Card(
      color: order.status!='Cancelled'?greenTint : Colors.amberAccent,
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 7,
            child: Container(
              //height: 90,
              margin: const EdgeInsets.only(bottom: 5),
              color: white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.status,
                            style: order.status != 'Cancelled' ?
                            const TextStyle(color: green)
                            : const TextStyle(color: Colors.black),
                        ),
                        Row(
                          children:[
                            order.status != 'Cancelled'
                            ? IconButton(onPressed: (){
                              controller.viewInvoice(order.id);
                              },
                            icon: const Icon(Icons.receipt_long,color: Colors.black,size: 20,))
                            : Container(),
                            order.status != 'Cancelled'
                            ? IconButton(onPressed: (){
                              controller.cancelOrder(order.id);
                              cancelOrder(order.id);
                              },
                                icon: const Icon(Icons.delete,color: Colors.black,size: 20,))
                                : Container(),
                            order.status != 'Cancelled'
                                ? IconButton(onPressed: (){
                                  controller.shareOrder(order.id);},
                                icon: const Icon(Icons.share,color: Colors.black,size: 20,))
                                : Container(),
                          ]
                        ),
                      ],
                    ),
                    //const Text('Track your Order')

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Text('', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              Text('Name', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              Text('Count', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          for (var entry in order.items.asMap().entries)
                            TableRow(
                              children: [
                                Text('${entry.key+1}', style: const TextStyle(color: Colors.black54)),
                                Text(entry.value.itemName, style: const TextStyle(color: Colors.black54)),
                                Text('${entry.value.count}', style: const TextStyle(color: Colors.black54)),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Order Date : ${dateFormat.format(order.orderDate)}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  Text(
                    '${order.orderValue.toPrecision(1)}/-',
                    style: const TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  //const Icon(Icons.arrow_forward_ios_sharp,color: white,size: 20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
