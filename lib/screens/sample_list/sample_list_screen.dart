import 'package:flutter/material.dart';

import '../../data/letter_samples_data.dart';
import '../../models/letter_category.dart';
import '../../models/letter_sample.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sample_list_tile.dart';
import '../sample_detail/sample_detail_screen.dart';

/// The sample library: search + category filter + a scrollable list of
/// letter samples. Reachable from the home screen's category grid (with a
/// category preselected) or from "すべて見る".
class SampleListScreen extends StatefulWidget {
  const SampleListScreen({super.key, this.initialCategory, this.onSelect});

  final LetterCategory? initialCategory;

  /// When provided, tapping a sample calls this instead of pushing the
  /// detail screen — used when picking a reference sample for a letter
  /// that's already being composed.
  final ValueChanged<LetterSample>? onSelect;

  @override
  State<SampleListScreen> createState() => _SampleListScreenState();
}

class _SampleListScreenState extends State<SampleListScreen> {
  final _searchController = TextEditingController();
  LetterCategory? _selectedCategory;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LetterSample> get _filteredSamples {
    return letterSamples.where((sample) {
      final matchesCategory =
          _selectedCategory == null || sample.category == _selectedCategory;
      final matchesQuery =
          _query.isEmpty ||
          sample.title.contains(_query) ||
          sample.description.contains(_query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final samples = _filteredSamples;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '文例一覧',
          style: theme.appBarTheme.titleTextStyle?.copyWith(fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: '文例を検索する',
                hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
                  fontSize: 13,
                ),
                prefixIcon: const Icon(Icons.search, size: 20),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: LetterCategory.values.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _CategoryTab(
                    label: 'すべて',
                    selected: _selectedCategory == null,
                    onTap: () => setState(() => _selectedCategory = null),
                  );
                }
                final category = LetterCategory.values[index - 1];
                return _CategoryTab(
                  label: category.label,
                  selected: _selectedCategory == category,
                  onTap: () => setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: samples.isEmpty
                ? Center(
                    child: Text(
                      '該当する文例が見つかりませんでした',
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.xl,
                    ),
                    itemCount: samples.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final sample = samples[index];
                      return SampleListTile(
                        sample: sample,
                        onTap: () {
                          if (widget.onSelect != null) {
                            widget.onSelect!(sample);
                            return;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SampleDetailScreen(sample: sample),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: selected ? colorScheme.primary : colorScheme.outline,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: 13,
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
