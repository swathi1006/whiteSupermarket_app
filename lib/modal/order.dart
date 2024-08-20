class Item {
  String itemId;
  String itemName;
  String itemImage;
  int count;
  double price;
  Item(this.itemId, this.itemName,this.itemImage, this.count, this.price);
}

class Order {
  String id;
  DateTime orderDate;
  String status;
  double orderValue;
  List<Item> items;

  Order(
      this.id,
      this.orderDate,
      this.status,
      this.orderValue,
      this.items,
      );
}