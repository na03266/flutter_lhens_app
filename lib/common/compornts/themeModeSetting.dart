import 'package:flutter/material.dart';

import '../../main.dart';

class ThemeModeSettingWidget extends StatelessWidget {
  const ThemeModeSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return Column(
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('라이트 모드'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null) themeModeNotifier.value = mode;
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('다크 모드'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null) themeModeNotifier.value = mode;
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('시스템 설정 따라가기'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (mode) {
                if (mode != null) themeModeNotifier.value = mode;
              },
            ),
          ],
        );
      },
    );
  }
}