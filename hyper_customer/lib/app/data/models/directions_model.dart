class Directions {
  List<GeocodedWaypoints>? geocodedWaypoints;
  List<Routes>? routes;

  Directions({this.geocodedWaypoints, this.routes});

  Directions.fromJson(Map<String, dynamic> json) {
    if (json['geocoded_waypoints'] != null) {
      geocodedWaypoints = <GeocodedWaypoints>[];
      json['geocoded_waypoints'].forEach((v) {
        geocodedWaypoints?.add(GeocodedWaypoints.fromJson(v));
      });
    }
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes?.add(Routes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (geocodedWaypoints != null) {
      data['geocoded_waypoints'] =
          geocodedWaypoints?.map((v) => v.toJson()).toList();
    }
    if (routes != null) {
      data['routes'] = routes?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GeocodedWaypoints {
  String? geocoderStatus;
  String? placeId;

  GeocodedWaypoints({this.geocoderStatus, this.placeId});

  GeocodedWaypoints.fromJson(Map<String, dynamic> json) {
    geocoderStatus = json['geocoder_status'];
    placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['geocoder_status'] = geocoderStatus;
    data['place_id'] = placeId;
    return data;
  }
}

class Routes {
  List<Legs>? legs;
  Polyline? overviewPolyline;
  String? summary;

  Routes({this.legs, this.overviewPolyline, this.summary});

  Routes.fromJson(Map<String, dynamic> json) {
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs?.add(Legs.fromJson(v));
      });
    }
    overviewPolyline = json['overview_polyline'] != null
        ? Polyline?.fromJson(json['overview_polyline'])
        : null;
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (legs != null) {
      data['legs'] = legs?.map((v) => v.toJson()).toList();
    }
    if (overviewPolyline != null) {
      data['overview_polyline'] = overviewPolyline?.toJson();
    }
    data['summary'] = summary;
    return data;
  }
}

class Legs {
  Distance? distance;
  Distance? duration;
  String? endAddress;
  EndLocation? endLocation;
  String? startAddress;
  EndLocation? startLocation;
  List<Steps>? steps;

  Legs(
      {this.distance,
      this.duration,
      this.endAddress,
      this.endLocation,
      this.startAddress,
      this.startLocation,
      this.steps});

  Legs.fromJson(Map<String, dynamic> json) {
    distance =
        json['distance'] != null ? Distance?.fromJson(json['distance']) : null;
    duration =
        json['duration'] != null ? Distance?.fromJson(json['duration']) : null;
    endAddress = json['end_address'];
    endLocation = json['end_location'] != null
        ? EndLocation?.fromJson(json['end_location'])
        : null;
    startAddress = json['start_address'];
    startLocation = json['start_location'] != null
        ? EndLocation?.fromJson(json['start_location'])
        : null;
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps?.add(Steps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance?.toJson();
    }
    if (duration != null) {
      data['duration'] = duration?.toJson();
    }
    data['end_address'] = endAddress;
    if (endLocation != null) {
      data['end_location'] = endLocation?.toJson();
    }
    data['start_address'] = startAddress;
    if (startLocation != null) {
      data['start_location'] = startLocation?.toJson();
    }
    if (steps != null) {
      data['steps'] = steps?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}

class EndLocation {
  double? lat;
  double? lng;

  EndLocation({this.lat, this.lng});

  EndLocation.fromJson(Map<String, dynamic> json) {
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

class Steps {
  Distance? distance;
  Distance? duration;
  EndLocation? endLocation;
  String? htmlInstructions;
  String? maneuver;
  Polyline? polyline;
  EndLocation? startLocation;
  String? travelMode;

  Steps(
      {this.distance,
      this.duration,
      this.endLocation,
      this.htmlInstructions,
      this.maneuver,
      this.polyline,
      this.startLocation,
      this.travelMode});

  Steps.fromJson(Map<String, dynamic> json) {
    distance =
        json['distance'] != null ? Distance?.fromJson(json['distance']) : null;
    duration =
        json['duration'] != null ? Distance?.fromJson(json['duration']) : null;
    endLocation = json['end_location'] != null
        ? EndLocation?.fromJson(json['end_location'])
        : null;
    htmlInstructions = json['html_instructions'];
    maneuver = json['maneuver'];
    polyline =
        json['polyline'] != null ? Polyline?.fromJson(json['polyline']) : null;
    startLocation = json['start_location'] != null
        ? EndLocation?.fromJson(json['start_location'])
        : null;
    travelMode = json['travel_mode'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance?.toJson();
    }
    if (duration != null) {
      data['duration'] = duration?.toJson();
    }
    if (endLocation != null) {
      data['end_location'] = endLocation?.toJson();
    }
    data['html_instructions'] = htmlInstructions;
    data['maneuver'] = maneuver;
    if (polyline != null) {
      data['polyline'] = polyline?.toJson();
    }
    if (startLocation != null) {
      data['start_location'] = startLocation?.toJson();
    }
    data['travel_mode'] = travelMode;
    return data;
  }
}

class Polyline {
  String? points;

  Polyline({this.points});

  Polyline.fromJson(Map<String, dynamic> json) {
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['points'] = points;
    return data;
  }
}
