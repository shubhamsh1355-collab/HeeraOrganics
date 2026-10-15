import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../data/repositories/profile_repository.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late int _householdSize;
  late String _language;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).profile;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _householdSize = profile.householdSize;
    _language = profile.language;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    ref
        .read(profileProvider.notifier)
        .updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          householdSize: _householdSize,
          language: _language,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile details updated successfully!'),
        backgroundColor: AppColors.primaryContainer,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Edit Profile & Preferences',
          style: AppTypography.headlineSm(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            Text('Full Name', style: AppTypography.labelMd()),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your full name',
              ),
            ),
            const SizedBox(height: 18),

            // Email Field
            Text('Email Address', style: AppTypography.labelMd()),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'name@example.com'),
            ),
            const SizedBox(height: 20),

            // Household Size
            Text(
              'Household Size (For grocery portion suggestions)',
              style: AppTypography.labelMd(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [1, 2, 3, 4, 5].map((size) {
                final isSelected = _householdSize == size;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(size == 5 ? '5+ members' : '$size'),
                    selected: isSelected,
                    selectedColor: AppColors.softGreen,
                    backgroundColor: AppColors.whiteSurface,
                    labelStyle: AppTypography.labelMd(
                      color: isSelected
                          ? AppColors.primaryContainer
                          : AppColors.deepText,
                    ),
                    onSelected: (_) => setState(() => _householdSize = size),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // App Language Selection
            Text('App Language', style: AppTypography.labelMd()),
            const SizedBox(height: 8),
            Row(
              children: ['English', 'ಕನ್ನಡ (Kannada)'].map((lang) {
                final isSelected = _language.startsWith(lang.substring(0, 3));
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(lang),
                    selected: isSelected,
                    selectedColor: AppColors.softGreen,
                    backgroundColor: AppColors.whiteSurface,
                    labelStyle: AppTypography.labelMd(
                      color: isSelected
                          ? AppColors.primaryContainer
                          : AppColors.deepText,
                    ),
                    onSelected: (_) => setState(() => _language = lang),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 36),

            AppButton(
              text: 'Save Changes',
              onPressed: _saveProfile,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
