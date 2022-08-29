import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/core/controllers/signalr_controller.dart';
import 'package:hyper_customer/app/core/utils/number_utils.dart';
import 'package:hyper_customer/app/core/utils/utils.dart';
import 'package:hyper_customer/app/core/values/app_animation_assets.dart';
import 'package:hyper_customer/app/core/values/app_assets.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/box_decorations.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/hyper_button.dart';
import 'package:hyper_customer/app/core/widgets/hyper_dialog.dart';
import 'package:hyper_customer/app/core/widgets/hyper_shape.dart';
import 'package:hyper_customer/app/modules/booking_direction/controllers/booking_direction_controller.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/booking_state.dart';
import 'package:hyper_customer/app/modules/booking_direction/models/vehicle.dart';
import 'package:hyper_customer/app/modules/booking_direction/widgets/service_item.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Bottom extends GetWidget<BookingDirectionController> {
  const Bottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () {
              switch (controller.bookingState.value) {
                case BookingState.select:
                  return _select();
                case BookingState.finding:
                  return _findDriver();
                case BookingState.failed:
                  return _failed();
                case BookingState.coming:
                  return _coming();
                case BookingState.arrived:
                  return _arrived();
                case BookingState.pickedUp:
                  return _pickedUp();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _failed() {
    return Column(
      children: [
        _goToCurrentLocation(),
        Container(
          padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
          child: Container(
            decoration: BoxDecorations.map(),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            width: double.infinity,
            child: Column(
              children: [
                Lottie.asset(AppAnimationAssets.cantMatching, width: 150.w),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Rất tiếc, các tài xế gần đây đang bận',
                  style: subtitle1.copyWith(
                    color: AppColors.softBlack,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
          child: Container(
            decoration: BoxDecorations.map(),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dịch vụ',
                  style: subtitle1.copyWith(
                    color: AppColors.softBlack,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                _servicePrice(),
                SizedBox(
                  height: 14.h,
                ),
                _bookingButton('Tiếp tục tìm xe'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _select() {
    return Column(
      children: [
        _goToCurrentLocation(),
        Container(
          padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
          child: Container(
            decoration: BoxDecorations.map(),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dịch vụ',
                  style: subtitle1.copyWith(
                    color: AppColors.softBlack,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                _servicePrice(),
                SizedBox(
                  height: 14.h,
                ),
                _bookingButton('Đặt xe'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Obx _bookingButton(String title) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyles.primaryMedium(),
          onPressed: controller.isLoadingPrice.value ||
                  SignalR.instance.hubState.value != HubState.connected
              ? null
              : controller.lookingForDriver,
          child: HyperButton.child(
            loadingText: title,
            status: controller.isLoadingPrice.value ||
                SignalR.instance.hubState.value != HubState.connected,
            child: Text(
              title,
              style: buttonBold,
            ),
          ),
        ),
      ),
    );
  }

  Obx _servicePrice() {
    return Obx(
      () => !controller.isLoadingPrice.value
          ? Column(
              children: [
                Obx(
                  () => ServiceItem(
                    svgAsset: AppAssets.motorcycle,
                    title: 'Xe máy',
                    description: 'Tối đa 1 hành khách',
                    isSelected: controller.vehicle.value == Vehicle.motorcycle,
                    price: controller.motocyclePrice.value?.totalPrice ?? 0.0,
                    onPressed: () {
                      controller.changeVehicle(Vehicle.motorcycle);
                    },
                    priceAfterDiscount:
                        controller.motocyclePrice.value?.priceAfterDiscount ??
                            0,
                  ),
                ),
                Obx(
                  () => ServiceItem(
                    svgAsset: AppAssets.car,
                    title: 'Xe ô tô',
                    description: 'Tối đa 4 hành khách',
                    isSelected: controller.vehicle.value == Vehicle.car,
                    price: controller.carPrice.value?.totalPrice ?? 0.0,
                    onPressed: () {
                      // controller.changeVehicle(Vehicle.car);
                      HyperDialog.show(
                        title: 'Chưa phát triển',
                        content: 'Tính năng chưa được phát triển',
                        primaryButtonText: 'OK',
                      );
                    },
                    priceAfterDiscount:
                        controller.carPrice.value?.priceAfterDiscount ?? 0,
                  ),
                ),
              ],
            )
          : SizedBox(
              height: 40.h,
              child: Center(
                child: Lottie.asset(
                  AppAnimationAssets.dot,
                ),
              ),
            ),
    );
  }

  Widget _findDriver() {
    return SlidingUpPanel(
      color: Colors.transparent,
      boxShadow: const [],
      maxHeight: 480.h,
      minHeight: 215.h,
      panelBuilder: (sc) {
        return SingleChildScrollView(
          controller: sc,
          child: Column(
            children: [
              _goToCurrentLocation(),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Container(
                  decoration: BoxDecorations.map(),
                  padding: EdgeInsets.only(
                    bottom: 20.h,
                    left: 18.w,
                    right: 18.w,
                    top: 10.h,
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.otp,
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                        width: 35.w,
                        height: 4,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Lottie.asset(AppAnimationAssets.lookingDriver,
                          width: 100.w),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Đang tìm tài xế...',
                        style: subtitle1.copyWith(
                          color: AppColors.softBlack,
                          fontSize: 18.sp,
                          fontWeight: FontWeights.medium,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Container(
                  decoration: BoxDecorations.map(),
                  padding: EdgeInsets.only(
                    bottom: 10.h,
                    left: 18.w,
                    right: 18.w,
                    top: 20.h,
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _fromToAddress(),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () {
                          HyperDialog.show(
                            title: 'Xác nhận',
                            content: 'Bạn có chắc chắn muốn huỷ chuyến xe?',
                            primaryButtonText: 'Đồng ý',
                            primaryOnPressed: () async {
                              await SignalR.instance.canceledFinding();
                              controller.changeState(BookingState.select);
                              Get.back();
                            },
                            secondaryButtonText: 'Huỷ',
                            secondaryOnPressed: () {
                              Get.back();
                            },
                          );
                        },
                        child: Text(
                          'Huỷ chuyến xe',
                          style: subtitle2.copyWith(
                            color: AppColors.softRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Expanded _fromToAddress() {
    return Expanded(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _start(
              title: '${controller.startPlace.value?.name}',
              content: '${controller.startPlace.value?.formattedAddress}',
            ),
            _space(),
            _end(
              title: '${controller.endPlace.value?.name}',
              content: '${controller.endPlace.value?.formattedAddress}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _coming() {
    return SlidingUpPanel(
      color: Colors.transparent,
      boxShadow: const [],
      maxHeight: 530.h,
      minHeight: 270.h,
      panelBuilder: (sc) {
        return SingleChildScrollView(
          controller: sc,
          child: Column(
            children: [
              _goToCurrentLocation(),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Container(
                  decoration: BoxDecorations.mapHigh(),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.r),
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.line,
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                            left: 18.w,
                            right: 18.w,
                            top: 10.h,
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(9.r),
                                ),
                                width: 35.w,
                                height: 4,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tài xế đang đến',
                                          style: subtitle1.copyWith(
                                            color: AppColors.softBlack,
                                            fontWeight: FontWeights.medium,
                                          ),
                                        ),
                                        Obx(
                                          () => Text(
                                            '${controller.startPlace.value?.formattedAddress}',
                                            style: body2.copyWith(
                                              color: AppColors.softBlack,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '100 phút',
                                    style: subtitle1.copyWith(
                                      color: AppColors.softBlack,
                                      fontWeight: FontWeights.medium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                            left: 18.w,
                            right: 18.w,
                            top: 10.h,
                          ),
                          child: Column(
                            children: [
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                _avatarCircle(),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                _feedbackPoint(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Obx(
                                          () {
                                            return Text(
                                              '${controller.driverResponse.value?.driver?.lastName} ${controller.driverResponse.value?.driver?.firstName}',
                                              style: subtitle1.copyWith(
                                                color: AppColors.softBlack,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  _vehicleInfo(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.CHAT);
                            },
                            child: Ink(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  top: 12.h,
                                  bottom: 12.h,
                                  left: 18.w,
                                  right: 18.w,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Chat với tài xế',
                                      style: body2.copyWith(
                                        color: AppColors.softBlack,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Icon(
                                      Icons.sms_outlined,
                                      color: AppColors.softBlack,
                                      size: 22.w,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Container(
                  decoration: BoxDecorations.mapHigh(),
                  padding: EdgeInsets.only(
                    bottom: 10.h,
                    left: 18.w,
                    right: 18.w,
                    top: 20.h,
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _fromToAddress(),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () {
                          HyperDialog.show(
                            title: 'Xác nhận',
                            content:
                                'Bạn có chắc chắn muốn huỷ chuyến xe? Bạn có thể bị trừ chi phí nếu tài xế đã đi được 60% quảng đường',
                            primaryButtonText: 'Đồng ý',
                            primaryOnPressed: () async {
                              await SignalR.instance.cancelBooking();
                              controller.changeState(BookingState.select);

                              Get.back();
                            },
                            secondaryButtonText: 'Huỷ',
                            secondaryOnPressed: () {
                              Get.back();
                            },
                          );
                        },
                        child: Text(
                          'Huỷ chuyến xe',
                          style: subtitle2.copyWith(
                            color: AppColors.softRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Obx _avatarCircle() {
    return Obx(
      () => _oval(
        controller.driverResponse.value?.driver?.photoUrl ?? '',
        controller.driverResponse.value?.driver?.gender != 'True',
      ),
    );
  }

  Obx _feedbackPoint() {
    return Obx(
      () => controller.driverResponse.value?.driver?.feedbackPoint != 0
          ? Row(
              children: [
                Obx(
                  () => Text(
                    NumberUtils.feedbackPoint(
                      controller.driverResponse.value?.driver?.feedbackPoint,
                    ),
                    style: subtitle1.copyWith(
                      color: AppColors.softBlack,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                const Icon(
                  Icons.star,
                  color: AppColors.yellow,
                ),
              ],
            )
          : Text(
              'Chưa có đánh giá',
              style: body2.copyWith(
                color: AppColors.softBlack,
              ),
            ),
    );
  }

  Column _vehicleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${controller.driverResponse.value?.driver?.vehicleName}',
          style: subtitle1.copyWith(
            color: AppColors.softBlack,
            fontWeight: FontWeights.medium,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          '${controller.driverResponse.value?.driver?.licensePlates}',
          style: subtitle1.copyWith(
            color: AppColors.softBlack,
          ),
        ),
      ],
    );
  }

  Widget _arrived() {
    return SlidingUpPanel(
      color: Colors.transparent,
      boxShadow: const [],
      maxHeight: 530.h,
      minHeight: 270.h,
      panelBuilder: (sc) {
        return SingleChildScrollView(
          controller: sc,
          child: Column(
            children: [
              _goToCurrentLocation(),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Container(
                  decoration: BoxDecorations.mapHigh(),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.r),
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.line,
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                            left: 18.w,
                            right: 18.w,
                            top: 10.h,
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(9.r),
                                ),
                                width: 35.w,
                                height: 4,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tài xế của bạn đã đến điểm đón',
                                          style: subtitle1.copyWith(
                                            color: AppColors.softBlack,
                                            fontWeight: FontWeights.medium,
                                          ),
                                        ),
                                        Obx(
                                          () => Text(
                                            '${controller.startPlace.value?.formattedAddress}',
                                            style: body2.copyWith(
                                              color: AppColors.softBlack,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Text(
                                  //   '100 phút',
                                  //   style: subtitle1.copyWith(
                                  //     color: AppColors.softBlack,
                                  //     fontWeight: FontWeights.medium,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                            left: 18.w,
                            right: 18.w,
                            top: 10.h,
                          ),
                          child: Column(
                            children: [
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                _avatarCircle(),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                _feedbackPoint(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Obx(
                                          () {
                                            return Text(
                                              '${controller.driverResponse.value?.driver?.lastName} ${controller.driverResponse.value?.driver?.firstName}',
                                              style: subtitle1.copyWith(
                                                color: AppColors.softBlack,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  _vehicleInfo(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.CHAT);
                            },
                            child: Ink(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  top: 12.h,
                                  bottom: 12.h,
                                  left: 18.w,
                                  right: 18.w,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Chat với tài xế',
                                      style: body2.copyWith(
                                        color: AppColors.softBlack,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Icon(
                                      Icons.sms_outlined,
                                      color: AppColors.softBlack,
                                      size: 22.w,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Container(
                  decoration: BoxDecorations.mapHigh(),
                  padding: EdgeInsets.only(
                    bottom: 10.h,
                    left: 18.w,
                    right: 18.w,
                    top: 20.h,
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _fromToAddress(),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () {
                          HyperDialog.show(
                            title: 'Xác nhận',
                            content:
                                'Bạn có chắc chắn muốn huỷ chuyến xe? Bạn sẽ bị trừ 30% số tiền đặt xe. ',
                            primaryButtonText: 'Đồng ý',
                            primaryOnPressed: () async {
                              await SignalR.instance.cancelBooking();
                              controller.changeState(BookingState.select);
                              Get.back();
                            },
                            secondaryButtonText: 'Huỷ',
                            secondaryOnPressed: () {
                              Get.back();
                            },
                          );
                        },
                        child: Text(
                          'Huỷ chuyến xe',
                          style: subtitle2.copyWith(
                            color: AppColors.softRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pickedUp() {
    return Column(
      children: [
        _goToCurrentLocation(),
        Container(
          padding: EdgeInsets.only(
            bottom: 10.h,
            left: 10.w,
            right: 10.w,
          ),
          child: Container(
            decoration: BoxDecorations.mapHigh(),
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9.r),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 10.h,
                      left: 18.w,
                      right: 18.w,
                      top: 10.h,
                    ),
                    color: AppColors.primary600,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đang đi đến điểm đến',
                                    style: body2.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Obx(
                                    () => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${controller.endPlace.value?.name}',
                                          style: subtitle1.copyWith(
                                            fontSize: 18.sp,
                                            color: AppColors.white,
                                            fontWeight: FontWeights.medium,
                                          ),
                                        ),
                                        Text(
                                          '${controller.endPlace.value?.formattedAddress}',
                                          style: body1.copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ClipOval _oval(String url, bool gender) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(18.r), // Image radius
        child: CachedNetworkImage(
          fadeInDuration: const Duration(),
          fadeOutDuration: const Duration(),
          placeholder: (context, url) {
            return gender
                ? SvgPicture.asset(AppAssets.female)
                : SvgPicture.asset(AppAssets.male);
          },
          imageUrl: url,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            return gender
                ? SvgPicture.asset(AppAssets.female)
                : SvgPicture.asset(AppAssets.male);
          },
        ),
      ),
    );
  }

  Container _goToCurrentLocation() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h, right: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              controller.mapController.moveToCurrentLocation();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: AppColors.white,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.all(0),
              minimumSize: Size(40.r, 40.r),
            ),
            child: SizedBox(
              height: 40.r,
              width: 40.r,
              child: Icon(
                Icons.gps_fixed,
                size: 18.r,
                color: AppColors.gray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _start({
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HyperShape.startCircle(),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: subtitle1.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.softBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                content,
                style: body2.copyWith(
                  color: AppColors.lightBlack,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _space() {
    return Container(
      padding: EdgeInsets.only(left: 18.r + 10.w),
      height: 40.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HyperShape.dot(),
          HyperShape.dot(),
          HyperShape.dot(),
        ],
      ),
    );
  }

  Widget _end({
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HyperShape.endCircle(),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: subtitle1.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.softBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                content,
                style: body2.copyWith(
                  color: AppColors.lightBlack,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
