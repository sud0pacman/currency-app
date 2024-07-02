import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:valyuta_kursi/data/source/model/response/currency_response.dart';

class ApiService {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://cbu.uz/uz/',
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    contentType: 'application/json',
  ));

  Future<List<CurrencyModel>> getCurrency() async {
    try {
      _dio.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseData: true,
            printResponseHeaders: true,
            printResponseMessage: true,
          ),
        ),
      );

      final response = await _dio.get("arkhiv-kursov-valyut/json/");
      return (response.data as List)
          .map((element) => CurrencyModel.fromJson(element))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<List<CurrencyModel>> getCurrencyByDate(String date) async {
    try {
      _dio.interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseData: true,
            printResponseHeaders: true,
            printResponseMessage: true,
          ),
        ),
      );
      print("****************************   Api getCurrencyByDate $date");
      var response = await _dio.get("arkhiv-kursov-valyut/json/all/$date/");

      return (response.data as List)
          .map((element) => CurrencyModel.fromJson(element))
          .toList();
    } on DioException {
      rethrow;
    }
  }
}
