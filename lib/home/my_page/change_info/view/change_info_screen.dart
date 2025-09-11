import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/layout/test_layout.dart';

class ChangeInfoScreen extends ConsumerWidget {
  static String get routeName => '정보변경';

  const ChangeInfoScreen({super.key});


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return TestLayout(widgets: []);
  }
}
