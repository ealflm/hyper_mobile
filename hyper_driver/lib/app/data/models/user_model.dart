class User {
  String? driverId;
  String? partnerId;
  String? vehicleId;
  String? firstName;
  String? lastName;
  String? photoUrl;
  String? gender;
  String? phone;
  String? dateOfBirth;
  String? createdDate;
  String? modifiedDate;
  String? status;
  String? role;
  String? jti;
  int? exp;

  User(
      {this.driverId,
      this.partnerId,
      this.vehicleId,
      this.firstName,
      this.lastName,
      this.photoUrl,
      this.gender,
      this.phone,
      this.dateOfBirth,
      this.createdDate,
      this.modifiedDate,
      this.status,
      this.role,
      this.jti,
      this.exp});

  String? get fullName {
    return '$firstName $lastName';
  }

  String? get url {
    return 'https://se32.blob.core.windows.net/customer/$photoUrl';
  }

  User.fromJson(Map<String, dynamic> json) {
    driverId = json['DriverId'];
    partnerId = json['PartnerId'];
    vehicleId = json['VehicleId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    photoUrl = json['PhotoUrl'];
    gender = json['Gender'];
    phone = json['Phone'];
    dateOfBirth = json['DateOfBirth'];
    createdDate = json['CreatedDate'];
    modifiedDate = json['ModifiedDate'];
    status = json['Status'];
    role = json['Role'];
    jti = json['jti'];
    exp = json['exp'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['DriverId'] = driverId;
    data['PartnerId'] = partnerId;
    data['VehicleId'] = vehicleId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['PhotoUrl'] = photoUrl;
    data['Gender'] = gender;
    data['Phone'] = phone;
    data['DateOfBirth'] = dateOfBirth;
    data['CreatedDate'] = createdDate;
    data['ModifiedDate'] = modifiedDate;
    data['Status'] = status;
    data['Role'] = role;
    data['jti'] = jti;
    data['exp'] = exp;
    return data;
  }
}
