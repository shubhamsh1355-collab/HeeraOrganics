class Subcategory {
  final String id;
  final String name;
  final String icon;

  const Subcategory({required this.id, required this.name, required this.icon});
}

class Category {
  final String id;
  final String name;
  final String iconUrl;
  final String bannerText;
  final List<Subcategory> subcategories;

  const Category({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.bannerText,
    this.subcategories = const [],
  });
}
