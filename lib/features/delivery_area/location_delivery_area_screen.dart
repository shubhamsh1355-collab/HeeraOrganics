import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../data/models/delivery_address.dart';
import '../../data/repositories/profile_repository.dart';

class LocationDeliveryAreaScreen extends ConsumerStatefulWidget {
  const LocationDeliveryAreaScreen({super.key});

  @override
  ConsumerState<LocationDeliveryAreaScreen> createState() =>
      _LocationDeliveryAreaScreenState();
}

class _LocationDeliveryAreaScreenState
    extends ConsumerState<LocationDeliveryAreaScreen> {
  final TextEditingController _pincodeController = TextEditingController(
    text: '585105',
  );
  String _selectedLocality = 'Sedam Road';

  final List<Map<String, dynamic>> _localities = [
    {
      'name': 'Sedam Road',
      'pincode': '585105',
      'active': true,
      'time': 'Morning 6:30 AM',
    },
    {
      'name': 'Court Road & Station',
      'pincode': '585102',
      'active': true,
      'time': 'Morning 7:00 AM',
    },
    {
      'name': 'MSK Mill Area',
      'pincode': '585103',
      'active': true,
      'time': 'Morning 7:15 AM',
    },
    {
      'name': 'Jewargi Colony',
      'pincode': '585104',
      'active': true,
      'time': 'Morning 6:45 AM',
    },
    {
      'name': 'Aland Road Belt',
      'pincode': '585101',
      'active': false,
      'time': 'Expanding Soon',
    },
  ];

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  void _confirmLocation() {
    final selected = _localities.firstWhere(
      (l) => l['name'] == _selectedLocality,
      orElse: () => _localities.first,
    );

    if (selected['active'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This locality is coming soon! Please choose an active delivery route.',
          ),
          backgroundColor: AppColors.errorAlert,
        ),
      );
      return;
    }

    final newAddress = DeliveryAddress(
      id: 'addr_temp_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Current Area',
      streetAddress: _selectedLocality,
      locality: _selectedLocality,
      pincode: selected['pincode'] as String,
      isDefault: true,
    );

    ref.read(profileProvider.notifier).selectAddress(newAddress);
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Delivery Area & Routes',
          style: AppTypography.headlineSm(color: AppColors.deepText),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where should we deliver fresh harvests?',
                style: AppTypography.headlineMd(color: AppColors.deepText),
              ),
              const SizedBox(height: 6),
              Text(
                'We currently deliver morning harvests across Kalaburagi daily via temperature-maintained direct routes.',
                style: AppTypography.bodyMd(color: AppColors.mutedText),
              ),
              const SizedBox(height: 20),

              // Use Current Location CTA
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryContainer,
                  side: const BorderSide(color: AppColors.primaryContainer),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusMd,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  setState(() {
                    _selectedLocality = 'Sedam Road';
                    _pincodeController.text = '585105';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Location detected: Sedam Road, Kalaburagi (Serviceable)',
                      ),
                      backgroundColor: AppColors.primaryContainer,
                    ),
                  );
                },
                icon: const Icon(Icons.my_location, size: 20),
                label: Text(
                  'Use Current Location (GPS)',
                  style: AppTypography.labelLg(
                    color: AppColors.primaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.borderSubtle)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR CHOOSE LOCALITY',
                      style: AppTypography.labelSm(color: AppColors.mutedText),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.borderSubtle)),
                ],
              ),
              const SizedBox(height: 16),

              // Supported Localities List
              Expanded(
                child: ListView.builder(
                  itemCount: _localities.length,
                  itemBuilder: (context, index) {
                    final item = _localities[index];
                    final isSelected = _selectedLocality == item['name'];
                    final isActive = item['active'] as bool;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.softGreen.withValues(alpha: 0.4)
                            : AppColors.whiteSurface,
                        borderRadius: AppRadii.radiusMd,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryContainer
                              : AppColors.borderSubtle,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: isActive
                              ? AppColors.primaryContainer
                              : AppColors.mutedText,
                        ),
                        title: Text(
                          item['name'] as String,
                          style: AppTypography.labelLg(
                            color: AppColors.deepText,
                          ),
                        ),
                        subtitle: Text(
                          'Pincode: ${item['pincode']} • ${item['time']}',
                          style: AppTypography.bodySm(
                            color: AppColors.mutedText,
                          ),
                        ),
                        trailing: isActive
                            ? (isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primaryContainer,
                                    )
                                  : null)
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: AppRadii.radiusPill,
                                ),
                                child: Text(
                                  'Soon',
                                  style: AppTypography.labelSm(
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ),
                        onTap: () {
                          setState(() {
                            _selectedLocality = item['name'] as String;
                            _pincodeController.text = item['pincode'] as String;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              AppButton(
                text: 'Confirm & Start Shopping',
                onPressed: _confirmLocation,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
