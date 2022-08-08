class BusTrip {
  String? name;
  int? totalStation;
  int? distance;
  double? price;

  BusTrip({this.name, this.totalStation, this.distance, this.price});

  BusTrip.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    totalStation = int.parse(json['totalStation'].toString());
    distance = int.parse(json['distance'].toStringAsFixed(0));
    price = double.parse(json['price'].toString());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['totalStation'] = totalStation;
    data['distance'] = distance;
    data['price'] = price;
    return data;
  }
}
