
import 'package:mongo_dart/mongo_dart.dart';
import 'package:whitesupermarketapp/controller/my_account_controller.dart';
import '../modal/cart.dart';
import '../modal/order.dart';
import '../modal/invoice.dart';
import '../modal/product.dart';
import '../modal/user.dart';
import '../modal/user_address.dart';
import 'constants.dart';
import 'global.dart';
import 'dart:math';

class MongoDB {
  static Future<Map<String, dynamic>> connect() async {
    db = await Db.create(MONGO_URL);
    await db!.open();
    //var status = db!.serverStatus();
    var collection_items = db!.collection(COLLECTION_ITEMS);
    var collection_banners = db!.collection(COLLECTION_BANNERS);
    collection_users = db!.collection('users');
    //print('Connected to MongoDB');
    //addUser();
    return {
      'db': db,
      'collection_items': collection_items,
      'collection_banners': collection_banners
    };
  }

  static getBanners() async {
    globalBanners = await collection_banners!.find().toList();
    //print(globalBanners);
  }

  static getTags() async {
    var collection_tags = db!.collection("tags");
    globalTags = await collection_tags.find().toList();
    //print(globalTags);
  }



  static Future<List<Map<String, dynamic>>> getItems() async {
  var items = await collection_items!.aggregateToStream([
    {
      '\$sample': {
        'size': 6
      }
    }
  ]).toList();
  return items;
}

  static Future<List<Map<String, dynamic>>> getCategoryItems(String category) async {
    var items = await collection_items!.aggregateToStream([
      {
        '\$match': {
          'item_catogory': {
            '\$in': [category]
          }
        }
      },
      {
        '\$sample': {
          'size': 6
        }
      }
    ]).toList();
    //print(items);
    //print('------------------------Item fetched-------------------------');
    return items;
  }


  static Future<List<Map<String, dynamic>>> getTagItems(String tag) async {
    var items = await collection_items!.aggregateToStream([
      {
        '\$match': {
          'item_tags': {
            '\$in': [tag]
          }
        }
      },
      {
        '\$sample': {
          'size': 6
        }
      }
    ]).toList();
    //print(items);
    //print('------------------------Item fetched-------------------------');
    return items;
  }

  static getItemsById(id) async {
    var items = await collection_items!.findOne(where.eq('id', id));
    //print(items);
    //print('------------------------Item fetched-------------------------');
    return items;
  }


  static getuser(String phone) async {
    globalusers = (await collection_users?.findOne(where.eq('phone', phone)))!;
    //print(globalusers);
    UserId = globalusers['_id'].toHexString();
    UserName = globalusers['name'];
    //var usercart = globalusers['user_cart'].toList();
    getCart();
    getAddress();
    getOrder();
    //print(globalcart);
    //print(globaladdress);
    //print(globalorder);
    //print(UserId);

    //addUserOrder(order);
    //getUserAddress(UserId);
    //addAddress(userAddress);
    //updateItemPrice(UserId, '1', 3.99);
    //globalcart = await collection_users!.find().toList();
    //var userId = ObjectId.parse('65fc3523f2e9ef7611000000');
    //print(await collection_users?.findOne(where.eq('_id', userId)));
    //await collection_users?.update(where.eq('_id', userId), modify.push('user_cart', {'item_id': '123', 'item_name': 'Apple', 'item_price': 1.99,}));
  }

  static getCart() async {
    var usercart = (globalusers['user_cart'] ?? []).toList();
    globalcart = usercart.cast<Map<String, dynamic>>();
  }

  static getAddress() async {
    var useraddress = (globalusers['user_address'] ?? []).toList();
    globaladdress = useraddress.cast<Map<String, dynamic>>();
  }

  static getOrder() async {
    var userorder = (globalusers['user_order'] ?? []).toList();
    globalorder = userorder.cast<Map<String, dynamic>>();
  }

