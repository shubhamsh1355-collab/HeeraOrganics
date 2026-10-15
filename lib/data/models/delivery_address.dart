enum AddressType { home, work, other }

class DeliveryAddress {
  final String id;
  final String title;
  final String streetAddress;
  final String locality;
  final String city;
  final String pincode;
  final AddressType type;
  final bool isDefault;
  final String? deliveryInstructions;

  const DeliveryAddress({
    required this.id,
    required this.title,
    required this.streetAddress,
    required this.locality,
    this.city = 'Kalaburagi',
    required this.pincode,
    this.type = AddressType.home,
    this.isDefault = false,
    this.deliveryInstructions,
  });

  String get fullAddress => '$streetAddress, $locality, $city - $pincode';

  DeliveryAddress copyWith({
    String? id,
    String? title,
    String? streetAddress,
    String? locality,
    String? city,
    String? pincode,
    AddressType? type,
    bool? isDefault,
    String? deliveryInstructions,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      title: title ?? this.title,
      streetAddress: streetAddress ?? this.streetAddress,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
    );
  }
}
