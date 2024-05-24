import 'dart:convert';
import 'dart:developer';
import 'package:apna_software/db_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://app.apnabillbook.com/api/product';
  static const String storeId = '4ad3de84-bcaa-4bb2-9eb9-1846844e3314';

  Future<List<dynamic>> fetchProducts(int page, int pageSize) async {
    final response = await http.get(
      Uri.parse('$baseUrl?storeId=$storeId&page=$page&pageSize=$pageSize'),
    );

    log(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data']['data'] != null) {
        List<dynamic> products = List.from(data['data']['data']);

        for (var product in products) {
          product['isFavorite'] =
              await SharedPreferencesHelper.isFavoriteProduct(
                  product['id'].toString());
        }

        return products;
      } else {
        throw Exception('Products data is null');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}
