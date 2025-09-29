import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'selector_item.dart';

class Selector<G> extends StatefulWidget {
  final String label;
  final List<G> items;
  final G? selected;
  final String Function(G) getLabel;
  final ValueChanged<G> onSelected;

  const Selector({
    super.key,
    required this.label,
    required this.items,
    this.selected,
    required this.onSelected,
    required this.getLabel,
  });

  @override
  State<Selector<G>> createState() => _SelectorState<G>();
}

class _SelectorState<G> extends State<Selector<G>> {
  final LayerLink _link = LayerLink();
  final GlobalKey _anchorKey = GlobalKey();

  bool _open = false;
  OverlayEntry? _entry;

  @override
  void deactivate() {
    // Route pop 등 트리에서 분리될 때 먼저 오버레이 제거
    _hide();
    super.deactivate();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  void _toggle() => _open ? _hide() : _show();

  void _hide() {
    final entry = _entry;
    if (entry != null) {
      try {
        if (entry.mounted) entry.remove();
      } catch (_) {}
      _entry = null;
    }
    if (mounted && _open) {
      setState(() => _open = false);
    } else {
      _open = false;
    }
  }

  void _show() {
    if (_open) return; // 중복 방지
    final ctx = _anchorKey.currentContext;
    if (ctx == null || !mounted) return;

    final box = ctx.findRenderObject() as RenderBox;
    final Size size = box.size;
    final borderColor = AppColors.border;

    _entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 바깥 탭 닫기
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hide,
              child: const SizedBox.expand(),
            ),
          ),
          // 앵커 바로 아래 리스트 (1px 겹쳐서 경계선 이중표시 방지)
          CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            offset: Offset(0, size.height - 1),
            child: Material(
              color: Colors.transparent,
              child: _OpenTransition(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.width,
                    maxHeight: 197.h,
                  ),
                  child: _DropdownList<G>(
                    width: size.width,
                    borderColor: borderColor,
                    items: widget.items,
                    selected: widget.selected,
                    onSelected: (v) {
                      widget.onSelected(v);
                      _hide();
                    },
                    getLabel: widget.getLabel,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_entry!);
    if (mounted) setState(() => _open = true);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.border;
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          key: _anchorKey,
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: _open
                ? BorderRadius.vertical(top: Radius.circular(8.r))
                : BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.selected == null
                      ? widget.label
                      : widget.getLabel(widget.selected as G),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.pr15.copyWith(
                    color: widget.selected != null
                        ? AppColors.text
                        : AppColors.placeholder,
                  ),
                ),
              ),
              Transform.rotate(
                angle: _open ? 3.14159 : 0,
                child: Assets.icons.arrowDown.svg(width: 24.w, height: 24.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpenTransition extends StatelessWidget {
  final Widget child;

  const _OpenTransition({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      builder: (context, t, c) {
        final dy = (1 - t) * -4.0;
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, dy), child: c),
        );
      },
      child: child,
    );
  }
}

class _DropdownList<T> extends StatefulWidget {
  final double width;
  final Color borderColor;
  final List<T> items;
  final T? selected;
  final String Function(T) getLabel;
  final ValueChanged<T> onSelected;

  const _DropdownList({
    required this.width,
    required this.borderColor,
    required this.items,
    this.selected,
    required this.onSelected,
    required this.getLabel,
  });

  @override
  State<_DropdownList<T>> createState() => _DropdownListState<T>();
}

class _DropdownListState<T> extends State<_DropdownList<T>> {
  final ScrollController _ctl = ScrollController();
  List<T> _visible = [];

  @override
  void initState() {
    super.initState();
    _loadInitial();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToSelected();
    });
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  void _loadInitial() {
    int selectedIndex = 0;
    if (widget.selected != null) {
      selectedIndex = widget.items.indexOf(widget.selected!);
      if (selectedIndex < 0) selectedIndex = 0;
    }
    _visible = widget.items;
  }

  void _scrollToSelected() {
    if (widget.selected == null || !_ctl.hasClients) return;
    final i = _visible.indexOf(widget.selected!);
    if (i >= 0) {
      final h = 48.0.h;
      final off = i * h;
      _ctl.jumpTo(off < 0 ? 0 : off);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        // Uniform Border + 하단 라운드
        border: Border.all(color: widget.borderColor),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        child: ListView.builder(
          controller: _ctl,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: _visible.length,
          itemBuilder: (context, index) {
            final item = _visible[index];
            return SelectorItem(
              text: widget.getLabel(item),
              isSelected: item == widget.selected,
              isLast: index == _visible.length - 1,
              onTap: () => widget.onSelected(item),
            );
          },
        ),
      ),
    );
  }
}
