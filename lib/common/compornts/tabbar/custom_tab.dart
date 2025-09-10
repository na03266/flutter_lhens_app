import 'package:flutter/material.dart';

import '../../const/appBorderRadius.dart';
import '../../const/appColorPicker.dart';
import '../../const/appPadding.dart';

class CustomTab extends StatefulWidget {
  final List<Map<String, dynamic>> listData;
  final EdgeInsets paddingSize;
  final Color selectedBorderColor;
  final Color unselectedBorderColor;
  final Color selectedBackgroundColor;
  final Color unselectedBackgroundColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color tabBackgroundColor;
  final BorderRadius borderRadius;
  final MainAxisAlignment alignment;
  final bool isExpanded;

  const CustomTab({
    super.key,
    required this.listData,
    this.paddingSize = AppPaddings.tab,
    this.selectedBorderColor = AppColors.primaryColor,
    this.unselectedBorderColor = AppColors.tabBorderColor,
    this.selectedBackgroundColor = const Color(0xFF1F4068), // 진한 파란색
    this.unselectedBackgroundColor = Colors.black,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = const Color(0xFF9E9E9E), // 연한 회색
    this.tabBackgroundColor = Colors.white,
    this.borderRadius = AppBorderRadius.radius9,
    this.alignment = MainAxisAlignment.start,
    this.isExpanded = true,
  });

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> with SingleTickerProviderStateMixin {
  late List<String> _tabs;
  late List<Map<String, dynamic>> _filteredList;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    // 탭 구성 (전체 + 고유 type)
    _tabs = ['전체'];
    _tabs.addAll(
      widget.listData
          .map((e) => e['type'] as String?)
          .whereType<String>()
          .toSet()
          .toList(),
    );

    _filterList();
  }

  void _filterList() {
    final selectedTab = _tabs[_selectedTabIndex];
    if (selectedTab == '전체') {
      _filteredList = List.from(widget.listData);
    } else {
      _filteredList =
          widget.listData.where((item) => item['type'] == selectedTab).toList();
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _filterList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
          mainAxisAlignment: widget.alignment,
          children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;

          final tabContent = GestureDetector(
            onTap: () => _onTabChanged(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: widget.paddingSize,
              decoration: BoxDecoration(
                color: isSelected
                    ? widget.selectedBackgroundColor
                    : widget.unselectedBackgroundColor,
                border:  Border.all(
                  color: isSelected
                      ? widget.selectedBorderColor
                      : widget.unselectedBorderColor,
                  width: 1,
                ),
                borderRadius: widget.borderRadius,
              ),
              child: Text(
                _tabs[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? widget.selectedTextColor
                      : widget.unselectedTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );

          if (widget.isExpanded) {
            return Expanded(child: tabContent);
          } else {
            return tabContent;
          }

        }),
      ),
    );
  }
}
