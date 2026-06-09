import 'package:flutter/material.dart';
import 'package:noor_al_masoomeen/utils/categories.dart';

void showCategoryDialog(
  BuildContext context,
  void Function(EntryCategory) onPicked,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => AlertDialog(
      title: const Text('اختر فئة اليوم'),
      content: const Text('اختر الفئة لعرض إدخال اليوم'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onPicked(EntryCategory.manqabah);
          },
          child: Text(
            EntryCategory.manqabah.labelAr,
            style: TextStyle(color: EntryCategory.manqabah.badgeColor),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onPicked(EntryCategory.hadith);
          },
          child: Text(
            EntryCategory.hadith.labelAr,
            style: TextStyle(color: EntryCategory.hadith.badgeColor),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onPicked(EntryCategory.khisal);
          },
          child: Text(
            EntryCategory.khisal.labelAr,
            style: TextStyle(color: EntryCategory.khisal.badgeColor),
          ),
        ),
      ],
    ),
  );
}
