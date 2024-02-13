// ignore_for_file: prefer_const_constructors, prefer_is_empty, use_build_context_synchronously, unused_import

import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_calendar.dart';
import 'package:doormster/models/get_checklist.dart';
import 'package:doormster/models/get_log.dart';
import 'package:doormster/models/get_logs_all.dart';
import 'package:doormster/screen/security_guard/logs_all_page.dart';
import 'package:doormster/screen/security_guard/logs_today_page.dart';
import 'package:doormster/screen/security_guard/record_point_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Report_Logs extends StatefulWidget {
  final type;
  final tapIndex;
  Report_Logs({Key? key, this.type, this.tapIndex});

  @override
  State<Report_Logs> createState() => _Report_LogsState();
}

class _Report_LogsState extends State<Report_Logs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.tapIndex,
      // animationDuration: Duration(
      //   seconds: 0,
      // ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.type != null) {
          Navigator.of(context).pop();
        } else {
          homeKey.currentState?.popUntil(ModalRoute.withName('/security'));
          Navigator.popUntil(context, (route) => route.isFirst);
        }
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('list_report'.tr),
            leading: button_back(() {
              if (widget.type != null) {
                Navigator.of(context).pop();
              } else {
                homeKey.currentState
                    ?.popUntil(ModalRoute.withName('/security'));
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            }),
            bottom: TabBar(
                physics: NeverScrollableScrollPhysics(),
                overlayColor: MaterialStatePropertyAll(Colors.transparent),
                controller: _tabController,
                padding: EdgeInsets.only(top: 10, right: 20.0, left: 20.0),
                labelColor: Theme.of(context).primaryColorDark,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    color: Theme.of(context).scaffoldBackgroundColor),
                tabs: [
                  Tab(
                    child: Text(
                      'today'.tr,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'all'.tr,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ]),
          ),
          body: TabBarView(
            // physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              Logs_Today(),
              Logs_All(),
            ],
          )),
    );
  }
}
