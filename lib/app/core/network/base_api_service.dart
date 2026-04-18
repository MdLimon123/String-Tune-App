import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:demo_project/app/core/config/environment.dart';
import 'package:demo_project/app/core/constants/app_constants.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/connectivity_service.dart';
import 'package:demo_project/app/core/storage/storage_service.dart';
import 'package:demo_project/app/core/utils/logger.dart';

class BaseApiService {
  static final BaseApiService _instance = BaseApiService._internal();
  factory BaseApiService() => _instance;
  BaseApiService._internal();

  final http.Client _client = http.Client();
  final StorageService _storage = StorageService();
  final ConnectivityService _connectivity = ConnectivityService();

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _buildUri(String endpoint, {Map<String, dynamic>? queryParams}) {
    final uri = Uri.parse('${EnvironmentConfig.baseUrl}$endpoint');
    if (queryParams != null) {
      return uri.replace(queryParameters: queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      ));
    }
    return uri;
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? extraHeaders,
    Duration? timeout,
  }) async {
    return _request(
      () => _client.get(
        _buildUri(endpoint, queryParams: queryParams),
        headers: {..._headers, ...?extraHeaders},
      ),
      timeout: timeout,
    );
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? extraHeaders,
    Duration? timeout,
  }) async {
    return _request(
      () => _client.post(
        _buildUri(endpoint),
        headers: {..._headers, ...?extraHeaders},
        body: body != null ? jsonEncode(body) : null,
      ),
      timeout: timeout,
    );
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    Map<String, String>? extraHeaders,
    Duration? timeout,
  }) async {
    return _request(
      () => _client.put(
        _buildUri(endpoint),
        headers: {..._headers, ...?extraHeaders},
        body: body != null ? jsonEncode(body) : null,
      ),
      timeout: timeout,
    );
  }

  Future<dynamic> patch(
    String endpoint, {
    dynamic body,
    Map<String, String>? extraHeaders,
    Duration? timeout,
  }) async {
    return _request(
      () => _client.patch(
        _buildUri(endpoint),
        headers: {..._headers, ...?extraHeaders},
        body: body != null ? jsonEncode(body) : null,
      ),
      timeout: timeout,
    );
  }

  /// PATCH with `multipart/form-data` (e.g. `full_name` + file field `image`).
  /// Do not set JSON `Content-Type`; boundary is set on the request.
  Future<dynamic> patchMultipart(
    String endpoint, {
    required Map<String, String> fields,
    File? file,
    String fileFieldName = 'image',
    Map<String, String>? extraHeaders,
    Duration? timeout,
  }) async {
    if (!await _connectivity.hasConnection) {
      throw ApiException.noInternet();
    }

    final uri = _buildUri(endpoint);
    final request = http.MultipartRequest('PATCH', uri);

    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    if (extraHeaders != null) {
      request.headers.addAll(extraHeaders);
    }

    request.fields.addAll(fields);

    if (file != null && file.existsSync()) {
      final segments = file.uri.pathSegments;
      final filename = segments.isNotEmpty ? segments.last : 'image.jpg';
      request.files.add(
        await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
          filename: filename,
        ),
      );
    }

    try {
      final streamed = await _client
          .send(request)
          .timeout(timeout ?? Duration(seconds: AppConstants.connectTimeout));

      final response = await http.Response.fromStream(streamed);

      AppLogger.network(
        '=======> Method: PATCH (multipart) \n url : ${response.request?.url} \n  -----> status Code ${response.statusCode} \n ========> ${response.body} ',
      );

      return _processResponse(response);
    } on TimeoutException {
      throw ApiException.timeout();
    } on SocketException {
      throw ApiException(message: 'Could not connect to server');
    } on ApiException {
      rethrow;
    } catch (e) {
      AppLogger.error('Network error', error: e);
      throw ApiException.unknown(e);
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? extraHeaders,
    Duration? timeout,
  }) async {
    return _request(
      () => _client.delete(
        _buildUri(endpoint),
        headers: {..._headers, ...?extraHeaders},
      ),
      timeout: timeout,
    );
  }

  Future<dynamic> _request(
    Future<http.Response> Function() request, {
    Duration? timeout,
  }) async {
    if (!await _connectivity.hasConnection) {
      throw ApiException.noInternet();
    }

    try {
      final response = await request().timeout(
        timeout ?? Duration(seconds: AppConstants.connectTimeout),
      );

      AppLogger.network('=======> Method: ${response.request?.method} \n url : ${response.request?.url} \n  -----> status Code ${response.statusCode} \n ========> ${response.body} ');

      return _processResponse(response);
    } on TimeoutException {
      throw ApiException.timeout();
    } on SocketException {
      throw ApiException(message: 'Could not connect to server');
    } on ApiException {
      rethrow;
    } catch (e) {
      AppLogger.error('Network error', error: e);
      throw ApiException.unknown(e);
    }
  }

  dynamic _processResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw ApiException.fromStatusCode(response.statusCode, body);
  }
}
