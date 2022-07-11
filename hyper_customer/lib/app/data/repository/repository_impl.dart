import 'package:hyper_customer/app/core/base/base_repository.dart';
import 'package:hyper_customer/app/data/models/auth_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_provider.dart';

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
}
