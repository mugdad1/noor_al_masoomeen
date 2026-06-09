import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حول'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mosque, size: 64),
            const SizedBox(height: 16),
            Text(
              'نور المعصومين',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('الإصدار 1.0.0'),
            const SizedBox(height: 24),
            const Text('صنع بحب لأهل البيت (عليهم السلام)'),
          ],
        ),
      ),
    );
  }
}
