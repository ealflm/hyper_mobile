import 'package:dio/dio.dart';
import 'package:hyper_driver/app/core/base/base_repository.dart';
import 'package:hyper_driver/app/data/models/activity_model.dart';
import 'package:hyper_driver/app/data/models/auth_model.dart';
import 'package:hyper_driver/app/data/models/bus_direction_model.dart';
import 'package:hyper_driver/app/data/models/bus_stations_model.dart';
import 'package:hyper_driver/app/data/models/bus_trip_model.dart';
import 'package:hyper_driver/app/data/models/current_package_model.dart';
import 'package:hyper_driver/app/data/models/notification_model.dart';
import 'package:hyper_driver/app/data/models/order_detail_model.dart';
import 'package:hyper_driver/app/data/models/order_model.dart';
import 'package:hyper_driver/app/data/models/package_model.dart';
import 'package:hyper_driver/app/data/models/rent_stations_model.dart';
import 'package:hyper_driver/app/data/models/vehicle_rental_model.dart';
import 'package:hyper_driver/app/data/repository/repository.dart';
import 'package:hyper_driver/app/network/dio_provider.dart';
import 'package:latlong2/latlong.dart';

class RepositoryImpl extends BaseRepository implements Repository {
  @override
  Future<Auth> login(String phoneNumber, String password) {
    var endpoint = "${DioProvider.baseUrl}/authorization/login";
    var data = {
      "username": phoneNumber,
      "password": password,
    };
    var dioCall = dioClient.post(endpoint, data: data);

    try {
      return callApi(dioCall).then((response) => Auth.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> verify(String phoneNumber) {
    var endpoint = "${DioProvider.baseUrl}/authorization/login/verify";
    var param = {
      "phoneNumber": phoneNumber,
    };
    var dioCall = dioClient.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then((response) => response.data['message']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deposit(double amount, int method, String customerId) {
    var endpoint = "${DioProvider.baseUrl}/deposit";
    var data = {
      "amount": amount.toInt(),
      "method": method,
      "customerid": customerId,
    };
    var formData = FormData.fromMap(data);
    var dioCall = dioTokenClient.post(endpoint, data: formData);

    try {
      return callApi(dioCall).then((response) {
        return response.data['body']['id'];
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkDeposit(String id) {
    var endpoint = "${DioProvider.baseUrl}/deposit/$id";
    var dioCall = dioTokenClient.get(endpoint);

    try {
      return callApi(dioCall).then((response) {
        return response.data['statusCode'] == 200;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<double> getBalance(String customerId) {
    var endpoint = "${DioProvider.baseUrl}/wallet/$customerId";
    var dioCall = dioTokenClient.get(endpoint);

    try {
      return callApi(dioCall).then((response) {
        return double.parse(response.data['body']['accountBalance'].toString());
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> cardLink(String customerId, String uid) {
    var endpoint = "${DioProvider.baseUrl}/card-match";
    var data = {
      "customerid": customerId,
      "uid": uid,
      "status": 2,
    };
    var dioCall = dioTokenClient.post(endpoint, data: data);

    try {
      return callApi(dioCall).then((response) {
        return true;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RentStations> getRentStations() {
    var endpoint = "${DioProvider.baseUrl}/rentStation/list";
    var param = {
      "status": 1,
    };
    var dioCall = dioTokenClient.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall)
          .then((response) => RentStations.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VehicleRental> getVehicleRental(String id) {
    var endpoint = "${DioProvider.baseUrl}/rent-service";
    var data = {
      "id": id,
    };
    var formData = FormData.fromMap(data);
    var dioCall = dioTokenClient.post(endpoint, data: formData);

    try {
      return callApi(dioCall).then((response) {
        return VehicleRental.fromJson(response.data['body']);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> createOrder(Order order) {
    var endpoint = "${DioProvider.baseUrl}/order";
    var data = order.toJson();
    var dioCall = dioTokenClient.post(endpoint, data: data);

    try {
      return callApi(dioCall).then((response) {
        return true;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BusDirection>> getBusDirection(LatLng start, LatLng end) {
    var endpoint = "${DioProvider.baseUrl}/bus-trip";
    var data = {
      "startLongitude": start.longitude,
      "startLatitude": start.latitude,
      "endLongitude": end.longitude,
      "endLatitude": end.latitude,
    };

    var dioCall = dioTokenClient.post(endpoint, data: data);

    try {
      return callApi(dioCall).then(
        (response) {
          List<dynamic> data = response.data['body'];
          List<BusDirection> result = <BusDirection>[];
          for (var item in data) {
            result.add(BusDirection.fromJson(item));
          }
          return result;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BusStations> getBusStation() {
    var endpoint = "${DioProvider.baseUrl}/Station";
    var param = {
      "status": 1,
    };
    var dioCall = dioTokenClient.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then((response) {
        return BusStations.fromJson(response.data['body']['items']);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> busPayment({
    required String customerId,
    required String uid,
    required LatLng location,
  }) {
    var endpoint = "${DioProvider.baseUrl}/bus-trip-pay-mobile";
    var data = {
      "customerId": customerId,
      "uid": uid,
      "latitude": location.latitude,
      "longitude": location.longitude,
    };
    var formData = FormData.fromMap(data);
    var dioCall = dioTokenClient.post(endpoint, data: formData);

    try {
      return callApi(dioCall).then((response) {
        return true;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> sendOtp(String phoneNumber) {
    var endpoint = "${DioProvider.baseUrl}/otp/send-otp";
    var data = {
      "phoneNumber": phoneNumber,
    };
    var formData = FormData.fromMap(data);
    var dioCall = dioClient.post(endpoint, data: formData);

    try {
      return callApi(dioCall).then((response) {
        return response.data['body']['requestId'];
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> verifyOtp(String phoneNumber, String otp, String requestId) {
    var endpoint = "${DioProvider.baseUrl}/otp/verify-otp";
    var data = {
      "phone": phoneNumber,
      "otpCode": otp,
      "requestId": requestId,
    };
    var formData = FormData.fromMap(data);
    var dioCall = dioClient.post(endpoint, data: formData);

    try {
      return callApi(dioCall).then((response) {
        return true;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BusTrip> getBusTrip(String id, String customerId) {
    var endpoint = "${DioProvider.baseUrl}/bus-trip";
    var param = {
      "vehicleId": id,
      "customerId": customerId,
    };
    var dioCall = dioTokenClient.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then(
        (response) {
          return BusTrip.fromJson(response.data['body']);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Activity> getActivity(String customerId) {
    var endpoint = "${DioProvider.baseUrl}/purchase-history/$customerId";
    var dioCall = dioTokenClient.get(endpoint);

    try {
      return callApi(dioCall).then(
        (response) {
          return Activity.fromJson(response.data['body']);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<OrderDetail>> getOrderDetails(String id) {
    var endpoint = "${DioProvider.baseUrl}/purchase-history/order-detail/$id";
    var dioCall = dioTokenClient.get(endpoint);

    try {
      return callApi(dioCall).then(
        (response) {
          var result = <OrderDetail>[];
          response.data['body']['items'].forEach((v) {
            result.add(OrderDetail.fromJson(v));
          });
          return result;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Package>> getPackages(String customerId) {
    var endpoint = "${DioProvider.baseUrl}/package/list";
    var param = {
      "customerId": customerId,
    };

    var dioCall = dioTokenClient.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then(
        (response) {
          var result = <Package>[];
          response.data['body']['items'].forEach((v) {
            result.add(Package.fromJson(v));
          });
          return result;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> buyPackage(String customerId, String packageId) {
    var endpoint = "${DioProvider.baseUrl}/package/package-purchase";

    var data = {
      "customerId": customerId,
      "packageId": packageId,
    };
    var dioCall = dioTokenClient.post(endpoint, data: data);

    try {
      return callApi(dioCall).then(
        (response) {
          return true;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CurrentPackage> getCurrentPackage(String customerId) {
    var endpoint = "${DioProvider.baseUrl}/package/current-package";
    var param = {
      "customerId": customerId,
    };

    var dioCall = dioTokenClient.get(endpoint, queryParameters: param);

    try {
      return callApi(dioCall).then(
        (response) {
          return CurrentPackage.fromJson(response.data['body']);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> registerNotification(String driverId, String code) {
    var endpoint = "${DioProvider.baseUrl}/firebase/fcm/registrationToken";

    var data = {
      "entityId": driverId,
      "registrationToken": code,
    };
    var dioCall = dioClient.post(endpoint, data: data);

    try {
      return callApi(dioCall).then(
        (response) {
          return true;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> createRentCustomerTrip(
      String customerId, String vehicleId, DateTime deadline) {
    var endpoint = "${DioProvider.baseUrl}/rent-service-customer-trip";

    var data = {
      "customerId": customerId,
      "vehicleId": vehicleId,
      "rentDeadline": deadline.toUtc().toIso8601String(),
    };
    var dioCall = dioTokenClient.post(endpoint, data: data);

    try {
      return callApi(dioCall).then(
        (response) {
          return true;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Notification>> getNotifications(String driverId) {
    var endpoint = "${DioProvider.baseUrl}/notification/$driverId";

    var dioCall = dioTokenClient.get(endpoint);

    try {
      return callApi(dioCall).then(
        (response) {
          var result = <Notification>[];
          response.data['body'].forEach((v) {
            result.add(Notification.fromJson(v));
          });
          return result;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> clearNotifications(String driverId) {
    var endpoint = "${DioProvider.baseUrl}/notification/$driverId";

    var dioCall = dioTokenClient.put(endpoint);

    try {
      return callApi(dioCall).then(
        (response) {
          return true;
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
