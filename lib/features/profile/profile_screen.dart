import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final user = profileState.profile;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Account & Preferences',
          style: AppTypography.headlineSm(color: AppColors.deepText),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.borderSubtle, width: 1.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.softGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                        style: AppTypography.headlineMd(
                          color: AppColors.primaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: AppTypography.titleCard(
                            color: AppColors.deepText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.phoneNumber,
                          style: AppTypography.bodySm(
                            color: AppColors.mutedText,
                          ),
                        ),
                        if (user.email.isNotEmpty)
                          Text(
                            user.email,
                            style: AppTypography.bodySm(
                              color: AppColors.mutedText,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primaryContainer,
                    ),
                    onPressed: () => context.push('/profile/edit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick App Navigation Section
            Text(
              'My Groceries & Harvests',
              style: AppTypography.labelLg(color: AppColors.deepText),
            ),
            const SizedBox(height: 8),
            _buildActionCard([
              _buildActionTile(
                icon: Icons.location_on_outlined,
                title: 'Saved Delivery Addresses',
                subtitle:
                    '${profileState.addresses.length} addresses configured',
                onTap: () => context.push('/addresses'),
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.favorite_border,
                title: 'Saved Harvests (Wishlist)',
                subtitle:
                    '${profileState.wishlistProductIds.length} items saved',
                onTap: () => context.push('/wishlist'),
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.card_giftcard,
                title: 'Refer Friends & Earn',
                subtitle: 'Share code ${user.referralCode} for ₹50 off',
                onTap: () => context.push('/referral'),
              ),
            ]),
            const SizedBox(height: 20),

            // Trust & Sourcing
            Text(
              'Transparency & Sourcing',
              style: AppTypography.labelLg(color: AppColors.deepText),
            ),
            const SizedBox(height: 8),
            _buildActionCard([
              _buildActionTile(
                icon: Icons.verified_outlined,
                title: 'Our Natural Farming Standards',
                subtitle: 'Kalaburagi & Sedam cluster audit details',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Heera Organics: Zero chemicals, 100% natural borewell water.',
                      ),
                      backgroundColor: AppColors.primaryContainer,
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.psychology_outlined,
                title: 'AI Farm Assistant / Agronomist',
                subtitle: 'Ask questions about seasonal harvests & recipes',
                onTap: () => context.push('/farm-assistant'),
              ),
            ]),
            const SizedBox(height: 20),

            // Support & Help
            Text(
              'Customer Care',
              style: AppTypography.labelLg(color: AppColors.deepText),
            ),
            const SizedBox(height: 8),
            _buildActionCard([
              _buildActionTile(
                icon: Icons.help_outline,
                title: 'Help & Support Hub',
                subtitle: 'Delivery queries, bottle exchange & refunds',
                onTap: () => context.push('/support'),
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.question_answer_outlined,
                title: 'Frequently Asked Questions',
                subtitle: 'Read our farm policies & delivery FAQs',
                onTap: () => context.push('/faqs'),
              ),
            ]),
            const SizedBox(height: 24),

            // Sign Out
            Center(
              child: TextButton.icon(
                onPressed: () {
                  ref.read(profileProvider.notifier).loginAsGuest();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Switched to Guest Browsing mode.'),
                    ),
                  );
                  context.go('/splash');
                },
                icon: const Icon(
                  Icons.logout,
                  color: AppColors.errorAlert,
                  size: 18,
                ),
                label: Text(
                  'Sign Out / Switch Mode',
                  style: AppTypography.labelMd(color: AppColors.errorAlert),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Heera Organics v1.0.0 • Naturally Grown, Honestly Delivered',
                style: AppTypography.labelSm(color: AppColors.mutedText)
                    .copyWith(fontSize: 10),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.borderSubtle, width: 1.0),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerLow,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primaryContainer, size: 20),
      ),
      title: Text(
        title,
        style: AppTypography.labelLg(color: AppColors.deepText),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySm(color: AppColors.mutedText),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.mutedText,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 68, color: AppColors.borderSubtle);
  }
}
