// ignore_for_file: constant_identifier_names
import 'package:doormster/check_connected_page.dart';
import 'package:doormster/screen/main_screen/profile_page.dart';
import 'package:doormster/screen/qr_smart_access/list_visitor_page.dart';
import 'package:doormster/screen/test_chat/chat_screen.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/screen/main_screen/auth_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/change_password_page.dart';
import 'package:doormster/screen/main_screen/settings_page.dart';
import 'package:get/get.dart';

class PagesRoutes {
  PagesRoutes._();

  static final routes = [
    GetPage(
      name: Routes.auth,
      page: () => Auth_Page(),
    ),
    GetPage(
      name: Routes.check,
      page: () => const Check_Connected(),
    ),
    GetPage(
      name: Routes.login_user,
      page: () => Login_Page(),
    ),
    GetPage(
      name: Routes.bottom,
      page: () => BottomBar(),
    ),
    GetPage(
      name: Routes.setting,
      page: () => const Settings_Page(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const Profile_Page(),
    ),
    GetPage(
      name: Routes.password,
      page: () => Password_Page(),
    ),
    GetPage(
      name: '/listvisitor',
      page: () => const ListVisitor(),
    ),
    GetPage(
      name: '/chat',
      page: () => const ChatScreen(
        receiverId: '',
        name: '',
      ),
    ),
  ];
}
