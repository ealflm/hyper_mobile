class VehicleRental {
  String? partnerId;
  String? priceOfRentingServiceId;
  String? publishYearName;
  String? categoryName;
  int? minTime;
  int? maxTime;
  int? pricePerHour;
  int? pricePerDay;
  String? vehicleName;
  String? licensePlates;
  String? color;
  int? status;

  VehicleRental(
      {this.partnerId,
      this.priceOfRentingServiceId,
      this.publishYearName,
      this.categoryName,
      this.minTime,
      this.maxTime,
      this.pricePerHour,
      this.pricePerDay,
      this.vehicleName,
      this.licensePlates,
      this.color,
      this.status});

  VehicleRental.fromJson(Map<String, dynamic> json) {
    partnerId = json['partnerId'];
    priceOfRentingServiceId = json['priceOfRentingServiceId'];
    publishYearName = json['publishYearName'];
    categoryName = json['categoryName'];
    minTime = json['minTime'];
    maxTime = json['maxTime'];
    pricePerHour = json['pricePerHour'];
    pricePerDay = json['pricePerDay'];
    vehicleName = json['vehicleName'];
    licensePlates = json['licensePlates'];
    color = json['color'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['partnerId'] = partnerId;
    data['priceOfRentingServiceId'] = priceOfRentingServiceId;
    data['publishYearName'] = publishYearName;
    data['categoryName'] = categoryName;
    data['minTime'] = minTime;
    data['maxTime'] = maxTime;
    data['pricePerHour'] = pricePerHour;
    data['pricePerDay'] = pricePerDay;
    data['vehicleName'] = vehicleName;
    data['licensePlates'] = licensePlates;
    data['color'] = color;
    data['status'] = status;
    return data;
  }
}
