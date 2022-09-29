import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../api/api_services.dart';
import '../models/list_restaurant_response.dart';
import '../utils/static.dart';

class HomeController extends GetxController {
  final ApiService apiService;
  late ListRestaurantResponse _listResto;
  ListRestaurantResponse get listResto => _listResto;
  String _message = '';
  String get message => _message;
  late ResultState _state;
  ResultState get stateData => _state;
  HomeController({required this.apiService}) {
    getList();
  }

  Future getList() async {
    try {
      _state = ResultState.loading;
      update();
      final dataResto = await ApiService().listRestaurant();
      if (dataResto.restaurants!.isEmpty) {
        _state = ResultState.noData;
        update();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        update();
        return _listResto = dataResto;
      }
    } on DioError {
      _state = ResultState.error;
      update();
      return _message = 'Periksa Internet Anda..';
    }
  }
}
