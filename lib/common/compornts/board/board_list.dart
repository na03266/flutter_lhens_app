import 'package:flutter/material.dart';

import '../../const/appColorPicker.dart';
import '../../const/appPadding.dart';

class BoardList extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> listData;

  const BoardList({
    super.key,
    required this.title,
    required this.listData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 타이틀 + 아이콘 영역 (Padding으로 감싸기)
        Padding(
          padding: AppPaddings.titleCustom,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
              Image.asset('asset/image/plus.png', width: 24, height: 24),
            ],
          ),
        ),

        // 구분선
        Padding(
          padding: AppPaddings.titleCustom,
          child: const Divider(height: 1, thickness: 1, color: AppColors.tableLineColor,),
        ),

        // 리스트 아이템이 있을 때만 표시
        if (listData.isNotEmpty) ...[
          ...listData.map((item) => Padding(
            padding: AppPaddings.titleCustom,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (item['notice'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                        ),
                        // TODO 공지 이미지 교체 필요
                        child: const Text(
                        'NEW',
                        style: TextStyle(color: AppColors.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['title'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: item['notice'] == true ? FontWeight.bold : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ),
                    Text(item['date'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.tableLineColor),
              ],
            ),
          )).toList(),
        ] else ...[
          // 데이터가 없을 때 표시할 메시지
          Padding(
            padding: AppPaddings.titleCustom,
            child: const Center(
              child: Text(
                '공지사항이 없습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
