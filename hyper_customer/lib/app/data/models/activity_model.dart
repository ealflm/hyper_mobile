class Activity {
  List<Orders>? orders;
  List<Transactions>? transactions;
  List<CustomerTrips>? customerTrips;

  Activity({this.orders, this.transactions, this.customerTrips});

  Activity.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders?.add(Orders.fromJson(v));
      });
    }
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions?.add(Transactions.fromJson(v));
      });
    }
    if (json['customerTrips'] != null) {
      customerTrips = <CustomerTrips>[];
      json['customerTrips'].forEach((v) {
        customerTrips?.add(CustomerTrips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders?.map((v) => v.toJson()).toList();
    }
    if (transactions != null) {
      data['transactions'] = transactions?.map((v) => v.toJson()).toList();
    }
    if (customerTrips != null) {
      data['customerTrips'] = customerTrips?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String? id;
  String? customerId;
  String? serviceTypeId;
  String? serviceTypeName;
  String? discountId;
  String? createdDate;
  int? totalPrice;
  int? status;

  Orders(
      {this.id,
      this.customerId,
      this.serviceTypeId,
      this.serviceTypeName,
      this.discountId,
      this.createdDate,
      this.totalPrice,
      this.status});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    serviceTypeId = json['serviceTypeId'];
    serviceTypeName = json['serviceTypeName'];
    discountId = json['discountId'];
    createdDate = json['createdDate'];
    totalPrice = json['totalPrice'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['customerId'] = customerId;
    data['serviceTypeId'] = serviceTypeId;
    data['serviceTypeName'] = serviceTypeName;
    data['discountId'] = discountId;
    data['createdDate'] = createdDate;
    data['totalPrice'] = totalPrice;
    data['status'] = status;
    return data;
  }
}

class Transactions {
  String? orderId;
  String? walletId;
  double? amount;
  DateTime? createdDate;
  String? content;
  int? status;
  int? filter;

  Transactions(
      {this.orderId,
      this.walletId,
      this.amount,
      this.createdDate,
      this.content,
      this.status});

  Transactions.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    walletId = json['walletId'];
    amount = double.tryParse(json['amount'].toStringAsFixed(0));
    createdDate = DateTime.parse(json['createdDate']);
    content = json['content'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['walletId'] = walletId;
    data['amount'] = amount;
    data['createdDate'] = createdDate;
    data['content'] = content;
    data['status'] = status;
    return data;
  }
}

class CustomerTrips {
  String? customerTripId;
  String? customerId;
  String? routeId;
  String? vehicleId;
  int? distance;
  String? createdDate;
  String? modifiedDate;
  String? rentDeadline;
  String? coordinates;
  String? serviceTypeName;
  String? vehicleName;
  String? licensePlates;
  int? status;

  CustomerTrips(
      {this.customerTripId,
      this.customerId,
      this.routeId,
      this.vehicleId,
      this.distance,
      this.createdDate,
      this.modifiedDate,
      this.rentDeadline,
      this.coordinates,
      this.serviceTypeName,
      this.vehicleName,
      this.licensePlates,
      this.status});

  CustomerTrips.fromJson(Map<String, dynamic> json) {
    customerTripId = json['customerTripId'];
    customerId = json['customerId'];
    routeId = json['routeId'];
    vehicleId = json['vehicleId'];
    if (json['distance'] != null) {
      distance = int.tryParse(json['distance'].toStringAsFixed(0));
    }
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    rentDeadline = json['rentDeadline'];
    coordinates = json['coordinates'];
    serviceTypeName = json['serviceTypeName'];
    vehicleName = json['vehicleName'];
    licensePlates = json['licensePlates'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['customerTripId'] = customerTripId;
    data['customerId'] = customerId;
    data['routeId'] = routeId;
    data['vehicleId'] = vehicleId;
    data['distance'] = distance;
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['rentDeadline'] = rentDeadline;
    data['coordinates'] = coordinates;
    data['serviceTypeName'] = serviceTypeName;
    data['vehicleName'] = vehicleName;
    data['licensePlates'] = licensePlates;
    data['status'] = status;
    return data;
  }
}
