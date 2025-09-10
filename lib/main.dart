import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common/provider/go_router.dart';


// 전역 변수
ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: Size(480, 1080),
        minTextAdapt: true,
        builder: (context, child) {
          return const MyApp();
        },
      ),
    ),
  );
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: Size(480, 1080),
      minTextAdapt: true,
      child: ValueListenableBuilder<ThemeMode>(
          valueListenable: themeModeNotifier,
          builder: (context, themeMode, _) {
            return MaterialApp.router(
              routerConfig: router,
              themeMode: themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
                  return Center(
                    child: Container(
                      width: 480,
                      height: 1080,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: child!,
                      ),
                    ),
                  );
                }
                return child!;
              },
            );
          }
      ),
    );
  }
}

