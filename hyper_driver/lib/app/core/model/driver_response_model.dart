import 'package:hyper_driver/app/core/model/data_hub_model.dart';

class DriverResponseModel {
  int? statusCode;
  DataHubModel? driver;
  DataHubModel? customer;
  String? type;
  String? message;

  DriverResponseModel({
    this.statusCode,
    this.driver,
    this.customer,
    this.type,
    this.message,
  });

  DriverResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    driver = DataHubModel.fromJson(json['driver']);
    customer = DataHubModel.fromJson(json['customer']);
    type = json['type'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['Driver'] = driver?.toJson();
    data['Customer'] = customer?.toJson();
    data['type'] = type;
    data['message'] = message;
    return data;
  }
}
