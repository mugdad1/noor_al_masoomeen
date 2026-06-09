# نور المعصومين — Noor al-Masoomeen

A Flutter mobile app delivering daily manaqib, hadith, and khisal from the **14 Masoomeen (AS)** — Prophet Muhammad (SAWA), Lady Fatima al-Zahra (SA), and the Twelve Imams (AS).

**🔒 100% offline. Zero network access. No internet permission. No analytics. No tracking.**

## Features

- **Daily Entry** — Pick a category (منقبة / حديث / خصال) and get a daily spiritual reading
- **330 Entries** — 110 per category, full Arabic tashkeel, with English translations
- **Full Library** — Browse, search (with tashkeel-stripping), and filter by category
- **Favorites** — Save entries for quick access
- **Calendar Archive** — Hijri calendar grid of past daily entries
- **Dark Mode** — Light/dark/system theme with M3 green accent
- **Language Swap** — Full Arabic or full English display, toggled in Settings
- **Font Sizing** — Small / Medium / Large presets
- **Notifications** — Optional daily reminder at a chosen time
- **Share & Copy** — Share entries or copy to clipboard

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.x / Dart 3.x |
| State Management | Provider |
| Local Storage | SharedPreferences |
| Data | Bundled JSON (330 entries) |
| Calendar | Hijri (Umm al-Qura) |
| Notifications | flutter_local_notifications + timezone |
| Navigation | Material 3 NavigationBar |
| Network | **NONE — fully offline app** |

## Screens

1. **Home** — Daily entry with category picker, random button
2. **Library** — Full entry list with search + category chips
3. **Favorites** — Saved entries
4. **About** — App info and credits
5. **Settings** — Theme, language order, font size, notifications
6. **Detail** — Full entry with share, copy, favorite
7. **Onboarding** — 3-slide intro (first launch only)
8. **Calendar Archive** — Hijri month grid of past entries

## Getting Started

```bash
git clone https://github.com/mugdad1/noor_al_masoomeen.git
cd noor_al_masoomeen
flutter pub get
flutter run
```

## Build

```bash
# Android (split-per-abi)
flutter build apk --split-per-abi --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Privacy

- No internet permission in AndroidManifest.xml
- No http, dio, firebase, or analytics packages
- All data is bundled in the APK
- Favorites and settings stored locally in SharedPreferences
- No data ever leaves the device

## License

MIT
