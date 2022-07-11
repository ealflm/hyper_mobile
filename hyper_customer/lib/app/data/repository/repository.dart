import 'package:hyper_customer/app/data/models/auth_model.dart';

abstract class Repository {
  Future<String> verify(String phoneNumber);
  Future<Auth> login(String phoneNumber, String password);
}
