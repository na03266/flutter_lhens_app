import 'package:flutter/material.dart';

import '../../../common/compornts/tabbar/custom_tab.dart';

class NoticeScreen extends StatefulWidget {
  static String get routeName => '공지사항';

  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  // 샘플 데이터 (실제로는 API에서 가져올 데이터)
  final List<Map<String, dynamic>> listData = [
    {'id': 1, 'title': '공지사항 1', 'type': '내부 공지사항', 'content': '내부 공지사항 내용'},
    {'id': 2, 'title': '공지사항 2', 'type': '외부 공지사항', 'content': '외부 공지사항 내용'},
    {'id': 3, 'title': '공지사항 3', 'type': '내부 공지사항', 'content': '내부 공지사항 내용 2'},
    {'id': 4, 'title': '공지사항 4', 'type': '외부 공지사항', 'content': '외부 공지사항 내용 2'},
  ];
  
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = List.from(listData);
  }

  void _onTabFiltered(List<Map<String, dynamic>> filteredData) {
    setState(() {
      filteredList = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // 커스텀 탭바
        CustomTab(
          listData: listData,
          // onTabFiltered: (){},
        ),

        // 탭 내용
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      '해당하는 공지사항이 없습니다.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(
                            item['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            item['type'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () {
                            // 공지사항 상세 페이지로 이동
                            print('공지사항 상세: ${item['title']}');
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
