class BookingPrice {
  String? priceOfBookingServiceId;
  String? vehicleTypeId;
  int? fixedPrice;
  int? priceAfterDiscount;
  int? fixedDistance;
  int? pricePerKilometer;
  double? totalPrice;

  BookingPrice(
      {this.priceOfBookingServiceId,
      this.vehicleTypeId,
      this.fixedPrice,
      this.fixedDistance,
      this.pricePerKilometer,
      this.totalPrice});

  BookingPrice.fromJson(Map<String, dynamic> json) {
    priceOfBookingServiceId = json['priceOfBookingServiceId'];
    vehicleTypeId = json['vehicleTypeId'];
    fixedPrice = json['fixedPrice'];
    fixedDistance = json['fixedDistance'];
    pricePerKilometer = json['pricePerKilometer'];
    totalPrice = (json['totalPrice'] / 1000.0).round() * 1000.0;
    priceAfterDiscount = json['priceAfterDiscount'].round();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['priceOfBookingServiceId'] = priceOfBookingServiceId;
    data['vehicleTypeId'] = vehicleTypeId;
    data['fixedPrice'] = fixedPrice;
    data['fixedDistance'] = fixedDistance;
    data['pricePerKilometer'] = pricePerKilometer;
    data['totalPrice'] = totalPrice;
    data['priceAfterDiscount'] = priceAfterDiscount;
    return data;
  }
}
