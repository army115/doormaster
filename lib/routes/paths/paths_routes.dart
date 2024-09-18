// ignore_for_file: constant_identifier_names

abstract class Routes {
  Routes._();
  static const auth = _Paths.auth;
  static const login_user = _Paths.login_user;
  static const login_staff = _Paths.login_staff;
  static const check = _Paths.check;
  static const bottom = _Paths.bottom;
  static const home = _Paths.home;
  static const profile = _Paths.profile;
  static const setting = _Paths.setting;
  static const notification = _Paths.notification;
  static const password = _Paths.password;
  static const qrsmart = _Paths.qrsmart;
  static const parcel = _Paths.parcel;
  static const management = _Paths.management;
  static const security = _Paths.security;
  static const visitor = _Paths.visitor;
}

abstract class _Paths {
  _Paths._();
  static const auth = '/auth';
  static const login_user = '/login';
  static const login_staff = '/staff';
  static const check = '/check';
  static const bottom = '/bottom';
  static const profile = '/profile';
  static const home = '/home';
  static const setting = '/setting';
  static const password = '/password';
  static const notification = '/notification';
  static const qrsmart = '/qrsmart';
  static const parcel = '/parcel';
  static const management = '/management';
  static const security = '/security';
  static const visitor = '/visitor';
}
