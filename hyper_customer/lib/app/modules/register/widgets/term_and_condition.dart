import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/values/button_styles.dart';
import 'package:hyper_customer/app/core/values/font_weights.dart';
import 'package:hyper_customer/app/core/values/text_styles.dart';
import 'package:hyper_customer/app/core/widgets/light_bulb.dart';
import 'package:hyper_customer/app/modules/register/controllers/register_controller.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class TermAndCondition extends GetView<RegisterController> {
  const TermAndCondition({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _body(),
        _bottom(),
      ],
    );
  }

  Widget _bottom() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 20.h,
      ),
      width: double.infinity,
      child: Column(
        children: [
          const LightBulb(
            message:
                'Bạn cần đồng ý với điều khoản dịch vụ bên trên để tiếp tục',
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              Expanded(
                flex: 120,
                child: TextButton(
                  style: ButtonStyles.secondary(),
                  onPressed: () {
                    Get.offAllNamed(Routes.START);
                  },
                  child: Text(
                    'Huỷ',
                    style: buttonBold,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                flex: 170,
                child: ElevatedButton(
                  style: ButtonStyles.primary(),
                  onPressed: () {
                    controller.changeStep(1);
                  },
                  child: Text(
                    'Tôi đồng ý',
                    style: buttonBold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quyền riêng tư và điều khoản',
              style: h5.copyWith(
                color: AppColors.softBlack,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            RichText(
              text: TextSpan(
                style: body2.copyWith(
                  color: AppColors.lightBlack,
                ),
                children: const [
                  TextSpan(
                    text: 'Để tạo tài khoản Temper, bạn cần phải đồng ý với ',
                  ),
                  TextSpan(
                    text: 'Điều khoản dịch vụ ',
                    style: TextStyle(
                      color: AppColors.primary400,
                      fontWeight: FontWeights.medium,
                    ),
                  ),
                  TextSpan(
                    text: 'của chúng tôi.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            RichText(
              text: TextSpan(
                style: body2.copyWith(
                  color: AppColors.lightBlack,
                ),
                children: const [
                  TextSpan(
                    text:
                        'Bên cạnh đó, khi bạn tạo tài khoản, chúng tôi sẽ xử lý thông tin của bạn theo cách đã mô tả trong ',
                  ),
                  TextSpan(
                    text: 'Chính sách quyền riêng tư ',
                    style: TextStyle(
                      color: AppColors.primary400,
                      fontWeight: FontWeights.medium,
                    ),
                  ),
                  TextSpan(
                    text: 'của chúng tôi, bao gồm các điểm chính sau:',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Dữ liệu chúng tôi xử lý khi bạn sử dụng Hyper',
              style: subtitle2.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  '•  ',
                  style: body2.copyWith(
                    color: AppColors.lightBlack,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Khi bạn thiết lập một tài khoản Hyper, chúng tôi lưu trữ thông tin bạn cung cấp cho chúng tôi như tên, địa chỉ, CCCD và số điện thoại của bạn.',
                    style: body2.copyWith(
                      color: AppColors.lightBlack,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  '•  ',
                  style: body2.copyWith(
                    color: AppColors.lightBlack,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Khi bạn sử dụng các dịch vụ của Hyper chúng tôi sẽ xử lý thông tin về hoạt động đó bao gồm các thông tin như địa điểm bạn tìm kiếm, ID thiết bị, địa chỉ IP, dữ liệu cookie và vị trí.',
                    style: body2.copyWith(
                      color: AppColors.lightBlack,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Tại sao chúng tôi xử lý dữ liệu',
              style: subtitle2.copyWith(
                color: AppColors.lightBlack,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  '•  ',
                  style: body2.copyWith(
                    color: AppColors.lightBlack,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Tăng cường bảo mật, bảo vệ quyền lợi khách hàng, chống gian lận và lạm dụng.',
                    style: body2.copyWith(
                      color: AppColors.lightBlack,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  '•  ',
                  style: body2.copyWith(
                    color: AppColors.lightBlack,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Cải thiện chất lượng dịch vụ và phát triển dịch vụ mới.',
                    style: body2.copyWith(
                      color: AppColors.lightBlack,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
