import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';

class ScanCardController extends BaseController {
  final Repository _repository = Get.find(tag: (Repository).toString());
  String? code = '';
  int state = 2;

  @override
  void onInit() {
    if (Get.arguments != null) {
      code = Get.arguments['code'];
      _cardLink();
    }
    super.onInit();
  }

  _cardLink() async {
    String customerId = TokenManager.instance.user?.customerId ?? '';
    if (customerId == '') return;

    var cardLinkService = _repository.updateCard(customerId, code ?? '');

    await callDataService(
      cardLinkService,
      onSuccess: (bool response) {
        state = response ? 1 : 0;
      },
      onError: (DioError dioError) {
        state = 0;
        Utils.showToast('Kết nối thất bại');
      },
    );
    Future.delayed(
      const Duration(seconds: 1),
    );
    update();
  }
}
