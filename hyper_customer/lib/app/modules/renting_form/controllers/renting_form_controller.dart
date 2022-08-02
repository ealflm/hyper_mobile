import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/base/base_controller.dart';
import 'package:hyper_customer/app/core/values/app_values.dart';
import 'package:hyper_customer/app/data/models/order_model.dart';
import 'package:hyper_customer/app/data/models/vehicle_rental_model.dart';
import 'package:hyper_customer/app/data/repository/repository.dart';
import 'package:hyper_customer/app/modules/renting_form/models/view_state.dart';
import 'package:hyper_customer/app/modules/renting_form/widgets/renting_by_day.dart';
import 'package:hyper_customer/app/modules/renting_form/widgets/renting_by_hour.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';

class RentingFormController extends BaseController
    with GetSingleTickerProviderStateMixin {
  final Repository _repository = Get.find(tag: (Repository).toString());
  String? code = '';
  var state = ViewState.loading.obs;

  VehicleRental? vehicleRental;

  int dayNum = 0;
  int hourNum = 0;

  @override
  void onInit() {
    if (Get.arguments != null) {
      code = Get.arguments['code'];
      _fetchVehicleRental();
    }
    modeController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  // Region Get vehicle rental

  _fetchVehicleRental() async {
    var cardLinkService = _repository.getVehicleRental(code ?? '');

    await callDataService(
      cardLinkService,
      onSuccess: (VehicleRental response) {
        vehicleRental = response;
        state.value = ViewState.successful;
      },
      onError: (DioError dioError) {
        state.value = ViewState.failed;
      },
    );
  }

  // End Region

  // Region Create order

  createOrder() async {
    state.value = ViewState.loading;

    String customerId = TokenManager.instance.user?.customerId ?? '';
    if (customerId == '') return;

    List<OrderDetailsInfos> orderDetailsInfos;

    if (modeController.index == 0) {
      orderDetailsInfos = [
        OrderDetailsInfos(
          priceOfRentingServiceId: vehicleRental?.priceOfRentingServiceId ?? '',
          content: 'Thuê xe theo ngày',
          quantity: dayNum,
          price: vehicleRental?.pricePerDay ?? 0,
        ),
        OrderDetailsInfos(
          priceOfRentingServiceId: vehicleRental?.priceOfRentingServiceId ?? '',
          content: 'Phí thu hồi xe',
          quantity: 1,
          price: AppValues.recallFee.toInt(),
        ),
      ];
    } else {
      orderDetailsInfos = [
        OrderDetailsInfos(
          priceOfRentingServiceId: vehicleRental?.priceOfRentingServiceId ?? '',
          content: 'Thuê xe theo giờ',
          quantity: hourNum,
          price: vehicleRental?.pricePerHour ?? 0,
        ),
        OrderDetailsInfos(
          priceOfRentingServiceId: vehicleRental?.priceOfRentingServiceId ?? '',
          content: 'Phí thu hồi xe',
          quantity: 1,
          price: AppValues.recallFee.toInt(),
        ),
      ];
    }

    Order order = Order(
      customerId: customerId,
      serviceTypeId: vehicleRental?.serviceTypeId,
      discountId: null,
      partnerId: vehicleRental?.partnerId,
      orderDetailsInfos: orderDetailsInfos,
      totalPrice: getTotalPrice().toInt(),
    );
    var orderService = _repository.createOrder(order);

    await callDataService(
      orderService,
      onSuccess: (bool response) {
        state.value = ViewState.paymentSuccessful;
      },
      onError: (DioError dioError) {
        state.value = ViewState.paymentFailed;
      },
    );
  }

  // End region

  // Region Progress tab
  var tabIndex = 0.obs;

  void changeTab(int index) {
    tabIndex.value = index;
  }

  int getTab() {
    if (!(state.value == ViewState.successful)) {
      return -1;
    }
    return tabIndex.value;
  }

  // End Region

  // Region Tab 2

  late TabController modeController;
  var modeIndex = 0.obs;
  final modes = [
    const Tab(text: 'Theo ngày'),
    const Tab(text: 'Theo giờ'),
  ];

  void changeMode(int index) {
    modeIndex.value = index;
  }

  List<Widget> modesWidget = [
    const RentingByDay(),
    const RentingByHour(),
  ];

  // End Region

  // Region Get value
  void setDayNum(int value) {
    dayNum = value;
  }

  void setHourNum(int value) {
    hourNum = value;
  }

  double getTotalPrice() {
    if (modeIndex.value == 0) {
      double price = vehicleRental?.pricePerDay?.toDouble() ?? 0;
      double result = dayNum * price + AppValues.recallFee;
      return result;
    } else {
      double price = vehicleRental?.pricePerHour?.toDouble() ?? 0;
      double result = hourNum * price + AppValues.recallFee;
      return result;
    }
  }

  // End Region
}
