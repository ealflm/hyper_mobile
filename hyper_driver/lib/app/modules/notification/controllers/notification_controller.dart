import 'package:get/get.dart';
import 'package:hyper_driver/app/core/base/base_controller.dart';
import 'package:hyper_driver/app/core/utils/date_time_utils.dart';
import 'package:hyper_driver/app/core/utils/utils.dart';
import 'package:hyper_driver/app/data/models/notification_model.dart';
import 'package:hyper_driver/app/data/repository/repository.dart';
import 'package:hyper_driver/app/network/dio_token_manager.dart';

class NotificationController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());

  Rx<List<Notification>> notifications = Rx<List<Notification>>([]);

  @override
  void onInit() {
    init();

    super.onInit();
  }

  void init() {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    String driverId = TokenManager.instance.user?.driverId ?? '';

    var notificationService = _repository.getNotifications(driverId);

    List<Notification> result = [];

    await callDataService(
      notificationService,
      onSuccess: (List<Notification> response) {
        result = response;
      },
      onError: ((dioError) {}),
    );

    bool flag = false;
    for (Notification item in result) {
      if (DateTimeUtils.compare(item.createdDate, DateTime.now()) &&
          flag == false) {
        item.filter = 0;
        flag = true;
      } else if (!DateTimeUtils.compare(item.createdDate, DateTime.now()) &&
          flag == true) {
        item.filter = 1;
        break;
      }
    }

    notifications(result);
  }

  Future<void> clearNotifications() async {
    String driverId = TokenManager.instance.user?.driverId ?? '';

    var notificationService = _repository.clearNotifications(driverId);

    await callDataService(
      notificationService,
      onSuccess: (bool response) {
        Utils.showToast('Đã xoá thông báo');
      },
      onError: ((dioError) {
        Utils.showToast('Không thể kết nối');
      }),
    );

    fetchNotifications();
  }
}
