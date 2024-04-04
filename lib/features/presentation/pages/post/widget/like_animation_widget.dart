import 'package:flutter/material.dart';

class LikeAnimationWidget extends StatefulWidget {
  const LikeAnimationWidget(
      {super.key,
      required this.child,
      required this.duration,
      required this.isLikeAnimating,
      this.onLikeFinish});

  final Widget child;
  final Duration duration;
  final bool isLikeAnimating;
  final VoidCallback? onLikeFinish;

  @override
  State<LikeAnimationWidget> createState() => _LikeAnimationWidgetState();
}

class _LikeAnimationWidgetState extends State<LikeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(animationController);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LikeAnimationWidget oldWidget) {
    if (widget.isLikeAnimating != oldWidget.isLikeAnimating) {
      beginLikeAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  void beginLikeAnimation() async {
    if (widget.isLikeAnimating) {
      await animationController.forward();
      await animationController.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
      if (widget.onLikeFinish != null) {
        widget.onLikeFinish!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
