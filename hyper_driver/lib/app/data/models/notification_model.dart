import 'package:hyper_driver/app/core/utils/date_time_utils.dart';

class Notification {
  String? id;
  String? customerId;
  String? customerName;
  String? title;
  String? message;
  int? createdDateTimeStamp;
  int? modifiedDateTimeStamp;
  int? filter;

  DateTime? get createdDate {
    return DateTimeUtils.parseDateTime(createdDateTimeStamp);
  }

  Notification(
      {this.id,
      this.customerId,
      this.customerName,
      this.title,
      this.message,
      this.createdDateTimeStamp,
      this.modifiedDateTimeStamp});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    title = json['title'];
    message = json['message'];
    createdDateTimeStamp = json['createdDateTimeStamp'];
    modifiedDateTimeStamp = json['modifiedDateTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['title'] = title;
    data['message'] = message;
    data['createdDateTimeStamp'] = createdDateTimeStamp;
    data['modifiedDateTimeStamp'] = modifiedDateTimeStamp;
    return data;
  }
}
