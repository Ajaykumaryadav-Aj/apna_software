import 'dart:developer';

import 'package:apna_software/api_service.dart';
import 'package:apna_software/db_service.dart';
import 'package:flutter/material.dart';

class ProductPagination extends StatefulWidget {
  const ProductPagination({super.key});

  @override
  _ProductPaginationState createState() => _ProductPaginationState();
}

class _ProductPaginationState extends State<ProductPagination> {
  final ApiService apiService = ApiService();
  List<dynamic> products = [];
  int currentPage = 1;
  final int pageSize = 10;
  bool isLoading = false;
  String appBarTitle = 'Products';

  @override
  void initState() {
    super.initState();
    fetchMoreProducts();
  }

  Future<void> fetchMoreProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newProducts = await apiService.fetchProducts(currentPage, pageSize);
      setState(() {
        currentPage++;
        products.addAll(newProducts);
        appBarTitle = 'Total Products: ${products.length}';
      });
    } catch (e) {
      log('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleFavorite(int index) async {
    final product = products[index];
    final productId = product['id'].toString();
    final isFavorite = product['isFavorite'];

    setState(() {
      product['isFavorite'] = !isFavorite;
    });

    if (isFavorite) {
      await SharedPreferencesHelper.removeFavoriteProduct(productId);
    } else {
      await SharedPreferencesHelper.addFavoriteProduct(productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchMoreProducts();
            return true;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: products.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == products.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final product = products[index];
            return ListTile(
              title: Text(product['name'] ?? 'No Name'),
              subtitle: Text(product['description'] ?? 'No Description'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(product['price'].toString()),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      product['isFavorite']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: product['isFavorite'] ? Colors.red : null,
                    ),
                    onPressed: () => toggleFavorite(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
