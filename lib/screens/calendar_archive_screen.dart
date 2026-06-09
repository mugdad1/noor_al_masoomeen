import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:noor_al_masoomeen/utils/constants.dart';
import 'package:noor_al_masoomeen/providers/content_provider.dart';
import 'package:noor_al_masoomeen/screens/detail_screen.dart';

class CalendarArchiveScreen extends StatefulWidget {
  const CalendarArchiveScreen({super.key});

  @override
  State<CalendarArchiveScreen> createState() => _CalendarArchiveScreenState();
}

class _CalendarArchiveScreenState extends State<CalendarArchiveScreen> {
  Map<String, String> _dailyHistory = {};
  int _displayYear = 0;
  int _displayMonth = 0;
  int _daysInMonth = 30;
  int _weekdayOffset = 0;
  List<int> _activeDays = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(kPrefsDailyHistory) ?? '{}';
    final map = Map<String, String>.from(jsonDecode(raw) as Map);

    final now = DateTime.now();
    final hNow = HijriCalendar.fromDate(now);
    if (!mounted) return;
    setState(() {
      _dailyHistory = map;
      _displayYear = hNow.hYear;
      _displayMonth = hNow.hMonth;
      _computeMonth(hNow.hYear, hNow.hMonth);
    });
  }

  void _computeMonth(int year, int month) {
    final h = HijriCalendar();
    final gregFirst = h.hijriToGregorian(year, month, 1);
    _weekdayOffset = gregFirst.weekday % 7;
    _daysInMonth = h.getDaysInMonth(year, month);

    final active = <int>[];
    for (int d = 1; d <= _daysInMonth; d++) {
      final greg = h.hijriToGregorian(year, month, d);
      final key = _dateKey(greg);
      if (_dailyHistory.containsKey(key)) {
        active.add(d);
      }
    }
    _activeDays = active;
  }

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, "0")}'
        '-${date.month.toString().padLeft(2, "0")}'
        '-${date.day.toString().padLeft(2, "0")}';
  }

  void _goToMonth(int year, int month) {
    setState(() {
      _displayYear = year;
      _displayMonth = month;
      _computeMonth(year, month);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_displayYear == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('الأرشيف')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final monthNames = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
    ];

    final hNow = HijriCalendar.fromDate(DateTime.now());
    final isCurrentMonth = _displayYear == hNow.hYear && _displayMonth == hNow.hMonth;

    return Scaffold(
      appBar: AppBar(
        title: Text('${monthNames[_displayMonth - 1]} $_displayYear'),
        actions: [
          if (!isCurrentMonth)
            IconButton(
              icon: const Icon(Icons.today),
              tooltip: 'اليوم',
              onPressed: () {
                _goToMonth(hNow.hYear, hNow.hMonth);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_right),
                tooltip: 'الشهر السابق',
                onPressed: () {
                  final prevM = _displayMonth > 1 ? _displayMonth - 1 : 12;
                  final prevY = _displayMonth > 1 ? _displayYear : _displayYear - 1;
                  _goToMonth(prevY, prevM);
                },
              ),
              Text(
                '${monthNames[_displayMonth - 1]} $_displayYear',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                tooltip: 'الشهر التالي',
                onPressed: () {
                  final nextM = _displayMonth < 12 ? _displayMonth + 1 : 1;
                  final nextY = _displayMonth < 12 ? _displayYear : _displayYear + 1;
                  _goToMonth(nextY, nextM);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'].map((d) =>
                    Expanded(
                      child: Center(
                        child: Text(d, style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                  ).toList(),
                ),
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1,
                  children: [
                    for (int i = 0; i < _weekdayOffset; i++)
                      const SizedBox.shrink(),
                    for (int d = 1; d <= _daysInMonth; d++)
                      _DayCell(
                        day: d,
                        hasEntry: _activeDays.contains(d),
                        onTap: () => _openEntry(d),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            'الأيام الملونة تحتوي على إدخال',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _openEntry(int day) {
    final h = HijriCalendar();
    final greg = h.hijriToGregorian(_displayYear, _displayMonth, day);
    final key = _dateKey(greg);
    final entryId = _dailyHistory[key];
    if (entryId != null) {
      final provider = context.read<ContentProvider>();
      final entry = provider.getById(entryId);
      if (entry != null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetailScreen(entry: entry)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('هذا الإدخال غير متوفر في المكتبة')),
        );
      }
    }
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool hasEntry;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.hasEntry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: hasEntry ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: hasEntry ? theme.colorScheme.primaryContainer : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              color: hasEntry ? theme.colorScheme.onPrimaryContainer : null,
            ),
          ),
        ),
      ),
    );
  }
}
