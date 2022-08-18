class Order {
  String? customerId;
  String? serviceTypeId;
  String? discountId;
  String? partnerId;
  List<OrderDetailsInfos>? orderDetailsInfos;
  int? totalPrice;

  Order(
      {this.customerId,
      this.serviceTypeId,
      this.discountId,
      this.partnerId,
      this.orderDetailsInfos,
      this.totalPrice});

  Order.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    serviceTypeId = json['serviceTypeId'];
    discountId = json['discountId'];
    partnerId = json['partnerId'];
    if (json['orderDetailsInfos'] != null) {
      orderDetailsInfos = <OrderDetailsInfos>[];
      json['orderDetailsInfos'].forEach((v) {
        orderDetailsInfos?.add(OrderDetailsInfos.fromJson(v));
      });
    }
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['serviceTypeId'] = serviceTypeId;
    data['discountId'] = discountId;
    data['partnerId'] = partnerId;
    if (orderDetailsInfos != null) {
      data['orderDetailsInfos'] =
          orderDetailsInfos?.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = totalPrice;
    return data;
  }
}

class OrderDetailsInfos {
  String? packageId;
  String? priceOfBusServiceId;
  String? priceOfBookingServiceId;
  String? priceOfRentingServiceId;
  int? price;
  int? quantity;
  String? content;
  String? licensePlates;
  int? modePrice;

  OrderDetailsInfos({
    this.packageId,
    this.priceOfBusServiceId,
    this.priceOfBookingServiceId,
    this.priceOfRentingServiceId,
    this.price,
    this.quantity,
    this.content,
    this.licensePlates,
    this.modePrice,
  });

  OrderDetailsInfos.fromJson(Map<String, dynamic> json) {
    packageId = json['packageId'];
    priceOfBusServiceId = json['priceOfBusServiceId'];
    priceOfBookingServiceId = json['priceOfBookingServiceId'];
    priceOfRentingServiceId = json['priceOfRentingServiceId'];
    price = json['price'];
    quantity = json['quantity'];
    content = json['content'];
    licensePlates = json['licensePlates'];
    modePrice = json['modePrice'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['packageId'] = packageId;
    data['priceOfBusServiceId'] = priceOfBusServiceId;
    data['priceOfBookingServiceId'] = priceOfBookingServiceId;
    data['priceOfRentingServiceId'] = priceOfRentingServiceId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['content'] = content;
    data['licensePlates'] = licensePlates;
    data['modePrice'] = modePrice;
    return data;
  }
}
