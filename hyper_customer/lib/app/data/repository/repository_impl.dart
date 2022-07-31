import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hyper_customer/app/core/base/base_repository.dart';
import 'package:hyper_customer/app/data/models/auth_model.dart';
import 'package:hyper_customer/app/data/models/bus_direction_model.dart';
import 'package:hyper_customer/app/data/models/order_model.dart';
import 'package:hyper_customer/app/data/models/rent_stations_model.dart';
import 'package:hyper_customer/app/data/models/vehicle_rental_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_provider.dart';
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
}
