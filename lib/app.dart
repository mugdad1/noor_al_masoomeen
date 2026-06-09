import 'package:flutter/material.dart';
import 'package:noor_al_masoomeen/screens/splash_screen.dart';
import 'package:noor_al_masoomeen/theme/app_theme.dart';
import 'package:noor_al_masoomeen/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'noor_al_masoomeen',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settings.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
