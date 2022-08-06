import 'package:hyper_customer/app/core/utils/date_time_utils.dart';
import 'package:intl/intl.dart';

class CitizenIdentityCard {
  String cccd;
  String cmnd;
  String name;
  DateTime? birthDate;
  Gender? gender;
  String address;
  DateTime? createdDate;

  String? city;
  String? district;
  String? ward;
  String? street;

  String get birthDateStr {
    if (birthDate == null) return '-';
    return DateFormat("dd/MM/yyyy").format(birthDate!);
  }

  String get createdDateStr {
    if (createdDate == null) return '-';
    return DateFormat("dd/MM/yyyy").format(createdDate!);
  }

  String get genderStr {
    if (gender == null) return '-';
    return gender == Gender.male ? 'Nam' : 'Nữ';
  }

  CitizenIdentityCard({
    required this.cccd,
    required this.cmnd,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.address,
    required this.createdDate,
  }) {
    var data = address.split(', ');
    city = data[3];
    district = data[2];
    ward = data[1];
    street = data[0];
  }

  CitizenIdentityCard.fromString({
    required this.cccd,
    required this.cmnd,
    required this.name,
    required String birthDate,
    required String gender,
    required this.address,
    required String createdDate,
  }) {
    this.birthDate = DateTimeUtils.formCCCD(birthDate);
    this.gender = gender == 'Nam' ? Gender.male : Gender.female;
    this.createdDate = DateTimeUtils.formCCCD(createdDate);

    var data = address.split(', ');
    city = data[3];
    district = data[2];
    ward = data[1];
    street = data[0];
  }
}

enum Gender {
  male,
  female,
}
