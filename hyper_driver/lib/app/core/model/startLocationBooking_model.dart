class StartLocationBookingModel {
  String id;
  double longitude;
  double latitude;

  StartLocationBookingModel({
    this.id = '',
    this.latitude = 0,
    this.longitude = 0,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['Longitude'] = longitude;
    data['Latitude'] = latitude;
    return data;
  }
}
