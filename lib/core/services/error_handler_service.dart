import 'dart:io';

import 'package:flutter/material.dart';

import '../localization/l10n/app_localizations.dart';
import 'i_error_handler_service.dart';

class ErrorHandlerService implements IErrorHandlerService {


  @override
  String errorHandler(dynamic error, BuildContext context) {
    const String defaultMessage = "There is an error, try again later";

    if (error is SocketException) {
      return
          AppLocalizations.of(context)?.no_internet_connection ??
              defaultMessage;
    }

    return error.toString();
  }


}

