import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class Failure {
  final String errorMessage;

  const Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioError(
      DioException dioError, BuildContext context) {
    const String defaultMessage = "There is an error, try again later";
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
            AppLocalizations.of(context)?.connection_timeout_with_the_server ??
                defaultMessage);
      case DioExceptionType.sendTimeout:
        return ServerFailure(
            AppLocalizations.of(context)?.send_timeout_with_the_server ??
                defaultMessage);
      case DioExceptionType.connectionError:
        return ServerFailure(
            AppLocalizations.of(context)?.connection_timeout_with_the_server ??
                defaultMessage);
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
            AppLocalizations.of(context)?.receive_timeout_with_the_server ??
                defaultMessage);
      case DioExceptionType.badResponse:
        final response = dioError.response;
        final statusCode = response?.statusCode;
        if (statusCode != null) {
          return ServerFailure._fromResponse(
              statusCode, response?.data, context);
        } else {
          return ServerFailure(
              AppLocalizations.of(context)?.unexpected_error_occurred ??
                  defaultMessage);
        }
      case DioExceptionType.cancel:
        return ServerFailure(
            AppLocalizations.of(context)?.request_to_the_server_was_canceled ??
                defaultMessage);
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return ServerFailure(
              AppLocalizations.of(context)?.no_internet_connection ??
                  defaultMessage);
        }
        return ServerFailure(
            AppLocalizations.of(context)?.unexpected_error_occurred ??
                defaultMessage);
      default:
        return ServerFailure(
            AppLocalizations.of(context)?.unexpected_error_occurred ??
                defaultMessage);
    }
  }

  factory ServerFailure._fromResponse(
      int? statusCode, dynamic response, BuildContext context) {
    if (response is Map<String, dynamic> && response["status"] == false) {
      final message = response['message'];
      if (message != null) {
        return ServerFailure(message.toString());
      }
    }
    const String defaultMessage = "There is an error, try again later";

    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        return ServerFailure(AppLocalizations.of(context)
                ?.authentication_or_authorization_error ??
            defaultMessage);
      case 404:
        return ServerFailure(AppLocalizations.of(context)
                ?.the_requested_resource_was_not_found ??
            defaultMessage);
      case 500:
        return ServerFailure(
            AppLocalizations.of(context)?.internal_server_error ??
                defaultMessage);
      default:
        return ServerFailure(
            AppLocalizations.of(context)?.unexpected_error_occurred ??
                defaultMessage);
    }
  }
}
