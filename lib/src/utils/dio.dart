import 'dart:developer';

import 'package:dio/dio.dart';

import 'failure.dart';

class DioUtils {
  DioUtils._();
  static final instance = DioUtils._();

  Failure onError(DioError error) {
    final data = error.response?.data;
    switch (error.type) {
      case DioErrorType.response:
        log("Error DioResponse ${error.message}");
        return ResponseFailure(message: data['message']);
      case DioErrorType.connectTimeout:
        log("Error DioConnectionTimeOut");
        return const ConnectionTimeoutFailure();
      case DioErrorType.receiveTimeout:
        log("Error DioReceiveTimeOut");
        return const ReceiveTimeoutFailure();
      case DioErrorType.sendTimeout:
        log("Error DioSendTimeOut");
        return const SendTimeoutFailure();
      default:
        log("Error DioUncaughtTimeOut");
        return const UncaughtFailure();
    }
  }
}

final dioUtils = DioUtils.instance;
