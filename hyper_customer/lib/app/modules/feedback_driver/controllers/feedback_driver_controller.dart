import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class FeedbackDriverController extends BaseController {
  String? customerTripId;
  String? driverId;
  Rx<String?> photoUrl = ''.obs;
  Rx<String?> gender = ''.obs;
  bool backToHome = false;

  @override
  Future<void> onInit() async {
    var data = Get.arguments as Map<String, dynamic>;

    if (data.containsKey('customerTripId')) {
      customerTripId = data['customerTripId'];
    }
    if (data.containsKey('driverId')) {
      driverId = data['driverId'];
    }
    if (data.containsKey('photoUrl')) {
      photoUrl.value = data['photoUrl'];
    }
    if (data.containsKey('gender')) {
      gender.value = data['gender'];
    }
    if (data.containsKey('backToHome')) {
      backToHome = data['backToHome'];
    }

    super.onInit();
  }

  Rx<int> feedBackPoint = 0.obs;

  void changePoint(int point) {
    feedBackPoint.value = point;
  }

  Rx<String> feedBackEmotion = ''.obs;
  Rx<String> feedBackMessage = ''.obs;

  void changeFeedBackEmotion(String value) {
    feedBackEmotion.value = value;
  }

  void changeFeedBackMessage(String value) {
    feedBackMessage.value = value;
  }

  final Repository _repository = Get.find(tag: (Repository).toString());

  void submit() async {
    String content = '';
    if (feedBackEmotion.value.isNotEmpty && feedBackMessage.value.isNotEmpty) {
      content = '${feedBackEmotion.value}, ${feedBackMessage.value}';
    } else {
      content = '${feedBackEmotion.value}${feedBackMessage.value}';
    }

    var feedbackDriverService = _repository.feedbackDriver(
      customerTripId ?? '',
      feedBackPoint.value,
      content,
    );

    await callDataService(
      feedbackDriverService,
      onSuccess: (bool response) {
        Utils.showToast('Gửi đánh giá thành công');
        if (backToHome) {
          Get.offAllNamed(Routes.MAIN);
        } else {
          Get.back();
        }
      },
      onError: (DioError dioError) {
        Utils.showToast('Không thể kết nối');
      },
    );
  }
}
