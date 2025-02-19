// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_field, non_constant_identifier_names, unnecessary_null_comparison
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doormster/controller/theme_controller.dart';
import 'package:doormster/screen/estamp_service/estamp_page.dart';
import 'package:doormster/screen/qr_smart_access/smart_accress_menu.dart';
import 'package:doormster/screen/security_guard/security_guard_menu.dart';
import 'package:doormster/screen/visitor_service/visitor_service_page.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/widgets/girdManu/grid_menu.dart';
import 'package:doormster/widgets/image/show_images.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/controller/main_controller/advert_controller.dart';
import 'package:doormster/controller/main_controller/home_controller.dart';
import 'package:doormster/models/main_models/get_menu.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get/get.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({
    super.key,
  });

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page>
// with AutomaticKeepAliveClientMixin
{
  final HomeController homeController = Get.put(HomeController());

  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Obx(() {
        List<GetMenu> mergeMenu(List<GetMenu> apiMenus) {
          return allMenus.map((menu) {
            final matchedMenu = apiMenus.firstWhere(
              (m) => m.rowId == menu.rowId,
              orElse: () => menu,
            );
            return matchedMenu;
            // .copyWith(page: menu.page);
          }).toList();
        }

        final List<GetMenu> mergedMenus =
            mergeMenu(homeController.listMenu.value);
        return Stack(
          children: [
            Scaffold(
                appBar: AppBar(
                  title: Text('HIP Smart Community'),
                  // leading: IconButton(
                  //     icon: Icon(Icons.menu),
                  //     onPressed: () {
                  //       Scaffold.of(context).openDrawer();
                  //     }),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    homeController.Get_Info();
                  },
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        PhysicalModel(
                          color: Colors.white,
                          elevation: 10,
                          child: SizedBox(
                              height: Get.mediaQuery.size.width * 0.6,
                              width: double.infinity,
                              child: advert_controller.list_Advert.isNotEmpty
                                  ? themeController.imageTheme(
                                      imageLight: 'assets/images/HIP_Ads.png',
                                      imageDark:
                                          'assets/images/HIP_Ads_Black.png',
                                      BoxFit: BoxFit.cover)
                                  : Swiper(
                                      autoplay: advert_controller
                                                  .list_Advert.length ==
                                              1
                                          ? false
                                          : true,
                                      loop: advert_controller
                                                  .list_Advert.length ==
                                              1
                                          ? false
                                          : true,
                                      physics: advert_controller
                                                  .list_Advert.length ==
                                              1
                                          ? NeverScrollableScrollPhysics()
                                          : ClampingScrollPhysics(),
                                      pagination: SwiperPagination(
                                          builder: DotSwiperPaginationBuilder(
                                        size: 8,
                                        activeSize: 8,
                                        color: Colors.grey,
                                        activeColor: Colors.black,
                                      )),
                                      itemCount:
                                          advert_controller.list_Advert.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            // onTap: () {
                                            //   launchUrlString('https://hipglobal.co.th/');
                                            // },
                                            child: Container(
                                          color: Colors.white,
                                          child: advert_controller
                                                      .list_Advert[index].img ==
                                                  null
                                              ? NoImage()
                                              : CachedNetworkImage(
                                                  imageUrl: imageDomain +
                                                      advert_controller
                                                          .list_Advert[index]
                                                          .img!,
                                                  useOldImageOnUrlChange: true,
                                                  placeholder: (context, url) =>
                                                      CircleLoading(
                                                        backgroundColor:
                                                            Colors.grey[400],
                                                      ),
                                                  errorWidget:
                                                      (context, url, error) {
                                                    debugPrint("error: $error");
                                                    return imageError();
                                                  }),
                                        ));
                                      },
                                    )),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(
                                20, 20, 20, Get.mediaQuery.size.width * 0.15),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 30,
                                mainAxisSpacing: 30,
                              ),
                              itemCount: mergedMenus.length,
                              itemBuilder: (context, index) {
                                final menu = mergedMenus[index];
                                return Grid_Menu(
                                  title: menu.name,
                                  press: menu.permission == false
                                      ? () => dialogOnebutton(
                                            title: 'manu_permission'.tr,
                                            icon: Icons.warning_amber_rounded,
                                            colorIcon: Colors.orange,
                                            textButton: 'ok'.tr,
                                            press: () => Get.back(),
                                            click: true,
                                            willpop: true,
                                          )
                                      : () =>
                                          checkInternetName(page: menu.page),
                                  icon: menu.icon,
                                  color: menu.permission == false
                                      ? Colors.grey
                                      : null,
                                  type: menu.iconType,
                                );
                              },
                            )),
                      ],
                    ),
                  ),
                )),
            homeController.loading.isTrue ? Loading() : Container(),
          ],
        );
      }),
    );
  }

  final List<GetMenu> allMenus = [
    GetMenu(
      page: Smart_Accress_Menu(),
      icon: "0xf78c",
      iconType: "cuper",
      name: "QR Smart",
      rowId: 1,
      permission: false,
    ),
    GetMenu(
      page: Visitor_Service(),
      icon: "0xe491",
      iconType: "normal",
      name: "Visitor",
      rowId: 2,
      permission: false,
    ),
    GetMenu(
      page: Security_Guard_Menu(),
      icon: "0xf013e",
      iconType: "normal",
      name: "Security",
      rowId: 3,
      permission: false,
    ),
    GetMenu(
      page: Estamp_Page(),
      icon: "0xf919",
      iconType: "cuper",
      name: "E-Stamp",
      rowId: 4,
      permission: false,
    ),
  ].obs;
}
