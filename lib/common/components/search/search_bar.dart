import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted; // 아이콘 탭/키보드 제출 시 호출
  final String hintText;

  const SearchBar({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.hintText = '검색어를 입력하세요',
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: focused ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focus,
              controller: widget.controller,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              style: AppTextStyles.pr15.copyWith(color: AppColors.text),
              cursorColor: AppColors.secondary,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTextStyles.pr16.copyWith(
                  color: AppColors.placeholder,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                widget.onSubmitted?.call(widget.controller.text.trim()),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Assets.icons.search.svg(width: 20.w, height: 20.w),
            ),
          ),
        ],
      ),
    );
  }
}
