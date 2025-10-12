import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'selector_item.dart';

class Selector<G> extends StatefulWidget {
  final String? hint;
  final List<G> items;
  final G? selected;
  final String Function(G) getLabel;
  final ValueChanged<G> onSelected;

  const Selector({
    super.key,
    required this.items,
    this.selected,
    required this.onSelected,
    required this.getLabel,
    this.hint,
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
    _entry?.remove();
    _entry = null;
    if (mounted && _open) setState(() => _open = false);
  }

  void _show() {
    if (_open) return;
    final ctx = _anchorKey.currentContext;
    if (ctx == null || !mounted) return;

    final box = ctx.findRenderObject() as RenderBox;
    final size = box.size;

    _entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hide,
            ),
          ),
          CompositedTransformFollower(
            link: _link,
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
                    borderColor: AppColors.border,
                    items: widget.items,
                    selected: widget.selected,
                    getLabel: widget.getLabel,
                    onSelected: (v) {
                      widget.onSelected(v);
                      _hide();
                    },
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
    final displayText = widget.selected == null
        ? (widget.hint ?? '')
        : widget.getLabel(widget.selected as G);

    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          key: _anchorKey,
          height: 48.h,
          padding: EdgeInsets.only(left: 16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: _open
                ? BorderRadius.vertical(top: Radius.circular(8.r))
                : BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.pr15.copyWith(
                    color: widget.selected != null
                        ? AppColors.text
                        : AppColors.placeholder,
                  ),
                ),
              ),
              SizedBox(
                width: 40.w,
                height: 48.h,
                child: Center(
                  child: Transform.rotate(
                    angle: _open ? 3.14159 : 0,
                    child: Assets.icons.arrowDown.svg(
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ),
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
      builder: (context, t, c) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, (1 - t) * -4.0), child: c),
      ),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    if (widget.selected == null || !_ctl.hasClients) return;
    final i = widget.items.indexOf(widget.selected as T);
    if (i >= 0) _ctl.jumpTo(i * 48.0.h);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
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
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return SelectorItem(
              text: widget.getLabel(item),
              isSelected: item == widget.selected,
              isLast: index == widget.items.length - 1,
              onTap: () => widget.onSelected(item),
            );
          },
        ),
      ),
    );
  }
}
