import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noor_al_masoomeen/app.dart';
import 'package:noor_al_masoomeen/data/content_repository.dart';
import 'package:noor_al_masoomeen/data/favorites_service.dart';
import 'package:noor_al_masoomeen/providers/content_provider.dart';
import 'package:noor_al_masoomeen/providers/favorites_provider.dart';
import 'package:noor_al_masoomeen/providers/settings_provider.dart';
import 'package:noor_al_masoomeen/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContentProvider(ContentRepository())),
        ChangeNotifierProvider(
          create: (context) {
            final contentProvider = context.read<ContentProvider>();
            return FavoritesProvider(
              FavoritesService(),
              () => contentProvider.allEntries,
            );
          },
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const App(),
    ),
  );
}
