import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Help & Support Hub', style: AppTypography.headlineSm()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Callout Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.softGreen.withValues(alpha: 0.5),
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.softGreen),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.whiteSurface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Farm Care Team',
                          style: AppTypography.titleCard(),
                        ),
                        Text(
                          'Available daily 6:00 AM to 8:30 PM for harvest and delivery queries.',
                          style: AppTypography.bodySm(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Common Issues
            Text('Quick Help by Topic', style: AppTypography.labelLg()),
            const SizedBox(height: 10),
            _buildIssueCard(
              context,
              icon: Icons.delivery_dining,
              title: 'Morning Delivery Status',
              desc: 'Check estimated arrival time for your route',
              onTap: () => context.push('/orders'),
            ),
            _buildIssueCard(
              context,
              icon: Icons.water_drop,
              title: 'Glass Milk Bottle Pickup',
              desc: 'Bottle exchange rules & empty bottle collection',
              onTap: () => context.push('/faqs'),
            ),
            _buildIssueCard(
              context,
              icon: Icons.restart_alt,
              title: 'Freshness Guarantee & Returns',
              desc: 'Instant refund or replacement for damaged items',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Support ticket created. Our team will contact you within 15 minutes.',
                    ),
                    backgroundColor: AppColors.primaryContainer,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Interactive Channels
            Text('Contact Channels', style: AppTypography.labelLg()),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteSurface,
                borderRadius: AppRadii.radiusLg,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFF25D366),
                    ),
                    title: Text(
                      'WhatsApp Farm Support',
                      style: AppTypography.labelLg(),
                    ),
                    subtitle: Text(
                      '+91 8472 234567 • Quickest replies',
                      style: AppTypography.bodySm(),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Opening WhatsApp care channel (simulated).',
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.primaryContainer,
                    ),
                    title: Text(
                      'Direct Phone Care',
                      style: AppTypography.labelLg(),
                    ),
                    subtitle: Text(
                      'Toll Free: 1800-419-HEERA',
                      style: AppTypography.bodySm(),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dialing care center (simulated).'),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(
                      Icons.psychology_outlined,
                      color: AppColors.primaryContainer,
                    ),
                    title: Text(
                      'AI Farm Assistant',
                      style: AppTypography.labelLg(),
                    ),
                    subtitle: Text(
                      'Instant answers on recipes & seasonality',
                      style: AppTypography.bodySm(),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/farm-assistant'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLow,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryContainer),
        ),
        title: Text(title, style: AppTypography.labelLg()),
        subtitle: Text(desc, style: AppTypography.bodySm()),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: onTap,
      ),
    );
  }
}
