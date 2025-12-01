import 'dart:io';

import 'package:flutter/material.dart';

import '../localization/l10n/app_localizations.dart';

abstract class Failure {
  final String errorMessage;

  const Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage);

  // Simplified error handling for Firebase errors
  factory ServerFailure.fromException(dynamic error, BuildContext context) {
    print('Error occurred: $error');
    const String defaultMessage = "There is an error, try again later";

    if (error is SocketException) {
      return ServerFailure(
          AppLocalizations.of(context)?.no_internet_connection ??
              defaultMessage);
    }

    return ServerFailure(error.toString());
  }
}
