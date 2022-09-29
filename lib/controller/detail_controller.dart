import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../api/api_services.dart';
import '../models/detail_response.dart';
import '../utils/static.dart';

class DetailController extends GetxController {
  DetailResponse _dataResto = DetailResponse();
  DetailResponse get dataResto => _dataResto;
  String _message = '';
  String get message => _message;
  late ResultState _state;
  ResultState get stateData => _state;
  final String query;
  DetailController({required this.query}){
    searchResto(query);
  }

  Future searchResto(query) async {
    try {
      _state = ResultState.loading;
      update();
      final newData = await ApiService().detailRestaurant(query);
      if (newData.error == true) {
        _state = ResultState.noData;
        update();
        return _message = 'Restaurant not found';
      } else {
        _state = ResultState.hasData;
        update();
        return _dataResto = newData;
      }
    } on DioError {
      _state = ResultState.error;
      update();
      return _message = 'Periksa Internet Anda..';
    }
  }
}
