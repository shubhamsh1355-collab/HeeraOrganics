import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../data/models/delivery_address.dart';
import '../../data/repositories/profile_repository.dart';

class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({super.key});

  void _showAddAddressDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final streetController = TextEditingController();
    final localityController = TextEditingController(text: 'Sedam Road');
    final pincodeController = TextEditingController(text: '585105');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.sheetTop),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Delivery Address', style: AppTypography.titleCard()),
              const SizedBox(height: 14),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Address Label (e.g. Home, Farm House)',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: 'Flat / House / Street Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: localityController,
                decoration: const InputDecoration(
                  labelText: 'Locality (Kalaburagi)',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pincodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Pincode'),
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Save Address',
                width: double.infinity,
                onPressed: () {
                  if (streetController.text.trim().isNotEmpty) {
                    ref
                        .read(profileProvider.notifier)
                        .addAddress(
                          DeliveryAddress(
                            id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
                            title: titleController.text.trim().isEmpty
                                ? 'Other'
                                : titleController.text.trim(),
                            streetAddress: streetController.text.trim(),
                            locality: localityController.text.trim(),
                            pincode: pincodeController.text.trim(),
                            isDefault: true,
                          ),
                        );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Manage Addresses', style: AppTypography.headlineSm()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: profileState.addresses.length,
        itemBuilder: (context, index) {
          final address = profileState.addresses[index];
          final isSelected = profileState.selectedAddress.id == address.id;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.whiteSurface,
              borderRadius: AppRadii.radiusLg,
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.borderSubtle,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          address.type == AddressType.home
                              ? Icons.home
                              : Icons.work,
                          color: AppColors.primaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(address.title, style: AppTypography.titleCard()),
                      ],
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softGreen,
                          borderRadius: AppRadii.radiusPill,
                        ),
                        child: Text(
                          'Active Delivery',
                          style: AppTypography.labelSm(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  address.fullAddress,
                  style: AppTypography.bodyMd(color: AppColors.deepText),
                ),
                if (address.deliveryInstructions != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Note: ${address.deliveryInstructions}',
                    style: AppTypography.bodySm(color: AppColors.mutedText),
                  ),
                ],
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isSelected)
                      TextButton(
                        onPressed: () => notifier.selectAddress(address),
                        child: Text(
                          'Set as Active',
                          style: AppTypography.labelMd(
                            color: AppColors.primaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppButton(
          text: 'Add New Address',
          icon: Icons.add,
          onPressed: () => _showAddAddressDialog(context, ref),
          width: double.infinity,
        ),
      ),
    );
  }
}
