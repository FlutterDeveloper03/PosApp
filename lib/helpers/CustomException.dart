// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

class CustomException extends Equatable implements Exception {
  @override
  List<Object> get props {
    return [];
  }
}

class CantConnectToServerException extends CustomException {
  final Exception e;
  CantConnectToServerException(this.e);
}

class CantFindEventsTableException extends CustomException {
  final Exception e;
  CantFindEventsTableException(this.e);
}