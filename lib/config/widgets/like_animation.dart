import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

class LikeAnim extends StatefulWidget {
  final VoidCallback onTap;
  final bool animateLike;
  final bool isLiked;
  const LikeAnim(
      {required super.key,
      required this.onTap,
      required this.isLiked,
      required this.animateLike});

  @override
  State<LikeAnim> createState() => _LikeAnimState();
}

class _LikeAnimState extends State<LikeAnim>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  UiBloc? uiBloc;
  @override
  void initState() {
    uiBloc = BlocProvider.of<UiBloc>(context);
    animationController = AnimationController(
      lowerBound: 1,
      upperBound: 1.5,
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    animation = Tween<double>().animate(
      animationController,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  startAnimation() async {
    if (widget.animateLike) {
      await animationController.forward();
      await animationController.reverse();
      uiBloc!.tempAnimate[widget.key!] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    startAnimation();
    return Center(
      child: IconButton(
        onPressed: widget.onTap,
        icon: ScaleTransition(
          scale: animationController,
          // scale: animation,
          child: Icon(
            widget.isLiked ? Icons.favorite : Icons.favorite_border_outlined,
            size: 24,
            color: widget.isLiked ? Colors.red : Colors.white,
          ),
        ),
      ),
    );
  }
}
