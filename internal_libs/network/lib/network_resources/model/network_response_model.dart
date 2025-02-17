import 'package:internal_core/setup/index.dart';
import 'package:internal_network/options.dart';
import 'package:dio/dio.dart' as dio;

class NetworkResponse<T> {
  static String disconnectError = 'disconnectError';
  static String unknownError = 'unknownError';

  String get responsePrefixData =>
      networkOptions?.responsePrefixData ?? "values";

  int? statusCode;
  T? data;
  String? msg;

  bool get isSuccess => networkOptions?.responseIsSuccess != null
      ? networkOptions!.responseIsSuccess!(this)
      : ((statusCode == 200 || statusCode == 201) && data != null);

  bool get isError => statusCode != 200 && statusCode != 201;
  bool get isErrorDisconnect => msg == disconnectError;

  NetworkResponse({this.data, this.statusCode, this.msg});

  factory NetworkResponse.fromResponse(dio.Response response,
      {dynamic Function(dynamic)? converter, value, String? prefix}) {
    try {
      return NetworkResponse._fromJson(response.data,
          converter: converter, prefix: prefix, value: value)
        ..statusCode = response.statusCode;
    } catch (e) {
      return NetworkResponse.withErrorConvert(e);
    }
  }

  NetworkResponse._fromJson(dynamic json,
      {dynamic Function(dynamic)? converter, value, String? prefix}) {
    if (value != null) {
      data = value;
    } else if (prefix != null) {
      if (prefix.trim().isEmpty) {
        data = converter != null && json != null ? converter(json) : json;
      } else {
        data = converter != null && json[prefix] != null
            ? converter(json[prefix])
            : json[prefix];
      }
    } else {
      if (responsePrefixData.isNotEmpty == true) {
        data = converter != null && json[responsePrefixData] != null
            ? converter(json[responsePrefixData])
            : json[responsePrefixData];
      } else {
        data = converter != null ? converter(json) : json;
      }
    }
  }

  NetworkResponse.withErrorRequest(dio.DioException error) {
    appDebugPrint("NetworkResponse.withErrorRequest: $error");
    try {
      data = null;
      dio.Response? response = error.response;
      statusCode = response?.statusCode ?? 500;
      if (response?.data?['error'] != null) {
        this.msg = response?.data?['error'];
      }
    } catch (e) {
      appDebugPrint("NetworkResponse.withErrorRequest: catch=$e");
    }
  }

  NetworkResponse.withErrorConvert(error) {
    appDebugPrint("NetworkResponse.withErrorConvert: $error");
    data = null;
    this.msg = unknownError;
  }

  NetworkResponse.withDisconnect() {
    appDebugPrint("NetworkResponse.withDisconnect");
    data = null;
    this.msg = disconnectError;
  }
}
