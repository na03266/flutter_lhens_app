import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/layout/test_layout.dart';
import '../../../common/provider/app_bar_title_provider.dart';
import '../change_info/view/change_info_screen.dart';

class MyPageScreen extends ConsumerWidget {
  static String get routeName => '마이페이지';

  const MyPageScreen({super.key});

  // 정보 변경 페이지 이동
  routeChangeInfo(BuildContext context, WidgetRef ref) {
    context.pushNamed(ChangeInfoScreen.routeName);
    ref.read(appBarTitleProvider.notifier).state = ChangeInfoScreen.routeName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TestLayout(widgets: [() => routeChangeInfo(context, ref)]);
  }
}
