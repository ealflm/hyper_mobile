class PlaceDetail {
  String? placeId;
  String? formattedAddress;
  Geometry? geometry;
  PlusCode? plusCode;
  Compound? compound;
  String? name;
  String? url;

  PlaceDetail({
    this.placeId,
    this.formattedAddress,
    this.geometry,
    this.plusCode,
    this.compound,
    this.name,
    this.url,
  });

  PlaceDetail.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    formattedAddress = json['formatted_address'];
    geometry =
        json['geometry'] != null ? Geometry?.fromJson(json['geometry']) : null;
    plusCode = json['plus_code'] != null
        ? PlusCode?.fromJson(json['plus_code'])
        : null;
    compound =
        json['compound'] != null ? Compound?.fromJson(json['compound']) : null;
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['place_id'] = placeId;
    data['formatted_address'] = formattedAddress;
    if (geometry != null) {
      data['geometry'] = geometry?.toJson();
    }
    if (plusCode != null) {
      data['plus_code'] = plusCode?.toJson();
    }
    if (compound != null) {
      data['compound'] = compound?.toJson();
    }
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class Geometry {
  Location? location;

  Geometry({this.location});

  Geometry.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location?.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location?.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['compound_code'] = compoundCode;
    data['global_code'] = globalCode;
    return data;
  }
}

class Compound {
  String? district;
  String? commune;
  String? province;

  Compound({this.district, this.commune, this.province});

  Compound.fromJson(Map<String, dynamic> json) {
    district = json['district'];
    commune = json['commune'];
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['district'] = district;
    data['commune'] = commune;
    data['province'] = province;
    return data;
  }
}
