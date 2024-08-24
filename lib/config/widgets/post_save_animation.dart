import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

class PostSaveAnimation extends StatefulWidget {
  const PostSaveAnimation({super.key});

  @override
  State<PostSaveAnimation> createState() => _PostSaveAnimationState();
}

class _PostSaveAnimationState extends State<PostSaveAnimation> {
 
  @override
  Widget build(BuildContext context) {
    UiBloc uiBloc = BlocProvider.of<UiBloc>(context);
    return BlocBuilder<UiBloc, UiState>(
      builder: (context, state) {
        return Icon(
          uiBloc.isPostSaved[widget.key] == true
              ? Icons.bookmark
              : Icons.bookmark_border,
          color: Colors.white,
        );
      },
    );
  }
}
