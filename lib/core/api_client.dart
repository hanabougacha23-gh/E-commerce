import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Adresse IP de votre PC pour le Wi-Fi (192.168.100.2)
  // Assurez-vous que votre téléphone est sur le même réseau Wi-Fi
  static const String baseUrl = 'http://10.20.0.111:8081/api';
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15), // 15 secondes max pour se connecter
    receiveTimeout: const Duration(seconds: 15), // 15 secondes max pour recevoir
  ));

  ApiClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;
}
