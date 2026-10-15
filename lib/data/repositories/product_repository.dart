import '../mock/mock_data.dart';
import '../models/category.dart';
import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProducts({String? categoryId, String? query});
  Future<Product?> getProductById(String id);
}

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockData.categories;
  }

  @override
  Future<List<Product>> getProducts({String? categoryId, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var results = MockData.products;

    if (categoryId != null && categoryId.isNotEmpty) {
      results = results.where((p) => p.categoryId == categoryId).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      results = results
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q),
          )
          .toList();
    }

    return results;
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return MockData.products.where((p) => p.id == id).firstOrNull;
  }
}
