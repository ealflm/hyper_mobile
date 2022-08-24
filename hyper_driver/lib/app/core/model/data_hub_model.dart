class DataHubModel {
  String? id;
  String? firstName;
  String? lastName;
  String? photoUrl;
  String? gender;
  String? phone;
  int? status;
  double? longitude;
  double? latitude;
  String? placeName;
  String? address;
  double? distanceBetween;
  double? point;
  int? intervalLoopIndex;
  String? priceBookingId;
  double? price;
  double? distance;
  int? seats;
  int? totalDriverItems;
  double? feedbackPoint;
  String? vehicleName;
  String? licensePlates;

  DataHubModel({
    this.id,
    this.firstName,
    this.lastName,
    this.photoUrl,
    this.gender,
    this.phone,
    this.status,
    this.longitude,
    this.latitude,
    this.placeName,
    this.address,
    this.distanceBetween,
    this.point,
    this.intervalLoopIndex,
    this.priceBookingId,
    this.price,
    this.distance,
    this.seats,
    this.totalDriverItems,
    this.feedbackPoint,
    this.vehicleName,
    this.licensePlates,
  });

  DataHubModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    photoUrl = json['photoUrl'];
    gender = json['gender'];
    phone = json['phone'];
    status = json['status'];
    longitude = json['longitude']?.toDouble();
    latitude = json['latitude']?.toDouble();
    placeName = json['placeName'];
    address = json['address'];
    distanceBetween = json['distanceBetween']?.toDouble();
    point = json['point']?.toDouble();
    intervalLoopIndex = json['intervalLoopIndex'];
    priceBookingId = json['priceBookingId'];
    price = json['price']?.toDouble();
    distance = json['distance']?.toDouble();
    seats = json['seats'];
    totalDriverItems = json['totalDriverItems'];
    feedbackPoint = json['feedbackPoint']?.toDouble();
    vehicleName = json['vehicleName'];
    licensePlates = json['licensePlates'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['PhotoUrl'] = photoUrl;
    data['Gender'] = gender;
    data['Phone'] = phone;
    data['Status'] = status;
    data['Longitude'] = longitude;
    data['Latitude'] = latitude;
    data['PlaceName'] = placeName;
    data['Address'] = address;
    data['DistanceBetween'] = distanceBetween;
    data['Point'] = point;
    data['IntervalLoopIndex'] = intervalLoopIndex;
    data['PriceBookingId'] = priceBookingId;
    data['Price'] = price;
    data['Distance'] = distance;
    data['Seats'] = seats;
    data['TotalDriverItems'] = totalDriverItems;
    data['FeedbackPoint'] = feedbackPoint;
    data['VehicleName'] = vehicleName;
    data['LicensePlates'] = licensePlates;
    return data;
  }
}
