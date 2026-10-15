import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';

class SplashWelcomeScreen extends StatelessWidget {
  const SplashWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),

                // 1. Header & Brand Identity
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.borderSubtle,
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.spa,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Heera Organics',
                  style: AppTypography.displayHeroMobile(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Naturally Grown, Honestly Delivered',
                  style: AppTypography.bodyMd(color: AppColors.deepText)
                      .copyWith(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Origin & Specialty Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteSurface,
                    borderRadius: AppRadii.radiusPill,
                    border: Border.all(
                      color: AppColors.borderSubtle,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.nature,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'FARM-TO-FAMILY • FRESH DAIRY • KALABURAGI',
                        style: AppTypography.labelSm(color: AppColors.deepText)
                            .copyWith(
                              fontSize: 10,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Visual Centerpiece: Arched Harvest Window
                Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 320),
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.borderSubtle,
                        width: 1.0,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background Produce Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(31),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: AppColors.surfaceContainerLow,
                                  child: const Center(
                                    child: Icon(
                                      Icons.eco,
                                      size: 64,
                                      color: AppColors.primaryContainer,
                                    ),
                                  ),
                                ),
                          ),
                        ),

                        // Gradient Shade
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(31),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.primary.withValues(alpha: 0.35),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Floating Leaf Badge
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: AppColors.softGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.eco,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                        // Micro Freshness Guarantee Strip inside Arch
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.whiteSurface.withValues(
                                alpha: 0.95,
                              ),
                              borderRadius: AppRadii.radiusMd,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Morning Harvest Batch',
                                      style: AppTypography.labelMd(
                                        color: AppColors.deepText,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.softGreen,
                                    borderRadius: AppRadii.radiusPill,
                                  ),
                                  child: Text(
                                    'Just Arrived',
                                    style: AppTypography.labelSm(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Value Badges & Highlights Row
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildValueBadge(Icons.verified, '100% Honest Sourcing'),
                    _buildValueBadge(Icons.ac_unit, 'Cold-Chained Dairy'),
                    _buildValueBadge(Icons.location_on, 'Locally Sourced'),
                  ],
                ),
                const SizedBox(height: 24),

                // 4. Primary CTA Button: "Explore Fresh Catalogue"
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusMd,
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => context.go('/home'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.storefront, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              'Explore Fresh Catalogue',
                              style: AppTypography.labelLg(
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Secondary Navigation: Check Delivery Area • Browse as Guest
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.push('/location'),
                      icon: const Icon(
                        Icons.pin_drop,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      label: Text(
                        'Check Delivery Area',
                        style: AppTypography.labelMd(color: AppColors.primary)
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '•',
                        style: TextStyle(color: AppColors.borderSubtle),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: Text(
                        'Login / OTP',
                        style: AppTypography.labelMd(
                          color: AppColors.mutedText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bottom Brand Note
                Text(
                  'Direct daily routes from organic farmers to your pantry',
                  style: AppTypography.labelSm(color: AppColors.mutedText),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValueBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: AppRadii.radiusPill,
        border: Border.all(color: AppColors.borderSubtle, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(label, style: AppTypography.labelSm(color: AppColors.deepText)),
        ],
      ),
    );
  }
}
