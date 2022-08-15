class RentStations {
  int? statusCode;
  String? message;
  Body? body;

  RentStations({this.statusCode, this.message, this.body});

  RentStations.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    body = json['body'] != null ? Body?.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (body != null) {
      data['body'] = body?.toJson();
    }
    return data;
  }
}

class Body {
  int? pageSize;
  int? totalItems;
  List<Items>? items;

  Body({this.pageSize, this.totalItems, this.items});

  Body.fromJson(Map<String, dynamic> json) {
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pageSize'] = pageSize;
    data['totalItems'] = totalItems;
    if (items != null) {
      data['items'] = items?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? title;
  String? description;
  String? address;
  String? partnerId;
  String? companyName;
  double? longitude;
  double? latitude;
  String? createdDate;
  String? modifiedDate;
  int? status;

  Items(
      {this.id,
      this.title,
      this.description,
      this.address,
      this.partnerId,
      this.companyName,
      this.longitude,
      this.latitude,
      this.createdDate,
      this.modifiedDate,
      this.status});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    address = json['address'];
    partnerId = json['partnerId'];
    companyName = json['companyName'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['address'] = address;
    data['partnerId'] = partnerId;
    data['companyName'] = companyName;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['status'] = status;
    return data;
  }
}
