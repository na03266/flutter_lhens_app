import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../gen/assets.gen.dart';
import 'filter_menu.dart';

class FilterSearchBar<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) getLabel;
  final T selected;
  final ValueChanged<T> onSelected;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted; // 아이콘/키보드 제출 시 실행
  final String hintText;

  const FilterSearchBar({
    super.key,
    required this.items,
    required this.getLabel,
    required this.selected,
    required this.onSelected,
    this.controller,
    this.onSubmitted,
    this.hintText = '검색어를 입력하세요',
  });

  @override
  State<FilterSearchBar<T>> createState() => _FilterSearchBarState<T>();
}

class _FilterSearchBarState<T> extends State<FilterSearchBar<T>> {
  final LayerLink _link = LayerLink();
  final GlobalKey _anchorKey = GlobalKey();
  OverlayEntry? _entry;
  bool _open = false;

  late final FocusNode _focus;
  TextEditingController? _internal; // widget.controller 없을 때만 사용

  bool get _focused => _focus.hasFocus || _open;

  double get _innerLPadding => 16.w;

  double get _gapBelow => 2.h;

  TextEditingController get _controller =>
      widget.controller ?? (_internal ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _hide(fromDispose: true);
    _focus.dispose();
    _internal?.dispose();
    super.dispose();
  }

  void _toggle() => _open ? _hide() : _show();

  void _hide({bool fromDispose = false}) {
    try {
      _entry?.remove();
    } catch (_) {}
    _entry = null;
    if (!fromDispose && mounted) setState(() => _open = false);
    if (mounted) FocusScope.of(context).unfocus(); // 포커스/보더 상태 통일
  }

  void _show() {
    if (_open) return;
    final ctx = _anchorKey.currentContext;
    final overlay = Overlay.of(context);
    if (ctx == null || overlay == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final triggerSize = box.size;

    _entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(child: GestureDetector(onTap: _hide)),
          CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            offset: Offset(
              -_innerLPadding + 3.w,
              triggerSize.height + _gapBelow + 15.h,
            ),
            child: FilterMenu<T>(
              width: triggerSize.width,
              items: widget.items,
              selected: widget.selected,
              getLabel: widget.getLabel,
              onSelected: (v) {
                widget.onSelected(v);
                _hide();
              },
            ),
          ),
        ],
      ),
    );

    overlay.insert(_entry!);
    setState(() => _open = true);
  }

  void _submit(String v) {
    widget.onSubmitted?.call(v.trim());
    FocusScope.of(context).unfocus(); // 제출 후 키보드 닫기
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.getLabel(widget.selected);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: double.infinity,
      height: 48.h,
      padding: EdgeInsets.only(left: _innerLPadding),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: _focused ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          // 필터 트리거
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 96.w),
            child: CompositedTransformTarget(
              link: _link,
              child: GestureDetector(
                key: _anchorKey,
                onTap: _toggle,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 64.w,
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.pr15.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Transform.rotate(
                      angle: _open ? 3.1416 : 0,
                      child: Assets.icons.arrowDown.svg(
                        width: 16.w,
                        height: 16.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 검색 입력
          Expanded(
            child: TextField(
              focusNode: _focus,
              controller: _controller,
              autofocus: false,
              textInputAction: TextInputAction.search,
              onSubmitted: _submit,
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
                suffixIcon: GestureDetector(
                  onTap: () => _submit(_controller.text),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Assets.icons.search.svg(),
                    ),
                  ),
                ),
                suffixIconConstraints: BoxConstraints.tightFor(
                  width: 44.w,
                  height: 44.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
