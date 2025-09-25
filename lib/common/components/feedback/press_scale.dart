import 'package:flutter/material.dart';

class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration downDuration;
  final Duration upDuration;

  const PressScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.985,
    this.downDuration = const Duration(milliseconds: 80),
    this.upDuration = const Duration(milliseconds: 150),
  });

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  double _scale = 1.0;
  Duration _duration = Duration.zero;

  void _down(_) {
    setState(() {
      _scale = widget.pressedScale;
      _duration = widget.downDuration;
    });
  }

  void _up([_]) {
    setState(() {
      _scale = 1.0;
      _duration = widget.upDuration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: _up,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _scale,
        duration: _duration,
        child: widget.child,
      ),
    );
  }
}
