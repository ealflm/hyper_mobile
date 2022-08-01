import 'package:hyper_customer/app/data/models/directions_model.dart';
import 'package:latlong2/latlong.dart';

class BusDirection {
  List<Steps>? steps;

  BusDirection({this.steps});

  BusDirection.fromJson(List<dynamic> json) {
    json = json.reversed.toList();
    steps = <Steps>[];
    for (var v in json) {
      steps?.add(Steps.fromJson(v));
    }
  }
}

class Steps {
  int? index;
  String? id;
  String? partnerId;
  String? name;
  int? totalStation;
  double? distance;
  List<StationList>? stationList;
  List<LatLng>? latLngList;
  int? status;

  Steps(
      {this.id,
      this.partnerId,
      this.name,
      this.totalStation,
      this.distance,
      this.stationList,
      this.status});

  Steps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partnerId = json['partnerId'];
    name = json['name'];
    totalStation = json['totalStation'];
    distance = double.parse(json['distance'].toString());
    if (json['stationList'] != null) {
      List<dynamic> list = json['stationList'];
      List<dynamic> data = list.reversed.toList();
      stationList = <StationList>[];
      for (var v in data) {
        stationList?.add(StationList.fromJson(v));
      }
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['partnerId'] = partnerId;
    data['name'] = name;
    data['totalStation'] = totalStation;
    data['distance'] = distance;
    if (stationList != null) {
      data['stationList'] = stationList?.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class StationList {
  String? id;
  String? title;
  String? description;
  String? address;
  double? longitude;
  double? latitude;
  int? status;

  StationList(
      {this.id,
      this.title,
      this.description,
      this.address,
      this.longitude,
      this.latitude,
      this.status});

  StationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['status'] = status;
    return data;
  }
}
