import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/compornts/board/board_img.dart';
import '../../common/compornts/board/board_list.dart';
import '../../drawer/notice/provider/notice_provider.dart';
import 'mydata.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'home';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyData(),
            HomeBoardList(),
            SizedBox(height: 20),
            HomeBoardImg(),
          ],
        ),
      ),
    );
  }
}

class HomeBoardList extends StatelessWidget {

  const HomeBoardList({super.key, });

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> listData = [];
    return BoardList(title: '공지사항', listData: listData);
  }
}

class HomeBoardImg extends StatelessWidget {
  HomeBoardImg({super.key});

  final List<Map<String, dynamic>> tempListData = [
    {
      'title': '2025 LH E&S교육',
      'date': '2025.05.25 ~ 2025. 06.15',
      'type': '교육',
    },
    {
      'title': '2025 LH 행상 안내',
      'date': '2025.05.25 ~ 2025. 06.15',
      'type': '행사',
    },
    {
      'title': '2025 LH 행상 안내',
      'date': '2025.05.25 ~ 2025. 06.15',
      'type': '행사',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BoardImg(title: '주요 일정', listData: tempListData);
  }
}
