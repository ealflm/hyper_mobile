part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const START = _Paths.START;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const HOME = _Paths.HOME;
  static const MAIN = _Paths.MAIN;
  static const PACKAGE = _Paths.PACKAGE;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const ACTIVITY = _Paths.ACTIVITY;
  static const ACCOUNT = _Paths.ACCOUNT;
  static const SCAN = _Paths.SCAN;
  static const PAYMENT = _Paths.PAYMENT;
  static const PAYPAL = _Paths.PAYPAL;
  static const PAYMENT_STATUS = _Paths.PAYMENT_STATUS;
  static const BUSING = _Paths.BUSING;
  static const MOMO = _Paths.MOMO;
  static const SCAN_CARD = _Paths.SCAN_CARD;
  static const RENTING = _Paths.RENTING;
  static const RENTING_SEARCH = _Paths.RENTING_SEARCH;
  static const RENTING_DESTINATION_ARRIVED = _Paths.RENTING_DESTINATION_ARRIVED;
  static const RENTING_FORM = _Paths.RENTING_FORM;
  static const PLACE_SEARCH = _Paths.PLACE_SEARCH;
  static const SELECT_ON_MAP = _Paths.SELECT_ON_MAP;
  static const BUS_DIRECTION = _Paths.BUS_DIRECTION;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const START = '/start';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const MAIN = '/main';
  static const PACKAGE = '/package';
  static const NOTIFICATION = '/notification';
  static const ACTIVITY = '/activity';
  static const ACCOUNT = '/account';
  static const SCAN = '/scan';
  static const PAYMENT = '/payment';
  static const PAYPAL = '/paypal';
  static const PAYMENT_STATUS = '/payment-status';
  static const BUSING = '/busing';
  static const MOMO = '/momo';
  static const SCAN_CARD = '/scan-card';
  static const RENTING = '/renting';
  static const RENTING_SEARCH = '/renting/search';
  static const RENTING_DESTINATION_ARRIVED = '/renting/destination-arrived';
  static const RENTING_FORM = '/renting-form';
  static const PLACE_SEARCH = '/place-search';
  static const SELECT_ON_MAP = '/select-on-map';
  static const BUS_DIRECTION = '/bus-direction';
}
