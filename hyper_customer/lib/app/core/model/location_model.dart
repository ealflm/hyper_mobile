class LocationModel {
  String id;
  double longitude;
  double latitude;
  double endLongitude;
  double endLatitude;
  String priceBookingId;
  double price;
  double distance;
  int seats;

  LocationModel({
    this.id = '',
    this.latitude = 0,
    this.longitude = 0,
    this.endLatitude = 0,
    this.endLongitude = 0,
    this.priceBookingId = '',
    this.price = 0,
    this.distance = 0,
    this.seats = 0,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['Longitude'] = longitude;
    data['Latitude'] = latitude;
    data['EndLongitude'] = endLongitude;
    data['EndLatitude'] = endLatitude;
    data['PriceBookingId'] = priceBookingId;
    data['Price'] = price;
    data['Distance'] = distance;
    data['Seats'] = seats;
    return data;
  }
}
