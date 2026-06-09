import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noor_al_masoomeen/providers/favorites_provider.dart';
import 'package:noor_al_masoomeen/screens/detail_screen.dart';
import 'package:noor_al_masoomeen/widgets/empty_state_widget.dart';
import 'package:noor_al_masoomeen/widgets/entry_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, child) {
          if (provider.favoriteEntries.isEmpty) {
            return const EmptyStateWidget(
              message: 'لا توجد مفضلات بعد. اضغط على النجمة لحفظ الإدخال.',
            );
          }

          return ListView.builder(
            itemCount: provider.favoriteEntries.length,
            itemBuilder: (context, index) {
              final entry = provider.favoriteEntries[index];
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
        },
      ),
    );
  }
}
