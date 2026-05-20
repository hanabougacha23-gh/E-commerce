import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../models/product.dart';

class ProductService {
  final Dio _api = ApiClient().dio;

  Future<List<Product>> getProducts() async {
    try {
      print('Appel API: ${_api.options.baseUrl}/products');
      final response = await _api.get('/products');
      print('Réponse reçue: ${response.statusCode}');
      print('Données brutes: ${response.data}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => Product.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Erreur détaillée ProductService: $e');
      if (e is DioException) {
        print('Erreur Dio: ${e.message}');
        print('Réponse erreur: ${e.response?.data}');
      }
      return [];
    }
  }
}
