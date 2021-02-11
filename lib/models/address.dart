class AddressModel {
  int houseNumber;
  String street;
  String city;
  String country;
  String postalCode;

  AddressModel({
    this.houseNumber,
    this.street,
    this.city,
    this.country,
    this.postalCode,
  });

  Map<String, dynamic> asMap() {
    return {
      'house_number': houseNumber,
      'street_name': street,
      'city': city,
      'country': country,
      'postal_code': postalCode,
    };
  }
}
