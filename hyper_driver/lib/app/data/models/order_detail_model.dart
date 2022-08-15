class OrderDetail {
  String? orderDetailId;
  String? priceOfRentingServiceId;
  String? orderId;
  double? price;
  int? quantity;
  String? content;
  int? status;

  OrderDetail(
      {this.orderDetailId,
      this.priceOfRentingServiceId,
      this.orderId,
      this.price,
      this.quantity,
      this.content,
      this.status});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    orderDetailId = json['orderDetailId'];
    priceOfRentingServiceId = json['priceOfRentingServiceId'];
    orderId = json['orderId'];
    price = double.tryParse(json['price'].toStringAsFixed(0));
    quantity = json['quantity'];
    content = json['content'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['orderDetailId'] = orderDetailId;
    data['priceOfRentingServiceId'] = priceOfRentingServiceId;
    data['orderId'] = orderId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['content'] = content;
    data['status'] = status;
    return data;
  }
}
