import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../api/api_services.dart';
import '../models/search_response.dart';
import '../utils/static.dart';

class SearchController extends GetxController {
  SearchResponse _listResto = SearchResponse();
  SearchResponse get listResto => _listResto;
  String _message = '';
  String get message => _message;
  late ResultState _state;
  ResultState get stateData => _state;

  Future searchResto(query) async {
    try {
      final data = {'q': query};
      _state = ResultState.loading;
      update();
      final dataResto = await ApiService().searchRestaurant(data);
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
