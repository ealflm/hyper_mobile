import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/network_controller.dart';

import '/app/core/model/page_state.dart';

abstract class BaseController extends GetxController {
  get networkStatus => NetworkController.intance.connectionStatus;

  //Reload the page
  final _refreshController = false.obs;

  refreshPage(bool refresh) => _refreshController(refresh);

  //Controls page state
  final _pageSateController = PageState.DEFAULT.obs;

  PageState get pageState => _pageSateController.value;
  bool get isLoading => pageState == PageState.LOADING;

  updatePageState(PageState state) => _pageSateController(state);

  resetPageState() => _pageSateController(PageState.DEFAULT);

  showLoading() => updatePageState(PageState.LOADING);

  hideLoading() => resetPageState();

  //Message Controller
  final _messageController = ''.obs;
  String get message => _messageController.value;
  showMessage(String msg) {
    _messageController(msg);
  }

  //Error Controller
  final _errorMessageController = ''.obs;
  String get errorMessage => _errorMessageController.value;
  showErrorMessage(String msg) {
    _errorMessageController(msg);
  }

  Future<dynamic> callDataService<T>(
    Future<T> future, {
    Function(DioError dioError)? onError,
    Function(T response)? onSuccess,
    Function? onStart,
    Function? onComplete,
  }) async {
    DioError? dioError;

    onStart == null ? showLoading() : onStart();

    try {
      final T response = await future;

      if (onSuccess != null) onSuccess(response);

      onComplete == null ? hideLoading() : onComplete();

      return response;
    } on DioError catch (error) {
      dioError = error;
    } catch (error) {
      rethrow;
    }

    if (onError != null) onError(dioError);

    onComplete == null ? hideLoading() : onComplete();
  }

  @override
  void onClose() {
    _errorMessageController.close();
    _messageController.close();
    _refreshController.close();
    _pageSateController.close();
    super.onClose();
  }
}
