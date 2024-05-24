import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String favoriteProductsKey = 'favoriteProducts';

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<List<String>> getFavoriteProducts() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(favoriteProductsKey) ?? [];
  }

  static Future<void> setFavoriteProducts(List<String> favoriteProducts) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList(favoriteProductsKey, favoriteProducts);
  }

  static Future<void> addFavoriteProduct(String productId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favoriteProducts =
        prefs.getStringList(favoriteProductsKey) ?? [];
    if (!favoriteProducts.contains(productId)) {
      favoriteProducts.add(productId);
    }
    await prefs.setStringList(favoriteProductsKey, favoriteProducts);
  }

  static Future<void> removeFavoriteProduct(String productId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favoriteProducts =
        prefs.getStringList(favoriteProductsKey) ?? [];
    favoriteProducts.remove(productId);
    await prefs.setStringList(favoriteProductsKey, favoriteProducts);
  }

  static Future<bool> isFavoriteProduct(String productId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favoriteProducts =
        prefs.getStringList(favoriteProductsKey) ?? [];
    return favoriteProducts.contains(productId);
  }
}
