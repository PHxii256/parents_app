import 'package:dio/dio.dart';

bool isResOk(Response<dynamic> response) {
  if (response.statusCode != null) {
    if (response.statusCode! >= 200 && response.statusCode! < 404) return true;
  }
  return false;
}
