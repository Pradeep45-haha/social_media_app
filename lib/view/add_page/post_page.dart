import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/colors.dart';
import 'package:instagram_mmvm_dp_clone/view/mobile_layout/mobile_main_screen.dart';
import '../../../view_model/bloc/ui_bloc/bloc/ui_bloc.dart';


class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: BlocBuilder<UiBloc, UiState>(
          builder: (context, state) {
            if (state is PostSelectedState) {
              return Container(
                color: mobileBackgroundColor,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              BlocProvider.of<UiBloc>(context).add(
                                PostPostEvent(
                                  description: descriptionController.text,
                                  isPost: true,
                                  image: state.image!,
                                  childName: "posts",
                                ),
                                
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: BlocProvider.of<UiBloc>(context),
                                      child: const MobileMainScreen(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              "Post",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: BlocProvider.of<UiBloc>(context),
                                      child: const MobileMainScreen(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Image(
                          image: MemoryImage(
                            state.image!,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: TextField(
                            controller: descriptionController,
                            keyboardType: TextInputType.text,
                            maxLength: 5000,
                            maxLines: 8,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Share something about post",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                "No image selected",
              ),
            );
          },
        ),
      ),
    );
  }
}
