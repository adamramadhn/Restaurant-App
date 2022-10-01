import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/detail_controller.dart';
import '../controller/review_controller.dart';
import '../utils/static.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Restaurant',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<DetailController>(
        init: DetailController(query: id),
        builder: (data) {
          if (data.stateData == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.stateData == ResultState.hasData) {
            final dataResto = data.dataResto;
            return SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: Image.network(
                      '$urlPictLargeId${dataResto.restaurant?.pictureId}',
                      errorBuilder: (context, error, stackTrace) => const Text(
                        "Periksa jaringan anda..",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      loadingBuilder: (context, child, loadingProgress) =>
                          child,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              child: Text(
                                dataResto.restaurant?.name ?? 'something wrong',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            FittedBox(
                              child: TextButton(
                                onPressed: () {
                                  late TextEditingController txtName;
                                  late TextEditingController txtReview;
                                  final formLogin = GlobalKey<FormState>();
                                  txtName = TextEditingController();
                                  txtReview = TextEditingController();
                                  Get.bottomSheet(
                                    SingleChildScrollView(
                                      child: Container(
                                        height: Get.height * 0.3,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Form(
                                            key: formLogin,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'this field must be filled!';
                                                      }
                                                      return null;
                                                    },
                                                    controller: txtName,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Input your name..'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'this field must be filled!';
                                                      }
                                                      return null;
                                                    },
                                                    controller: txtReview,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Your review..'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      final revC = Get.put(
                                                          ReviewController());
                                                      final isValidForm =
                                                          formLogin
                                                              .currentState!
                                                              .validate();
                                                      if (isValidForm) {
                                                        revC
                                                            .revResto(
                                                                dataResto
                                                                        .restaurant
                                                                        ?.id ??
                                                                    '',
                                                                txtName.text,
                                                                txtReview.text)
                                                            .then(
                                                          (value) {
                                                            data.searchResto(
                                                                id);
                                                            Get.back();
                                                            Get.snackbar(
                                                                'Yeay!',
                                                                'Berhasil mereview restoran!',
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            3),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green);
                                                          },
                                                          onError: (e) {
                                                            Get.back();
                                                            Get.snackbar(
                                                                'Oops!',
                                                                'Terjadi Kesalahan!\n$e',
                                                                colorText:
                                                                    Colors
                                                                        .black,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            3),
                                                                backgroundColor:
                                                                    Colors
                                                                        .grey);
                                                          },
                                                        );
                                                      } else {
                                                        Get.snackbar('Oops!',
                                                            'Lengkapi form terlebih dahulu!',
                                                            colorText:
                                                                Colors.white,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 3),
                                                            backgroundColor:
                                                                Colors.red);
                                                      }
                                                    },
                                                    child: const Text('Submit'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      txtName.dispose();
                                                      txtReview.dispose();
                                                      Get.back();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      'Add Review',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              size: 20,
                              color: Colors.green,
                            ),
                            Text(
                              dataResto.restaurant?.city ?? 'something wrong..',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.yellow,
                            ),
                            Text(
                              dataResto.restaurant?.rating?.toString() ?? '..',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          dataResto.restaurant?.description ??
                              'Something wrong',
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Foods",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                dataResto.restaurant?.menus?.foods?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    dataResto.restaurant?.menus?.foods?[index]
                                            .name ??
                                        'something wrong',
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Drinks",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                dataResto.restaurant?.menus?.drinks?.length ??
                                    0,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    dataResto.restaurant?.menus?.drinks?[index]
                                            .name ??
                                        'something wrong',
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Reviews",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: Get.height * 0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                dataResto.restaurant?.customerReviews?.length ??
                                    0,
                            itemBuilder: (context, index) {
                              final data =
                                  dataResto.restaurant?.customerReviews?[index];
                              return Container(
                                width: Get.width * 0.8,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          data?.name ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          data?.date ?? '',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          data?.review ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                              // _reviews(data?.name ?? '',
                              //     data?.review ?? '', data?.date ?? '');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.message),
                  ElevatedButton(
                    onPressed: () {
                      data.searchResto(id);
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

Widget _reviews(String nama, String review, String date) {
  return Column(
    children: [
      Text(nama),
      Column(
        children: [
          Flexible(
            child: Text(review),
          ),
          Flexible(
            child: Text(date),
          ),
        ],
      ),
    ],
  );
}
