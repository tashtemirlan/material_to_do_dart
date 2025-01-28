import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/calendar_screen.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/create_task_screen.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/home_screen.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/notes_screen.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/user_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar>{
  int selected = 0;
  bool heart = false;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconSize: 22,
          iconStyle: IconStyle.animated
        ),
        items: [
          BottomBarItem(
            icon: const FaIcon(
              FontAwesomeIcons.house,
            ),
            selectedIcon: const FaIcon(FontAwesomeIcons.house),
            selectedColor: colors.mainColor,
            unSelectedColor: Colors.grey,
            showBadge: false,
            title: Text(""),
          ),
          BottomBarItem(
            icon: Padding(
              padding: EdgeInsets.only(right: 15),
              child: const FaIcon(FontAwesomeIcons.calendar),
            ),
            selectedIcon: const FaIcon(FontAwesomeIcons.calendar),
            selectedColor: colors.mainColor,
            unSelectedColor: Colors.grey,
            title: const Text(""),
          ),
          BottomBarItem(
            icon: Padding(
                padding: EdgeInsets.only(left: 15),
                child: const FaIcon(FontAwesomeIcons.noteSticky),
            ),
            selectedIcon: const FaIcon(FontAwesomeIcons.noteSticky),
            selectedColor: colors.mainColor,
            unSelectedColor: Colors.grey,
            title: const Text(""),
          ),
          BottomBarItem(
            icon: const FaIcon(FontAwesomeIcons.userSecret),
            selectedIcon: const FaIcon(FontAwesomeIcons.userSecret),
            selectedColor: colors.mainColor,
            unSelectedColor: Colors.grey,
            title: const Text(""),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Create note");
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => const CreateTaskScreen(),
          ));
        },
        backgroundColor: colors.mainColor,
        shape: CircleBorder(),
        child: const FaIcon(FontAwesomeIcons.plus, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: const [
            HomeScreen(),
            CalendarScreen(),
            NotesScreen(),
            UserScreen(),
          ],
        ),
      ),
    );
  }
  
}