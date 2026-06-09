import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noor_al_masoomeen/providers/content_provider.dart';
import 'package:noor_al_masoomeen/screens/detail_screen.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
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
