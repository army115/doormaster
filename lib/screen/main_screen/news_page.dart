// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, use_build_context_synchronously

import 'package:doormster/components/image/show_images.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/controller/branch_controller.dart';
import 'package:doormster/controller/news_controller.dart';
import 'package:doormster/models/news_models/get_news.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class News_Page extends StatefulWidget {
  const News_Page({super.key});

  @override
  State<News_Page> createState() => _News_PageState();
}

class _News_PageState extends State<News_Page>
    with AutomaticKeepAliveClientMixin {
  List showtext = news_controller.showtext;
  List<Data> listNews = news_controller.list_News;
  String branch = branchController.branch_Id.value;

  @override
  bool get wantKeepAlive => true;

  // @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      news_controller.get_News(branch_id: branch);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('news_feed'.tr),
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              }),
        ),
        body: connectApi.loading.isTrue
            ? Loading()
            : RefreshIndicator(
                onRefresh: () async {
                  await news_controller.get_News(branch_id: branch);
                },
                child: Container(
                  child: listNews.isEmpty
                      ? Logo_Opacity(title: 'no_news'.tr)
                      : ListView.builder(
                          itemCount: listNews.length,
                          padding: const EdgeInsets.all(15),
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${listNews[index].title}',
                                      style: const TextStyle(
                                          fontSize: 15, height: 1.3),
                                    ),
                                    Divider(
                                      color: Theme.of(context).primaryColor,
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 3),
                                    OneImage(listNews[index].img, false),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${listNews[index].announcementText}',
                                      maxLines: !showtext[index] ? 4 : null,
                                      overflow: !showtext[index]
                                          ? TextOverflow.ellipsis
                                          : null,
                                      style: textStyle().body14,
                                    ),
                                    Divider(
                                      color: Theme.of(context).primaryColor,
                                      thickness: 1,
                                    ),
                                    if (listNews[index]
                                            .announcementText!
                                            .length >
                                        100)
                                      Center(
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showtext[index] =
                                                    !showtext[index];
                                              });
                                            },
                                            child: Text(
                                              !showtext[index]
                                                  ? 'see_more'.tr
                                                  : 'see_less'.tr,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14),
                                            )),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
      ),
    );
  }
}
