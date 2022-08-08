class BusTrip {
  String? name;
  int? totalStation;
  int? distance;
  double? price;

  BusTrip({this.name, this.totalStation, this.distance, this.price});

  BusTrip.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    totalStation = int.tryParse(json['totalStation'].toString());
    distance = int.tryParse(json['distance'].toStringAsFixed(0));
    price = double.tryParse(json['price'].toString());
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
