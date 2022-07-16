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
}
