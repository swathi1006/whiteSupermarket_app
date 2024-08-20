class UserAddress {
  String id;
  String name;
  String mobile;
  String addressLine1;
  String addressLine2;
  String state;
  String city;
  String pincode;
  bool isDefault;

  UserAddress(this.id,
      this.name,
      this.mobile,
      this.addressLine1,
      this.addressLine2,
      this.state,
      this.city,
      this.pincode,
      this.isDefault
      );
  @override
  String toString() {
    return '$addressLine1, $addressLine2, City: $city, State: $state,Pincode: $pincode';
  }
}
