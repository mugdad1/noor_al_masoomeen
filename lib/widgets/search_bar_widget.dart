import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noor_al_masoomeen/utils/constants.dart';

class SearchBarWidget extends StatefulWidget {
  final String? initialQuery;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({super.key, this.initialQuery, this.onChanged});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(kSearchDebounce, () {
      widget.onChanged?.call(value);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'بحث...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'مسح البحث',
                  onPressed: () {
                    _controller.clear();
                    _debounce?.cancel();
                    widget.onChanged?.call('');
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: _onChanged,
      ),
    );
  }
}
