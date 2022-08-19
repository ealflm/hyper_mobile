import 'package:hyper_driver/app/core/model/data_hub_model.dart';

class DriverResponseModel {
  bool? accepted;
  DataHubModel? driver;
  DataHubModel? customer;

  DriverResponseModel({this.accepted, this.driver, this.customer});

  DriverResponseModel.fromJson(Map<String, dynamic> json) {
    accepted = json['accepted'];
    driver = DataHubModel.fromJson(json['driver']);
    customer = DataHubModel.fromJson(json['customer']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Accept'] = accepted;
    data['Driver'] = driver?.toJson();
    data['Customer'] = customer?.toJson();
    return data;
  }
}
