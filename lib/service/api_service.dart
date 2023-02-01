import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:employee/const/url.const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: Urls.baseUrl));

  Future<T?> get<T>(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.get<T>(path, queryParameters: queryParameters);
      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return response.data;
      } else {
        throw DioError(
            response: response, requestOptions: response.requestOptions);
      }
    } on DioError {
      rethrow;
    }
  }

  Future<T?> post<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post<T>(path,
          data: data, queryParameters: queryParameters);
      if ((response.statusCode ?? 0) >= 200 &&
          (response.statusCode ?? 0) < 300) {
        return response.data;
      } else {
        throw DioError(
            response: response, requestOptions: response.requestOptions);
      }
    } on DioError catch (e) {
      //   Flushbar(
      //     message: e.message,
      //     backgroundColor: Colors.red,
      //     flushbarPosition: FlushbarPosition.TOP,
      //     flushbarStyle: FlushbarStyle.GROUNDED,
      //   duration: const Duration(seconds: 3),
      // ).show(context);
      print(e);
    }
    return null;
  }
}
