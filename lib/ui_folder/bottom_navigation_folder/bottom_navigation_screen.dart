import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/calendar_screen.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/create_task_screen.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/home_screen.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/notes_screen.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/user_screen.dart';
import 'package:material_to_do/global_folder/colors.dart' as colors;

import '../../global_folder/globals.dart';

class BottomNavBar extends StatefulWidget {
  final int? position;
  const BottomNavBar({super.key, required this.position});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int selected = 0;
  final PageController controller = PageController();

  Widget navBarItem(int index, IconData icon, double width) {
    return GestureDetector(
      onTap: (){
        onItemTapped(index);
      },
      child: SizedBox(
        width: (width-32)/5,
        height: 32,
        child: Align(
          alignment: Alignment.center,
          child: FaIcon(
            icon,
            color: selected == index ? colors.scaffoldColor : colors.mainColor.withAlpha(100),
            size: 28,
          ),
        )
      ),
    );
  }

  Future<void> initVoid() async{
    if(widget.position!=null){selected = widget.position!;}
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVoid();
  }

  void onItemTapped(int index) {
    if (index == selected) return;
    controller.jumpToPage(index);
    setState(() {
      selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Creates a notch for the FAB
        notchMargin: 10.0, // Space between the FAB and the notch
        color: colors.palete8,
        height: bottomNavBarHeight,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              navBarItem(0, FontAwesomeIcons.house, width),
              navBarItem(1, FontAwesomeIcons.calendar, width),
              const SizedBox(width: 70),
              navBarItem(2, FontAwesomeIcons.noteSticky, width),
              navBarItem(3, FontAwesomeIcons.userSecret, width),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) => CreateTaskScreen(position: selected,)),
          );
        },
        backgroundColor: colors.mainColor,
        shape: const CircleBorder(),
        child: const FaIcon(FontAwesomeIcons.plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            selected = index;
          });
        },
        children: const [
          HomeScreen(),
          CalendarScreen(),
          NotesScreen(),
          UserScreen(),
        ],
      ),
    );
  }
}
