import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/api_services.dart';
import '../controller/home_controller.dart';
import '../controller/search_controller.dart';
import '../utils/static.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final data = Get.put(HomeController);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Resto',
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearch(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: GetBuilder<HomeController>(
        init: HomeController(apiService: ApiService()),
        builder: (data) {
          if (data.stateData == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.stateData == ResultState.hasData) {
            final listData = data.listResto;
            return ListView.builder(
              itemCount: listData.count,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Get.to(
                    () => DetailPage(
                      id: listData.restaurants?[index].id ?? '',
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    leading: SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '$urlPictId${listData.restaurants?[index].pictureId}',
                          fit: BoxFit.cover,
                          width: 100,
                          errorBuilder: (context, error, stackTrace) => Text(
                            error.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          loadingBuilder: (context, child, loadingProgress) =>
                              child,
                        ),
                      ),
                    ),
                    title: Text(
                      listData.restaurants?[index].name ?? '...',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Flexible(
                              child: Icon(
                                Icons.location_pin,
                                size: 20,
                                color: Colors.green,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                listData.restaurants?[index].city ??
                                    'something wrong..',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            const Flexible(
                              child: Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.yellow,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${listData.restaurants?[index].rating ?? 0.0}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (data.stateData == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(data.message),
              ),
            );
          } else if (data.stateData == ResultState.error) {
            return Center(
              child: Column(
                children: [
                  Text(data.message),
                  ElevatedButton(
                    onPressed: () {
                      data.getList();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        },
      ),
    );
  }
}

class MySearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.grey,
          ),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        ),
      ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );
  @override
  Widget buildResults(BuildContext context) => GetBuilder<SearchController>(
        init: SearchController(),
        builder: (data) {
          data.searchResto(query);
          final listData = data.listResto;
          if (data.stateData == ResultState.error) {
            return Center(
              child: Text(data.message),
            );
          } else if (data.stateData == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.stateData == ResultState.noData) {
            return Center(
              child: Text(data.message),
            );
          } else if (data.stateData == ResultState.hasData) {
            return ListView.builder(
              itemCount: listData.founded,
              itemBuilder: (context, index) {
                final suggestion = listData.restaurants?[index];
                return ListTile(
                  title: Text(suggestion?.name ?? ''),
                  onTap: () {
                    Get.to(
                      () => DetailPage(
                        id: suggestion?.id ?? '',
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(data.message),
            );
          }
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Text('');
    // GetBuilder<SearchController>(
    //   init: SearchController(),
    //   builder: (data) {
    //     data.searchResto(query);
    //     final listData = data.listResto;
    //     return ListView.builder(
    //         itemCount: listData.founded,
    //         itemBuilder: (context, index) {
    //           final suggestion = listData.restaurants?[index];
    //           return ListTile(
    //             title: Text(suggestion?.name ?? ''),
    //             onTap: () {
    //               // query = suggestion?.name ?? '';
    //               // showResults(context);
    //               // query = suggestion?.id ?? '';
    //               Get.to(
    //                 () => DetailPage(
    //                   id: suggestion?.id ?? '',
    //                 ),
    //               );
    //             },
    //           );
    //         });
    //   },
    // );
  }
}
