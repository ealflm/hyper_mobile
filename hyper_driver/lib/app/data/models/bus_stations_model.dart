import 'package:latlong2/latlong.dart';

class BusStations {
  List<BusStation>? busStationList;

  BusStations({this.busStationList});

  BusStations.fromJson(List<dynamic> list) {
    busStationList = <BusStation>[];
    for (var v in list) {
      busStationList?.add(BusStation.fromJson(v));
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (busStationList != null) {
      data['bus-station'] = busStationList?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BusStation {
  String? id;
  String? title;
  String? description;
  String? address;
  LatLng? location;
  int? status;

  BusStation(
      {this.id,
      this.title,
      this.description,
      this.address,
      this.location,
      this.status});

  BusStation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    address = json['address'];
    location = LatLng(json['latitude'], json['longitude']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['address'] = address;
    data['longitude'] = location?.longitude;
    data['latitude'] = location?.latitude;
    data['status'] = status;
    return data;
  }
}
