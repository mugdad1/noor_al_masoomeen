import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_al_masoomeen/providers/content_provider.dart';
import 'package:noor_al_masoomeen/screens/library_screen.dart';
import 'package:noor_al_masoomeen/screens/favorites_screen.dart';
import 'package:noor_al_masoomeen/screens/about_screen.dart';
import 'package:noor_al_masoomeen/screens/settings_screen.dart';
import 'package:noor_al_masoomeen/screens/calendar_archive_screen.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/utils/constants.dart';
import 'package:noor_al_masoomeen/widgets/daily_entry_card.dart';
import 'package:noor_al_masoomeen/widgets/category_dialog.dart';
import 'package:noor_al_masoomeen/widgets/loading_state_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    LibraryScreen(),
    FavoritesScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'المكتبة',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: 'المفضلة',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'حول',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSavedCategory());
  }

  Future<void> _loadSavedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(kPrefsTodaysCategory);
    if (key == null) return;
    if (!mounted) return;
    try {
      final category = EntryCategory.fromKey(key);
      context.read<ContentProvider>().getDaily(DateTime.now(), category);
    } catch (_) {}
  }

  void _onCategoryPicked(EntryCategory category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefsTodaysCategory, category.key);
    if (mounted) {
      context.read<ContentProvider>().getDaily(DateTime.now(), category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نور المعصومين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'عشوائي',
            onPressed: () {
              context.read<ContentProvider>().getRandom();
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'أرشيف التقويم',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CalendarArchiveScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'الإعدادات',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ContentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingStateWidget();
          }
          if (provider.errorMessage != null && provider.dailyEntry == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }
          if (provider.dailyEntry == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'اختر فئة اليوم',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        showCategoryDialog(context, _onCategoryPicked);
                      },
                      child: const Text('اختيار فئة'),
                    ),
                  ],
                ),
              ),
            );
          }
          return SingleChildScrollView(
            child: DailyEntryCard(entry: provider.dailyEntry!),
          );
        },
      ),
    );
  }
}
