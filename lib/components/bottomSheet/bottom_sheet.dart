// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/button/button_ontline.dart';
import 'package:doormster/screen/main_screen/add_company_page.dart';
import 'package:flutter/material.dart';

void bottomsheet(context, companyId, multiCompany) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25))),
    context: context,
    builder: (context) {
      return DraggableScrollableSheet(
          expand: false,
          initialChildSize: multiCompany.length == 0 ? 0.25 : 0.5,
          minChildSize: multiCompany.length == 0 ? 0.25 : 0.5,
          maxChildSize: 0.7,
          builder: (context, scrollController) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  toolbarHeight: 45,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        primary: false,
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                  height: 4,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            Text('สลับโครงการ')
                          ],
                        )),
                  ),
                  elevation: 0,
                ),
                backgroundColor: Colors.transparent,
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: multiCompany.length == 0
                      ? Center(
                          child: Text('โปรดตรวจสอบการเชื่อมต่อ',
                              style: TextStyle(color: Colors.white)),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: multiCompany.length,
                          itemBuilder: (context, index) => InkWell(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.home_work_sharp,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${multiCompany[index].companyName}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    companyId == multiCompany[index].companyId
                                        ? Icon(
                                            Icons.check_circle_rounded,
                                            size: 20,
                                            color: Colors.white,
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                              onTap: companyId == multiCompany[index].companyId
                                  ? () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    }
                                  : () {
                                      // _selectCompany(
                                      //   multiCompany[index].sId,
                                      //   multiCompany[index].companyId,
                                      // );
                                    }),
                        ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Buttons_Outline(
                      title: 'เพิ่มโครงการใหม่',
                      press: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Add_Company(),
                        ));
                      }),
                ),
              ));
    },
  );
}
