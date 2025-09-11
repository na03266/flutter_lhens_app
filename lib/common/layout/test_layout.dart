import 'package:flutter/material.dart';

class TestLayout extends StatelessWidget {
  final List<Function()> widgets;

  const TestLayout({super.key, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(
            widgets.length,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => widgets[index](),
                child: Text('test'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
