import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noor_al_masoomeen/providers/content_provider.dart';
import 'package:noor_al_masoomeen/screens/detail_screen.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/utils/masoom_data.dart';
import 'package:noor_al_masoomeen/widgets/empty_state_widget.dart';
import 'package:noor_al_masoomeen/widgets/entry_card.dart';
import 'package:noor_al_masoomeen/widgets/loading_state_widget.dart';
import 'package:noor_al_masoomeen/widgets/search_bar_widget.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المكتبة'),
      ),
      body: Consumer<ContentProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              SearchBarWidget(
                onChanged: (query) => provider.search(query),
              ),
              _CategoryChips(
                selectedCategory: provider.selectedCategory,
                onSelected: (category) {
                  if (category == null) {
                    provider.clearCategory();
                  } else {
                    provider.setCategory(category);
                  }
                },
              ),
              _MasoomChips(
                selectedIndex: provider.selectedMasoomIndex,
                onSelected: (index) {
                  if (index == null) {
                    provider.clearMasoom();
                  } else {
                    provider.setMasoom(index);
                  }
                },
              ),
              Expanded(
                child: _buildBody(provider, context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(ContentProvider provider, BuildContext context) {
    if (provider.isLoading) {
      return const LoadingStateWidget();
    }

    if (provider.entries.isEmpty) {
      return const EmptyStateWidget(message: 'لا توجد نتائج');
    }

    return ListView.builder(
      itemCount: provider.entries.length,
      itemBuilder: (context, index) {
        final entry = provider.entries[index];
        return EntryCard(
          entry: entry,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(entry: entry),
              ),
            );
          },
        );
      },
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final EntryCategory? selectedCategory;
  final ValueChanged<EntryCategory?> onSelected;

  const _CategoryChips({
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip(context, 'الكل', null, selectedCategory == null),
            ...EntryCategory.values.map(
              (cat) => _buildChip(
                context,
                cat.labelAr,
                cat,
                selectedCategory == cat,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    EntryCategory? category,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(category),
      ),
    );
  }
}

class _MasoomChips extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int?> onSelected;

  const _MasoomChips({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip(context, 'الكل', null, selectedIndex == null),
            ...masoomNames.entries.map(
              (entry) => _buildChip(
                context,
                entry.value.ar,
                entry.key,
                selectedIndex == entry.key,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    int? index,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(index),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
