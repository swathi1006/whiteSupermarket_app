class ItemInvoice {
  String itemId;
  String itemCode;
  String itemName;
  double price;
  double offerPrice;
  double discount;
  int count;
  ItemInvoice(
      this.itemId,
      this.itemCode,
      this.itemName,
      this.price,
      this.offerPrice,
      this.discount,
      this.count
      );
}

class Invoice {
  String id;
  String userId;
  String userName;
  String mobile;
  String address;
  String status;
  DateTime orderDate;
  double orderValue;
  String paymentMode;
  List<ItemInvoice> itemInvoice;

  Invoice(
      this.id,
      this.userId,
      this.userName,
      this.mobile,
      this.address,
      this.status,
      this.orderDate,
      this.orderValue,
      this.paymentMode,
      this.itemInvoice,
      );
}