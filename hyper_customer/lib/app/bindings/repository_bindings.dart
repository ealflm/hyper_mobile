import 'package:get/get.dart';
import 'package:hyper_customer/app/data/repository/goong_repository.dart';
import 'package:hyper_customer/app/data/repository/goong_repository_impl.dart';
import 'package:hyper_customer/app/data/repository/mapbox_repository.dart';
import 'package:hyper_customer/app/data/repository/mapbox_repository_impl.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/data/repository/repository_impl.dart';

class RepositoryBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Repository>(
      () => RepositoryImpl(),
      tag: (Repository).toString(),
      fenix: true,
    );
    Get.lazyPut<MapboxRepository>(
      () => MapboxRepositoryImpl(),
      tag: (MapboxRepository).toString(),
      fenix: true,
    );
    Get.lazyPut<GoongRepository>(
      () => GoongRepositoryImpl(),
      tag: (GoongRepository).toString(),
      fenix: true,
    );
  }
}
