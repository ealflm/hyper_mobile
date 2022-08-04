import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/activity/bindings/activity_binding.dart';
import '../modules/activity/views/activity_view.dart';
import '../modules/bus_direction/bindings/bus_direction_binding.dart';
import '../modules/bus_direction/views/bus_direction_view.dart';
import '../modules/bus_payment/bindings/bus_payment_binding.dart';
import '../modules/bus_payment/views/bus_payment_view.dart';
import '../modules/busing/bindings/busing_binding.dart';
import '../modules/busing/views/busing_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/momo/bindings/momo_binding.dart';
import '../modules/momo/views/momo_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/package/bindings/package_binding.dart';
import '../modules/package/views/package_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/payment_status/bindings/payment_status_binding.dart';
import '../modules/payment_status/views/payment_status_view.dart';
import '../modules/paypal/bindings/paypal_binding.dart';
import '../modules/paypal/views/paypal_view.dart';
import '../modules/place_search/bindings/place_search_binding.dart';
import '../modules/place_search/views/place_search_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register_otp/bindings/register_otp_binding.dart';
import '../modules/register_otp/views/register_otp_view.dart';
import '../modules/renting/bindings/renting_binding.dart';
import '../modules/renting/views/destination_arrived_view.dart';
import '../modules/renting/views/renting_search_view.dart';
import '../modules/renting/views/renting_view.dart';
import '../modules/renting_form/bindings/renting_form_binding.dart';
import '../modules/renting_form/views/renting_form_view.dart';
import '../modules/scan/bindings/scan_binding.dart';
import '../modules/scan/views/scan_view.dart';
import '../modules/scan_card/bindings/scan_card_binding.dart';
import '../modules/scan_card/views/scan_card_view.dart';
import '../modules/select_on_map/bindings/select_on_map_binding.dart';
import '../modules/select_on_map/views/select_on_map_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/start/bindings/start_binding.dart';
import '../modules/start/views/start_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.START,
      page: () => const StartView(),
      binding: StartBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.PACKAGE,
      page: () => const PackageView(),
      binding: PackageBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.ACTIVITY,
      page: () => const ActivityView(),
      binding: ActivityBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.SCAN,
      page: () => const ScanView(),
      binding: ScanBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.PAYPAL,
      page: () => const PaypalView(),
      binding: PaypalBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.PAYMENT_STATUS,
      page: () => const PaymentStatusView(),
      binding: PaymentStatusBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.BUSING,
      page: () => const BusingView(),
      binding: BusingBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.MOMO,
      page: () => const MomoView(),
      binding: MomoBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.SCAN_CARD,
      page: () => const ScanCardView(),
      binding: ScanCardBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.RENTING,
      page: () => const RentingView(),
      binding: RentingBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.RENTING_SEARCH,
      page: () => const RentingSearchView(),
      binding: RentingBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.RENTING_DESTINATION_ARRIVED,
      page: () => const DestinationArrivedView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.RENTING_FORM,
      page: () => const RentingFormView(),
      binding: RentingFormBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.PLACE_SEARCH,
      page: () => const PlaceSearchView(),
      binding: PlaceSearchBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.SELECT_ON_MAP,
      page: () => const SelectOnMapView(),
      binding: SelectOnMapBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.BUS_DIRECTION,
      page: () => const BusDirectionView(),
      binding: BusDirectionBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.BUS_PAYMENT,
      page: () => const BusPaymentView(),
      binding: BusPaymentBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.REGISTER_OTP,
      page: () => const RegisterOtpView(),
      binding: RegisterOtpBinding(),
      transition: Transition.noTransition,
    ),
  ];
}
