class User {
  String? customerId;
  String? firstName;
  String? lastName;
  String? gender;
  String? phone;
  String? address1;
  String? address2;
  String? photoUrl;
  String? dateOfBirth;
  String? email;
  String? createdDate;
  String? modifiedDate;
  String? status;
  String? role;
  String? jti;
  int? exp;

  String? get fullName {
    return '$firstName $lastName';
  }

  String? get url {
    return 'https://se32.blob.core.windows.net/customer/$photoUrl';
  }

  User(
      {this.customerId,
      this.firstName,
      this.lastName,
      this.gender,
      this.phone,
      this.address1,
      this.address2,
      this.photoUrl,
      this.dateOfBirth,
      this.email,
      this.createdDate,
      this.modifiedDate,
      this.status,
      this.role,
      this.jti,
      this.exp});

  User.fromJson(Map<String, dynamic> json) {
    customerId = json['CustomerId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    gender = json['Gender'];
    phone = json['Phone'];
    address1 = json['Address1'];
    address2 = json['Address2'];
    photoUrl = json['PhotoUrl'];
    dateOfBirth = json['DateOfBirth'];
    email = json['Email'];
    createdDate = json['CreatedDate'];
    modifiedDate = json['ModifiedDate'];
    status = json['Status'];
    role = json['Role'];
    jti = json['jti'];
    exp = json['exp'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['CustomerId'] = customerId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Gender'] = gender;
    data['Phone'] = phone;
    data['Address1'] = address1;
    data['Address2'] = address2;
    data['PhotoUrl'] = photoUrl;
    data['DateOfBirth'] = dateOfBirth;
    data['Email'] = email;
    data['CreatedDate'] = createdDate;
    data['ModifiedDate'] = modifiedDate;
    data['Status'] = status;
    data['Role'] = role;
    data['jti'] = jti;
    data['exp'] = exp;
    return data;
  }
}
