import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/home/component/event_section.dart';
import 'package:lhens_app/home/component/notice_section.dart';
import 'package:lhens_app/home/component/greeting_section.dart';

class HomeScreen extends ConsumerWidget {
  static String get routeName => 'home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _HeaderShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const GreetingSection(),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 14.h)),
          const SliverToBoxAdapter(child: NoticeSection()),
          SliverToBoxAdapter(child: SizedBox(height: 14.h)),
          const SliverToBoxAdapter(child: EventSection()),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      ),
    );
  }
}

class _HeaderShell extends StatelessWidget {
  final Widget child;

  const _HeaderShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
