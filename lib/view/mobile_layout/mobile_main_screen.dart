import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/colors.dart';
import 'package:instagram_mmvm_dp_clone/view/accounts_page/accounts_page.dart';
import 'package:instagram_mmvm_dp_clone/view/add_page/add_page.dart';
import 'package:instagram_mmvm_dp_clone/view/home_page/home_page.dart';
import 'package:instagram_mmvm_dp_clone/view/search_page/search_page.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';


class MobileMainScreen extends StatelessWidget {
  const MobileMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    UiBloc uiBloc = BlocProvider.of<UiBloc>(context);
    return Scaffold(
      bottomNavigationBar: BlocBuilder<UiBloc, UiState>(
        builder: (context, state) {
          return CupertinoTabBar(
            onTap: (value) {
              BlocProvider.of<UiBloc>(context).add(
                BottomNavigationBarChangedEvent(
                  currentPageIndx: value,
                  pageController: pageController,
                ),
              );
            },
            activeColor: Colors.white,
            inactiveColor: secondaryColor,
            currentIndex: uiBloc.selectedPage,
            backgroundColor: mobileBackgroundColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                backgroundColor: primaryColor,
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                backgroundColor: primaryColor,
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.slow_motion_video),
                backgroundColor: primaryColor,
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                backgroundColor: primaryColor,
                label: "",
              ),
            ],
          );
        },
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          BlocProvider.value(
            value: BlocProvider.of<UiBloc>(context),
            child: const HomePage(),
          ),
          BlocProvider.value(
            value: BlocProvider.of<UiBloc>(context),
            child: const SearchPage(),
          ),
          BlocProvider.value(
            value: BlocProvider.of<UiBloc>(context),
            child: const AddPage(),
          ),
          const Center(
            child: Text("Reels"),
          ),
          const AccountPage(),
        ],
      ),
    );
  }
}
