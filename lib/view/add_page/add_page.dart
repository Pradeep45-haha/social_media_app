import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/colors.dart';
import 'package:instagram_mmvm_dp_clone/view/add_page/post_page.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        BlocProvider.of<UiBloc>(context).add(
          AppPageViewChangedEvent(
            currentPageIndx: 0,
            pageController: pageController,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AddPageView(
            pageController: pageController,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingBottomNavigationBar(
                pageController: pageController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingBottomNavigationBar extends StatefulWidget {
  final PageController pageController;
  const FloatingBottomNavigationBar({super.key, required this.pageController});

  @override
  State<FloatingBottomNavigationBar> createState() =>
      _FloatingBottomNavigationBarState();
}

class _FloatingBottomNavigationBarState
    extends State<FloatingBottomNavigationBar> {
  double offset = 0;
  double dragStart = 0;
  Size widgetSize = Size.zero;
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        color: secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width / 3,
        right: MediaQuery.of(context).size.width / 10,
      ),
      height: 30,
      child: Row(
        key: key,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          BlocBuilder<UiBloc, UiState>(
            builder: (context, state) {
              if (state is AddPageViewChangedState) {
                if (state.num == 0) {
                  return TextButton(
                    child: const Text(
                      "POST",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      BlocProvider.of<UiBloc>(context).add(
                        AppPageViewChangedEvent(
                          currentPageIndx: 0,
                          pageController: widget.pageController,
                        ),
                      );
                    },
                  );
                }
              }

              return TextButton(
                child: const Text(
                  "POST",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  BlocProvider.of<UiBloc>(context).add(
                    AppPageViewChangedEvent(
                      currentPageIndx: 0,
                      pageController: widget.pageController,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
          BlocBuilder<UiBloc, UiState>(
            builder: (context, state) {
              if (state is AddPageViewChangedState) {
                if (state.num == 1) {
                  return TextButton(
                    child: const Text(
                      "STORY",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      BlocProvider.of<UiBloc>(context).add(
                        AppPageViewChangedEvent(
                          currentPageIndx: 1,
                          pageController: widget.pageController,
                        ),
                      );
                    },
                  );
                }
              }
              return TextButton(
                child: const Text(
                  "STORY",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  BlocProvider.of<UiBloc>(context).add(
                    AppPageViewChangedEvent(
                      currentPageIndx: 1,
                      pageController: widget.pageController,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
          BlocBuilder<UiBloc, UiState>(
            builder: (context, state) {
              if (state is AddPageViewChangedState) {
                if (state.num == 2) {
                  return TextButton(
                    child: const Text(
                      "REEL",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      BlocProvider.of<UiBloc>(context).add(
                        AppPageViewChangedEvent(
                          currentPageIndx: 2,
                          pageController: widget.pageController,
                        ),
                      );
                    },
                  );
                }
              }
              return TextButton(
                child: const Text(
                  "REEL",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  BlocProvider.of<UiBloc>(context).add(
                    AppPageViewChangedEvent(
                      currentPageIndx: 2,
                      pageController: widget.pageController,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
          BlocBuilder<UiBloc, UiState>(
            builder: (context, state) {
              if (state is AddPageViewChangedState) {
                if (state.num == 3) {
                  return TextButton(
                    child: const Text(
                      "LIVE",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      BlocProvider.of<UiBloc>(context).add(
                        AppPageViewChangedEvent(
                          currentPageIndx: 3,
                          pageController: widget.pageController,
                        ),
                      );
                    },
                  );
                }
              }
              return TextButton(
                child: const Text(
                  "LIVE",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  BlocProvider.of<UiBloc>(context).add(
                    AppPageViewChangedEvent(
                      currentPageIndx: 3,
                      pageController: widget.pageController,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

class AddPageView extends StatefulWidget {
  final PageController pageController;
  const AddPageView({super.key, required this.pageController});

  @override
  State<AddPageView> createState() => AddPageViewState();
}

class AddPageViewState extends State<AddPageView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiBloc, UiState>(
      builder: (context, state) {
        return PageView(
          controller: widget.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            PostPage(),
            Center(
              child: Text("2"),
            ),
            Center(
              child: Text("3"),
            ),
            Center(
              child: Text("4"),
            ),
          ],
        );
      },
    );
  }
}

Size getWidgetSize(GlobalKey key) {
  RenderBox size = key.currentContext?.findRenderObject() as RenderBox;
  return size.size;
}
