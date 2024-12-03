import 'package:dio/dio.dart';
import 'package:e_commerce/core/helpers/hive_helper.dart';

import '../constants/kapi.dart';


class DioHelpers {
  static Dio? _dio;

  DioHelpers._();

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Kapi.baseUrl,
        receiveTimeout: const Duration(
          seconds: 60,
        ),
        sendTimeout:  const Duration(
          seconds: 60,
        ),
        connectTimeout:  const Duration(
          seconds: 60,
        ),
        headers: {
          "lang": HiveHelper.getLanguage(),
          "Content-Type": "application/json",
          "Authorization":HiveHelper.getToken(),
        },
      ),
    );
  }

  //Get
  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = _dio!.get(path, queryParameters: queryParameters);
    return response;
  }

  //Post
  static Future<Response> postData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final response = _dio!.post(
      path,
      queryParameters: queryParameters,
      data: body,
    );
    return response;
  }

  //Put
  static Future<Response> putData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final response = _dio!.put(
      path,
      queryParameters: queryParameters,
      data: body,
    );
    return response;
  }

  //Delete
  static Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final response = _dio!.delete(
      path,
      queryParameters: queryParameters,
      data: body,
    );
    return response;
  }
}