// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doormster/widgets/image/show_images.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/controller/main_controller/news_controller.dart';
import 'package:doormster/models/news_models/get_news.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doormster/style/textStyle.dart';

class News_Page extends StatefulWidget {
  const News_Page({super.key});

  @override
  State<News_Page> createState() => _News_PageState();
}

class _News_PageState extends State<News_Page> {
  final NewsController newsController = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List showtext = newsController.showtext.value;
      List<Data> listNews = newsController.list_News.value;

      return Scaffold(
        appBar: AppBar(
          title: Text('news_feed'.tr),
          // leading: IconButton(
          //     icon: const Icon(Icons.menu),
          //     onPressed: () {
          //       Scaffold.of(context).openDrawer();
          //     }),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await newsController.get_News();
          },
          child: Container(
            child: listNews.isEmpty
                ? Logo_Opacity(title: 'no_news'.tr)
                : ListView.builder(
                    addAutomaticKeepAlives: true,
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
                                style:
                                    const TextStyle(fontSize: 15, height: 1.3),
                              ),
                              Divider(
                                color: Theme.of(context).primaryColor,
                                thickness: 1,
                              ),
                              const SizedBox(height: 3),
                              listNews[index].img == '' ||
                                      listNews[index].img == null
                                  ? Container()
                                  : showImage(listNews[index].img!),
                              Text(
                                '${listNews[index].announcementText}',
                                maxLines: !showtext[index] ? 4 : null,
                                overflow: !showtext[index]
                                    ? TextOverflow.ellipsis
                                    : null,
                                style: textStyle.body14,
                              ),
                              Divider(
                                color: Theme.of(context).primaryColor,
                                thickness: 1,
                              ),
                              if (listNews[index].announcementText!.length >
                                  100)
                                Center(
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showtext[index] = !showtext[index];
                                        });
                                      },
                                      child: Text(
                                        !showtext[index]
                                            ? 'see_more'.tr
                                            : 'see_less'.tr,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
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
      );
    });
  }

  Widget showImage(String image) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: CachedNetworkImage(
              imageUrl: "$imageDomain$image",
              cacheKey: "$imageDomain$image",
              useOldImageOnUrlChange: true,
              placeholder: (context, url) => CircleLoading(),
              errorWidget: (context, url, error) => imageError(),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
