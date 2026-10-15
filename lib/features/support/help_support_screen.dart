import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/profile_repository.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        title: Text(
          'Help & Support',
          style: AppTypography.headlineSm(
            color: AppColors.primary,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.1),
              child: Text(
                profileState.profile.name.isNotEmpty
                    ? profileState.profile.name[0]
                    : 'U',
                style: const TextStyle(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search & Hub Status Header Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'SEDAM ROAD HUB • KALABURAGI',
                        style: AppTypography.labelSm(
                          color: AppColors.secondary,
                        ).copyWith(
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'How can our farm team support you?',
                    style: AppTypography.headlineLgMobile(
                      color: AppColors.primary,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Instant delivery resolution, harvest guarantees & farmstead inquiries.',
                    style: AppTypography.bodySm(color: AppColors.mutedText),
                  ),
                  const SizedBox(height: 12),
                  // Search Input
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppColors.mutedText,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Search issues, farm questions, bottle return...',
                            style: AppTypography.bodySm(
                              color: AppColors.mutedText,
                            ).copyWith(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.mic,
                          color: AppColors.mutedText,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Active Order Assistance Spotlight (#HO-89241)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Meta Bar
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: AppColors.softGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.local_shipping,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'ACTIVE HARVEST DISPATCH',
                                        style: AppTypography.labelSm(
                                          color: AppColors.secondary,
                                        ).copyWith(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '• #HO-89241',
                                        style: AppTypography.labelSm(
                                          color: AppColors.deepText,
                                        ).copyWith(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Arriving today by 3:45 PM',
                                    style: AppTypography.headlineSm(
                                      color: AppColors.primary,
                                    ).copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'On Route',
                              style: AppTypography.labelSm(
                                color: AppColors.deepText,
                              ).copyWith(fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Produce Thumbnail Summary
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Image.network(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCL4R_SufVh79gWHFBgWfp1uvsFR3ycJre1e6AjLip77Aa4kuZEefLa4UsR28MGlWaM6mcmnRTYq3Fe_xbEWc8u_yWfcWm7T6GggK2DMaayt5i51OPADhYfqYahY9GDutNH8cgPguS4BB29t2FmokArt_3Q6MTwK4xwr2Gfl7bEO7t4AO1z3FtLK3iJTO-4KMlTyRb3QtpueTLgCz53-QObaA7Trc2jzAXsoVEOCDHlWMfXlTRemtSC',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sedam Sunrise Basket (4 items)',
                                      style: AppTypography.titleCard(
                                        color: AppColors.deepText,
                                      ).copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'Fresh A2 Milk (1L), Palak, Country Tomatoes',
                                      style: AppTypography.bodySm(
                                        color: AppColors.mutedText,
                                      ).copyWith(fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹348',
                                style: AppTypography.headlineSm(
                                  color: AppColors.primary,
                                ).copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'NEED ASSISTANCE WITH THIS BATCH?',
                            style: AppTypography.labelSm(
                              color: AppColors.mutedText,
                            ).copyWith(
                              fontSize: 10,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 3 Quick Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  icon: Icons.schedule,
                                  label: 'Delay Delivery',
                                  iconColor: AppColors.primary,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Request sent: Rider requested to hold until 4:30 PM',
                                        ),
                                        backgroundColor: AppColors.primaryContainer,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildActionButton(
                                  icon: Icons.edit_note,
                                  label: 'Driver Note',
                                  iconColor: AppColors.primary,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Note added: Please leave with gate security',
                                        ),
                                        backgroundColor: AppColors.primaryContainer,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildActionButton(
                                  icon: Icons.report_problem,
                                  label: 'Report Issue',
                                  iconColor: AppColors.errorAlert,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Opening produce guarantee photo verification form...',
                                        ),
                                        backgroundColor: AppColors.primaryContainer,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Direct Farmstead Care (3 Cards)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Direct Farmstead Care',
                    style: AppTypography.headlineSm(
                      color: AppColors.primary,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'No robotic queues',
                    style: AppTypography.labelSm(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // 1. Sedam Coordinator Somnath K.
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBbJLu6BREtZ4B11XM2NtSR77Phrfa9wWEnpb5VMnmkPGnAc_onFCaw2PKNvokfHhqGc7ocyJgASzR1p8erBvJFphb66bqZWTx-SF7-fNLRT2B7kQEw_9S-esQTd_IAQx4uxgDARK1-a4kT_Kv1qBGqYZeLkA8T6ID5iQOu7_O8heU3_tVwfs0yDMlJk6K7y_FeCQen5uONmbkxAFf_wN0ARsfadNUM4-_x5n03adOowbHUBwiQ4Kgh',
                                        width: 46,
                                        height: 46,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppColors.softGreen,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Somnath K.',
                                          style: AppTypography.titleCard(
                                            color: AppColors.deepText,
                                          ).copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 1.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.softGreen,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'On Hub Duty',
                                            style: AppTypography.labelSm(
                                              color: AppColors.primary,
                                            ).copyWith(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Sedam Cold-Chain Dispatcher',
                                      style: AppTypography.bodySm(
                                        color: AppColors.mutedText,
                                      ).copyWith(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '9 AM – 8 PM',
                                style: AppTypography.labelSm(
                                  color: AppColors.secondary,
                                ).copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Talk directly to our Kalaburagi route team for urgent address edits, gate drop coordination, or driver rerouting.',
                          style: AppTypography.bodySm(
                            color: AppColors.deepText,
                          ).copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Dialing Sedam Hub: +91 8472 258900'),
                                      backgroundColor: AppColors.primaryContainer,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.call, size: 16),
                                label: const Text('Call Hub'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.softGreen,
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Opening WhatsApp Farm Chat with Somnath K.',
                                      ),
                                      backgroundColor: AppColors.primaryContainer,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.chat, size: 16),
                                label: const Text('WhatsApp'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. AI Botanist & Sourcing Assistant
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.psychology_alt,
                                size: 24,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Heera Botanist & Trace Bot',
                                        style: AppTypography.titleCard(
                                          color: AppColors.deepText,
                                        ).copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceContainer,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '24/7 AI',
                                          style: AppTypography.labelSm(
                                            color: AppColors.mutedText,
                                          ).copyWith(fontSize: 9),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Organic certifications, harvest dates & origins',
                                    style: AppTypography.bodySm(
                                      color: AppColors.mutedText,
                                    ).copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ask: "When was today\'s spinach harvested?" or "Show NPOP certification for Aland curd."',
                          style: AppTypography.bodySm(
                            color: AppColors.deepText,
                          ).copyWith(
                            fontStyle: FontStyle.italic,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.surfaceContainerLow,
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => context.push('/support/chat'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Start Farm Knowledge Chat',
                                  style: AppTypography.labelMd(
                                    color: AppColors.primary,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Produce Quality Guarantee
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.assignment_return,
                                size: 24,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Produce Quality Guarantee',
                                    style: AppTypography.titleCard(
                                      color: AppColors.deepText,
                                    ).copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Zero-argument replacement or instant wallet credit',
                                    style: AppTypography.bodySm(
                                      color: AppColors.mutedText,
                                    ).copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Received broken bottle seals, wilted greens, or missing items? Upload a quick snap for auto-approval.',
                          style: AppTypography.bodySm(
                            color: AppColors.deepText,
                          ).copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryContainer,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Opening instant claim replacement ticket wizard...',
                                  ),
                                  backgroundColor: AppColors.primaryContainer,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_photo_alternate, size: 16),
                            label: const Text('Claim Replacement / Wallet Credit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4. Farm & Service Guides (2x2 Grid)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Farm & Service Guides',
                    style: AppTypography.headlineSm(
                      color: AppColors.primary,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '4 key topics',
                    style: AppTypography.labelSm(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.15,
                children: [
                  _buildGuideCard(
                    context,
                    icon: Icons.liquor,
                    title: 'A2 Bottle Return',
                    desc: 'Earn ₹20/bottle credit on doorstep pickup cycle.',
                    iconBg: AppColors.surfaceContainer,
                    onTap: () => context.push('/faqs'),
                  ),
                  _buildGuideCard(
                    context,
                    icon: Icons.eco,
                    title: 'Harvest Guarantee',
                    desc: 'Zero chemical promise & 100% replacement policy.',
                    iconBg: AppColors.softGreen,
                    onTap: () => context.push('/faqs'),
                  ),
                  _buildGuideCard(
                    context,
                    icon: Icons.doorbell,
                    title: 'Gate Drop Delivery',
                    desc: 'Safe no-contact insulated porch boxes.',
                    iconBg: AppColors.secondaryContainer,
                    onTap: () => context.push('/faqs'),
                  ),
                  _buildGuideCard(
                    context,
                    icon: Icons.verified,
                    title: 'Organic Verification',
                    desc: 'View NPOP certificates & soil test reports.',
                    iconBg: AppColors.surfaceContainerHigh,
                    onTap: () => context.push('/faqs'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.labelSm(
                color: AppColors.deepText,
              ).copyWith(fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String desc,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.whiteSurface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleCard(
                    color: AppColors.deepText,
                  ).copyWith(fontWeight: FontWeight.w700, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  desc,
                  style: AppTypography.bodySm(
                    color: AppColors.mutedText,
                  ).copyWith(fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Read Guide',
                  style: AppTypography.labelSm(
                    color: AppColors.primary,
                  ).copyWith(fontWeight: FontWeight.w700, fontSize: 10),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_forward, size: 11, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
