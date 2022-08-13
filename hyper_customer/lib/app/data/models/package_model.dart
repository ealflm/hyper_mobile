class Package {
  String? id;
  String? name;
  int? peopleQuantity;
  int? duration;
  String? photoUrl;
  String? description;
  int? price;
  String? promotedTitle;
  List<PackageItems>? packageItems;
  int? status;

  Package(
      {this.id,
      this.name,
      this.peopleQuantity,
      this.duration,
      this.photoUrl,
      this.description,
      this.price,
      this.promotedTitle,
      this.packageItems,
      this.status});

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    peopleQuantity = json['peopleQuantity'];
    duration = json['duration'];
    photoUrl = json['photoUrl'];
    description = json['description'];
    price = json['price'];
    promotedTitle = json['promotedTitle'];
    if (json['packageItems'] != null) {
      packageItems = <PackageItems>[];
      json['packageItems'].forEach((v) {
        packageItems?.add(PackageItems.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['peopleQuantity'] = peopleQuantity;
    data['duration'] = duration;
    data['photoUrl'] = photoUrl;
    data['description'] = description;
    data['price'] = price;
    data['promotedTitle'] = promotedTitle;
    if (packageItems != null) {
      data['packageItems'] = packageItems?.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class PackageItems {
  String? packageId;
  String? serviceTypeId;
  String? name;
  int? limit;
  int? value;
  int? status;

  PackageItems(
      {this.packageId,
      this.serviceTypeId,
      this.name,
      this.limit,
      this.value,
      this.status});

  PackageItems.fromJson(Map<String, dynamic> json) {
    packageId = json['packageId'];
    serviceTypeId = json['serviceTypeId'];
    name = json['name'];
    limit = json['limit'];
    value = json['value'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['packageId'] = packageId;
    data['serviceTypeId'] = serviceTypeId;
    data['name'] = name;
    data['limit'] = limit;
    data['value'] = value;
    data['status'] = status;
    return data;
  }
}
