import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/profile_repository.dart';

class ReferEarnScreen extends ConsumerWidget {
  const ReferEarnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).profile;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Refer Friends & Earn', style: AppTypography.headlineSm()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.secondaryContainer),
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: AppColors.whiteSurface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_giftcard,
                      size: 30,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Give ₹50, Get ₹50',
                    style: AppTypography.headlineLgMobile(
                      color: AppColors.deepText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Introduce friends in Kalaburagi to pure, honest organic produce. When they place their first harvest order, you both get ₹50 off!',
                    style: AppTypography.bodyMd(color: AppColors.deepText),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Referral Code Container
            Text(
              'Your Exclusive Referral Code',
              style: AppTypography.labelLg(),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusMd,
                border: Border.all(color: AppColors.borderSubtle, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    profile.referralCode,
                    style: AppTypography.headlineSm(
                      color: AppColors.primaryContainer,
                    ).copyWith(letterSpacing: 1.5),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: profile.referralCode),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Referral code copied to clipboard!'),
                          backgroundColor: AppColors.primaryContainer,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.copy,
                      size: 16,
                      color: AppColors.primaryContainer,
                    ),
                    label: Text(
                      'Copy',
                      style: AppTypography.labelMd(
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Share Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF25D366,
                      ), // WhatsApp Green
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusMd,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'WhatsApp share invite triggered (simulation).',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share WhatsApp'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // How it works
            Align(
              alignment: Alignment.centerLeft,
              child: Text('How It Works', style: AppTypography.titleCard()),
            ),
            const SizedBox(height: 12),
            _buildStepTile(
              '1',
              'Share your code',
              'Send your referral code or invite link to friends and family.',
            ),
            _buildStepTile(
              '2',
              'Friend orders groceries',
              'They apply your code for ₹50 off on their first farm basket.',
            ),
            _buildStepTile(
              '3',
              'Earn harvest reward',
              '₹50 is credited automatically to your basket for next checkout.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTile(String step, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.softGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: AppTypography.labelMd(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLg(color: AppColors.deepText),
                ),
                Text(
                  desc,
                  style: AppTypography.bodySm(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
