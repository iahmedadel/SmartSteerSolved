import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class DioHelper {
  static Dio? _dio;
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  DioHelper._(); // Private constructor

  // Initialize Dio with base options and interceptors
  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            'http://192.168.1.5:8080/GP/', // Adjust to your server's base URL
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Adding interceptors for automatic token handling
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check and refresh token before attaching
          await _checkAndRefreshToken();

          // Retrieve the token from secure storage
          String? token = await _storage.read(key: 'authToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            log('Token attached: $token'); // Debug log
          }
          return handler.next(options); // Continue the request
        },
        onError: (error, handler) {
          // Handle errors globally
          if (error.response?.statusCode == 401) {
            log('Unauthorized error: ${error.response?.data}');
            // Optionally handle token expiration or unauthorized errors
          }
          return handler.next(error); // Continue with the error
        },
      ),
    );
  }

  // Check if token is expired and refresh if necessary
  static Future<void> _checkAndRefreshToken() async {
    String? token = await _storage.read(key: 'authToken');

    if (token == null || _isTokenExpired(token)) {
      log('Token expired or missing. Attempting to refresh...');
      try {
        await _refreshToken();
      } catch (e) {
        log('Token refresh failed: $e');
        throw Exception('Token refresh failed');
      }
    }
  }

  // Helper function to check if a token is expired
  static bool _isTokenExpired(String token) {
    try {
      final expiryDate = JwtDecoder.getExpirationDate(token);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      log('Error decoding token: $e');
      return true; // Treat as expired if there's an error
    }
  }

  // Refresh the token using a refresh endpoint
  static Future<void> _refreshToken() async {
    String? refreshToken = await _storage.read(key: 'refreshToken');

    if (refreshToken == null) {
      throw Exception('Refresh token missing');
    }

    final response = await _dio!.post(
      'refresh-token', // Replace with your refresh token endpoint
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode == 200) {
      String newToken = response.data['authToken'];
      await _storage.write(key: 'authToken', value: newToken);
      log('Token refreshed successfully');
    } else {
      throw Exception('Failed to refresh token: ${response.statusMessage}');
    }
  }

  // GET method
  static Future<Response> getData(
      {required String path, Map<String, dynamic>? queryparameters}) async {
    try {
      final response = await _dio!.get(path, queryParameters: queryparameters);
      log('GET $path: ${response.data}');
      return response;
    } catch (e) {
      log('GET $path failed: $e');
      rethrow; // Re-throw the error for handling at the calling site
    }
  }

  // POST method
  static Future<Response> postData(
      {required String path,
      Map<String, dynamic>? queryparameters,
      Map<String, dynamic>? body}) async {
    try {
      final response =
          await _dio!.post(path, queryParameters: queryparameters, data: body);
      log('POST $path: ${response.data}');
      return response;
    } catch (e) {
      log('POST $path failed: $e');
      rethrow;
    }
  }

  // DELETE method
  static Future<Response> deleteData(
      {required String path, Map<String, dynamic>? queryparameters}) async {
    try {
      final response =
          await _dio!.delete(path, queryParameters: queryparameters);
      log('DELETE $path: ${response.data}');
      return response;
    } catch (e) {
      log('DELETE $path failed: $e');
      rethrow;
    }
  }
}
