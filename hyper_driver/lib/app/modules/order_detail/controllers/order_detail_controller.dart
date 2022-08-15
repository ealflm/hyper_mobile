import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/data/models/activity_model.dart';
import 'package:hyper_driver/app/data/models/order_detail_model.dart';
import 'package:hyper_driver/app/data/repository/repository.dart';

class OrderDetailController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());
  Orders? order;
  Rx<List<OrderDetail>> orderDetails = Rx<List<OrderDetail>>([]);

  @override
  void onInit() {
    if (Get.arguments != null) {
      var data = Get.arguments as Map<String, dynamic>;
      if (data.containsKey('order')) {
        order = data['order'];
      }
    }
    fetchOrderDetails();
    super.onInit();
  }

  Future<void> fetchOrderDetails() async {
    var activityService = _repository.getOrderDetails(order?.id ?? '');

    List<OrderDetail> result = [];

    await callDataService(
      activityService,
      onSuccess: (List<OrderDetail> response) {
        result = response;
      },
      onError: (DioError dioError) {},
    );

    orderDetails(result);
  }
}
