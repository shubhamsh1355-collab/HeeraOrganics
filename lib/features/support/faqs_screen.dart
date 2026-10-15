import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/category_chip.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/faq_item.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Freshness & Sourcing',
    'Delivery',
    'Dairy & Bottles',
    'Payments & Returns',
  ];

  @override
  Widget build(BuildContext context) {
    List<FaqItem> filteredFaqs = MockData.faqs;
    if (_selectedCategory != 'All') {
      filteredFaqs = MockData.faqs
          .where((f) => f.category == _selectedCategory)
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Frequently Asked Questions',
          style: AppTypography.headlineSm(),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: cat,
                    isSelected: _selectedCategory == cat,
                    onTap: () => setState(() => _selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // FAQ Accordion List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredFaqs.length,
              itemBuilder: (context, index) {
                final faq = filteredFaqs[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.whiteSurface,
                    borderRadius: AppRadii.radiusMd,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    iconColor: AppColors.primaryContainer,
                    collapsedIconColor: AppColors.mutedText,
                    title: Text(
                      faq.question,
                      style: AppTypography.titleCard(color: AppColors.deepText),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        child: Text(
                          faq.answer,
                          style: AppTypography.bodyMd(
                            color: AppColors.deepText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
