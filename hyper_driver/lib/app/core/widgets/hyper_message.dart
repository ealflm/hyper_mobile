import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyper_driver/app/core/values/app_assets.dart';
import 'package:hyper_driver/app/core/values/app_colors.dart';
import 'package:hyper_driver/app/core/values/font_weights.dart';
import 'package:hyper_driver/app/core/values/text_styles.dart';
import 'package:hyper_driver/app/core/widgets/status_bar.dart';

class HyperMessage extends StatelessWidget {
  const HyperMessage({Key? key, required this.child, this.hasShow = false})
      : super(key: key);

  final Widget child;
  final bool hasShow;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (hasShow) _main() else child,
      ],
    );
  }

  Widget _main() {
    return StatusBar(
      brightness: Brightness.dark,
      child: Scaffold(
        body: Container(
          color: AppColors.white,
          child: Center(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssets.success,
                    width: 117.r,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    'Số điện thoại của bạn đã được xác thực',
                    textAlign: TextAlign.center,
                    style: h5.copyWith(
                      color: AppColors.lightBlack,
                      fontWeight: FontWeights.light,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
