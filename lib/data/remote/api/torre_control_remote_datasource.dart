import 'package:dio/dio.dart';
import '../../../domain/model/torre_control.dart';

class TorreControlRemoteDatasource {
  final Dio _dio;
  TorreControlRemoteDatasource(this._dio);

  Future<List<TorreControl>> getTorres() async {
    final response = await _dio.get('/torre-control/');
    return (response.data as List).map((e) => TorreControl.fromJson(e)).toList();
  }
}