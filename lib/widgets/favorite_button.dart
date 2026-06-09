import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noor_al_masoomeen/providers/favorites_provider.dart';

class FavoriteButton extends StatelessWidget {
  final String entryId;

  const FavoriteButton({super.key, required this.entryId});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favorites, _) {
        final isFav = favorites.isFavorite(entryId);
        return IconButton(
          icon: Icon(
            isFav ? Icons.star : Icons.star_outline,
            color: isFav ? Colors.amber : null,
          ),
          tooltip: 'المفضلة',
          onPressed: () => favorites.toggle(entryId),
        );
      },
    );
  }
}
