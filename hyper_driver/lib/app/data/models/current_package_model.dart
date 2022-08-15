class CurrentPackage {
  String? packageId;
  String? packageName;
  String? packageExpire;
  double? packageExpireTimeStamp;
  int? packagePrice;
  String? packagePhotoUrl;
  int? currentDistances;
  int? limitDistances;
  int? currentCardSwipes;
  int? limitCardSwipes;
  int? currentNumberOfTrips;
  int? limitNumberOfTrips;
  int? discountValueTrip;

  CurrentPackage(
      {this.packageId,
      this.packageName,
      this.packageExpire,
      this.packageExpireTimeStamp,
      this.packagePrice,
      this.packagePhotoUrl,
      this.currentDistances,
      this.limitDistances,
      this.currentCardSwipes,
      this.limitCardSwipes,
      this.currentNumberOfTrips,
      this.limitNumberOfTrips,
      this.discountValueTrip});

  CurrentPackage.fromJson(Map<String, dynamic> json) {
    packageId = json['packageId'];
    packageName = json['packageName'];
    packageExpire = json['packageExpire'];
    packageExpireTimeStamp = json['packageExpireTimeStamp'];
    packagePrice = json['packagePrice'];
    packagePhotoUrl = json['packagePhotoUrl'];
    currentDistances = json['currentDistances'];
    limitDistances = json['limitDistances'];
    currentCardSwipes = json['currentCardSwipes'];
    limitCardSwipes = json['limitCardSwipes'];
    currentNumberOfTrips = json['currentNumberOfTrips'];
    limitNumberOfTrips = json['limitNumberOfTrips'];
    discountValueTrip = json['discountValueTrip'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['packageId'] = packageId;
    data['packageName'] = packageName;
    data['packageExpire'] = packageExpire;
    data['packageExpireTimeStamp'] = packageExpireTimeStamp;
    data['packagePrice'] = packagePrice;
    data['packagePhotoUrl'] = packagePhotoUrl;
    data['currentDistances'] = currentDistances;
    data['limitDistances'] = limitDistances;
    data['currentCardSwipes'] = currentCardSwipes;
    data['limitCardSwipes'] = limitCardSwipes;
    data['currentNumberOfTrips'] = currentNumberOfTrips;
    data['limitNumberOfTrips'] = limitNumberOfTrips;
    data['discountValueTrip'] = discountValueTrip;
    return data;
  }
}
