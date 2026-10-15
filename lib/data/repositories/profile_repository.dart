import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/delivery_address.dart';
import '../models/user_profile.dart';

class ProfileState {
  final UserProfile profile;
  final List<DeliveryAddress> addresses;
  final DeliveryAddress selectedAddress;
  final Set<String> wishlistProductIds;
  final bool isLoggedIn;

  const ProfileState({
    required this.profile,
    required this.addresses,
    required this.selectedAddress,
    this.wishlistProductIds = const {'prod_tomato', 'prod_milk'},
    this.isLoggedIn = true,
  });

  ProfileState copyWith({
    UserProfile? profile,
    List<DeliveryAddress>? addresses,
    DeliveryAddress? selectedAddress,
    Set<String>? wishlistProductIds,
    bool? isLoggedIn,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      wishlistProductIds: wishlistProductIds ?? this.wishlistProductIds,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return ProfileState(
      profile: MockData.sampleProfile,
      addresses: MockData.addresses,
      selectedAddress: MockData.addresses.first,
    );
  }

  void selectAddress(DeliveryAddress address) {
    state = state.copyWith(selectedAddress: address);
  }

  void addAddress(DeliveryAddress address) {
    state = state.copyWith(
      addresses: [...state.addresses, address],
      selectedAddress: address.isDefault ? address : state.selectedAddress,
    );
  }

  void toggleWishlist(String productId) {
    final updated = Set<String>.from(state.wishlistProductIds);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = state.copyWith(wishlistProductIds: updated);
  }

  void updateProfile({
    required String name,
    required String email,
    required int householdSize,
    required String language,
  }) {
    state = state.copyWith(
      profile: state.profile.copyWith(
        name: name,
        email: email,
        householdSize: householdSize,
        language: language,
      ),
    );
  }

  void loginAsGuest() {
    state = state.copyWith(
      isLoggedIn: false,
      profile: state.profile.copyWith(isGuest: true),
    );
  }

  void loginWithPhone(String phone) {
    state = state.copyWith(
      isLoggedIn: true,
      profile: state.profile.copyWith(phoneNumber: phone, isGuest: false),
    );
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