  static Future<void> updateItemPrice(String userId, String itemId,
      double newPrice) async {
    //print(UserId);
    await collection_users?.update(
        where.eq('_id', ObjectId.parse(UserId)).eq('user_cart.item_id', itemId),
        modify.set('user_cart.item_price', newPrice)
    );

    var updatedUser = await collection_users?.findOne(
        where.eq('_id', ObjectId.parse(UserId)));
    //print(updatedUser);
    //print('Item price updated');
  }
}
  Future<void> addUserAddresstoServer(UserAddress userAddress) async {
    await collection_users?.update(
        where.eq('_id', ObjectId.parse(UserId)), modify.push('user_address', {
      'id': userAddress.id,
      'name': userAddress.name,
      'mobile': userAddress.mobile,
      'addressLine1': userAddress.addressLine1,
      'addressLine2': userAddress.addressLine2,
      'state': userAddress.state,
      'city': userAddress.city,
      'pincode': userAddress.pincode,
      'isDefault': userAddress.isDefault,
    }));
  }

  Future<void> addCartItem(Product product) async {
    await collection_users?.update(
        where.eq('_id', ObjectId.parse(UserId)), modify.push('user_cart', {
      'id': product.id,
      'item_name': product.item_name,
      //'item_mrp': product.item_mrp,
      //'offer_price': product.offer_price,
      //'discount': product.discount,
      //'item_image': product.item_image,
      //'instock_outstock_indication': product.instock_outstock_indication,
      //'item_discription': product.item_discription,
      'count': product.cartCount.value,
    }));
  }

Future<void> updateCartItem(String id,int count) async {
  var user = await collection_users?.findOne(where.eq('_id', ObjectId.parse(UserId)));
  var cart = user?['user_cart'] as List;
  var itemIndex = cart.indexWhere((item) => item['id'] == id);
  cart[itemIndex]['count'] = count;
  await collection_users?.update(where.eq('_id', ObjectId.parse(UserId)), modify.set('user_cart', cart));
}

Future<void> deleteCartItem(String id) async {
  var user = await collection_users?.findOne(where.eq('_id', ObjectId.parse(UserId)));
  var cart = user?['user_cart'] as List;
  var itemIndex = cart.indexWhere((item) => item['id'] == id);
  //print(itemIndex);
  await collection_users?.update(where.eq('_id', ObjectId.parse(UserId)), modify.pull('user_cart', cart[itemIndex]));
}
Future<void> deleteCartItems() async {
  await collection_users?.update(
      where.eq('_id', ObjectId.parse(UserId)),
      modify.set('user_cart', [])
  );
  //print('Cart emptied');
}

  Future<void> addUserOrder(Order order) async {
    List<Map<String, dynamic>> items = order.items.map((item) =>
    {
      'itemId': item.itemId,
      'itemName': item.itemName,
      'itemImage': item.itemImage,
      'count': item.count,
      'price': item.price,
    }).toList();
    await collection_users?.update(
        where.eq('_id', ObjectId.parse(UserId)), modify.push('user_order', {
      'id': order.id,
      'orderDate': order.orderDate,
      'status': order.status,
      'orderValue': order.orderValue,
      'items': items,
    }));
  }


  Future<void> addOrderInvoice(Invoice invoice) async {
    collection_invoice = db!.collection("invoices");
    List<Map<String, dynamic>> itemInvoice = invoice.itemInvoice.map((item) =>
    {
      'item_code': item.itemId,
      'item_code': item.itemCode,
      'item_name': item.itemName,
      'item_mrp': item.price,
      'offer_price': item.offerPrice,
      'discount': item.discount,
      'count': item.count,
    }).toList();
    await collection_invoice?.insert({
      'order_id': invoice.id,
      'cx_id': invoice.userId,
      'cx_name': invoice.userName,
      'cx_phone_number': invoice.mobile,
      'cx_address': invoice.address,
      'order_status': invoice.status,
      'order_date': invoice.orderDate,
      'oba': invoice.orderValue,
      'payment_mode': invoice.paymentMode,
      'item_details': itemInvoice,
    });
  }

Future<void> qupdateCartItem(String id,int count) async {
  var user = await collection_users?.findOne(where.eq('_id', ObjectId.parse(UserId)));
  var cart = user?['user_cart'] as List;
  var itemIndex = cart.indexWhere((item) => item['id'] == id);
  cart[itemIndex]['count'] = count;
  await collection_users?.update(where.eq('_id', ObjectId.parse(UserId)), modify.set('user_cart', cart));
}

  Future<void> cancelOrder(String orderId) async {
    var user = await collection_users?.findOne(where.eq('_id', ObjectId.parse(UserId)));
    var order = user?['user_order'] as List;
    var itemIndex = order.indexWhere((item) => item['id'] == orderId);
    order[itemIndex]['status'] = 'Cancelled';
    await collection_users?.update(where.eq('_id', ObjectId.parse(UserId)), modify.set('user_order', order));

    collection_invoice = db!.collection("invoices");
    await collection_invoice?.update(
        where.eq('order_id', orderId),
        modify.set('order_status', 'Cancelled')
    );
    await MongoDB.getOrder();
  }

Future<void> addUser(String name, String mobile) async {
  await collection_users?.insert({
    'phone': mobile,
    'name': name,
    'created_at': DateTime.now().toUtc(),
  });
}