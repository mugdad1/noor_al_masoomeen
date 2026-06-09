import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noor_al_masoomeen/providers/settings_provider.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';
import 'package:noor_al_masoomeen/screens/about_screen.dart';
import 'package:noor_al_masoomeen/services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: const [
          _ThemeSection(),
          _LangOrderSection(),
          _FontSizeSection(),
          _NotificationSection(),
          Divider(),
          _AboutTile(),
        ],
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('المظهر', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('النظام')),
                  ButtonSegment(value: ThemeMode.light, label: Text('فاتح')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('داكن')),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (selected) {
                  settings.setTheme(selected.first);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LangOrderSection extends StatelessWidget {
  const _LangOrderSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ترتيب اللغة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<LangOrder>(
                segments: const [
                  ButtonSegment(value: LangOrder.arFirst, label: Text('العربية أولاً')),
                  ButtonSegment(value: LangOrder.enFirst, label: Text('الإنجليزية أولاً')),
                ],
                selected: {settings.langOrder},
                onSelectionChanged: (selected) {
                  settings.setLangOrder(selected.first);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FontSizeSection extends StatelessWidget {
  const _FontSizeSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('حجم الخط', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<double>(
                segments: const [
                  ButtonSegment(value: 1.0, label: Text('صغير')),
                  ButtonSegment(value: 1.15, label: Text('متوسط')),
                  ButtonSegment(value: 1.3, label: Text('كبير')),
                ],
                selected: {settings.fontSize},
                onSelectionChanged: (selected) {
                  settings.setFontSize(selected.first);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection();

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الإشعارات اليومية', style: Theme.of(context).textTheme.titleMedium),
            const ListTile(
              title: Text('الإشعارات غير متوفرة في الويب'),
              enabled: false,
            ),
          ],
        ),
      );
    }

    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الإشعارات اليومية', style: Theme.of(context).textTheme.titleMedium),
              SwitchListTile(
                title: const Text('تفعيل الإشعارات'),
                subtitle: const Text('تذكير يومي بقراءة اليوم'),
                value: settings.notifEnabled,
                onChanged: (value) {
                  settings.setNotifEnabled(value);
                  if (value) {
                    NotificationService().scheduleDaily(
                      settings.notifTime.hour,
                      settings.notifTime.minute,
                    );
                  } else {
                    NotificationService().cancel();
                  }
                },
              ),
              if (settings.notifEnabled)
                ListTile(
                  title: Text(
                    'وقت الإشعار: ${settings.notifTime.hour.toString().padLeft(2, '0')}:${settings.notifTime.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: settings.notifTime,
                    );
                    if (picked != null) {
                      await settings.setNotifTime(picked);
                      await NotificationService().scheduleDaily(
                        picked.hour,
                        picked.minute,
                      );
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('حول التطبيق'),
      trailing: const Icon(Icons.chevron_left),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AboutScreen()),
        );
      },
    );
  }
}
