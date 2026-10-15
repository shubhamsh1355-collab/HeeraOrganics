class PackOption {
  final String id;
  final String label;
  final num price;
  final num? originalPrice;
  final bool isDefault;

  const PackOption({
    required this.id,
    required this.label,
    required this.price,
    this.originalPrice,
    this.isDefault = false,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackOption && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Product {
  final String id;
  final String name;
  final String categoryId;
  final String defaultPackSize;
  final num price;
  final num? originalPrice;
  final String imageUrl;
  final String description;
  final String farmOrigin;
  final String harvestingMethod;
  final String storageTip;
  final String? badgeText;
  final List<PackOption> packOptions;
  final bool isOrganicCertified;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.defaultPackSize,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.description,
    this.farmOrigin = 'Heera Farms, Kalaburagi',
    this.harvestingMethod = 'Handpicked at dawn, pesticide-free',
    this.storageTip = 'Store in a cool dry place or vegetable crisper',
    this.badgeText,
    this.packOptions = const [],
    this.isOrganicCertified = true,
    this.inStock = true,
  });

  List<PackOption> get effectivePackOptions {
    if (packOptions.isNotEmpty) return packOptions;
    return [
      PackOption(
        id: '${id}_default',
        label: defaultPackSize,
        price: price,
        originalPrice: originalPrice,
        isDefault: true,
      ),
    ];
  }

  PackOption get defaultPackOption {
    final options = effectivePackOptions;
    return options.firstWhere(
      (p) => p.isDefault || p.label == defaultPackSize,
      orElse: () => options.first,
    );
  }
}
