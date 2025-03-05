import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/ui_folder/skeleton_folder/skeleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../global_folder/globals.dart';
import '../task_group_folder/task_group_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{

  bool dataGet = false;

  Future<void> getUserData() async{

  }

  Future<void> getTodayTasks() async{

  }

  Future<void> getToDoTasks() async{

  }

  Future<void> getInProgressTasks() async {

  }

  Future<void> getTasksGroups() async{

  }

  Future<void> initVoid() async{
    await getUserData();
    await getTodayTasks();
    await getToDoTasks();
    await getInProgressTasks();
    await getTasksGroups();
    setState(() {
      dataGet = false;
    });
  }

  Widget userRow(){
    return Container();
  }

  Widget todayProgress(){
    return Container();
  }

  Widget toDoTasks(){
    return Container();
  }

  Widget inProgressTasks(){
    return Container();
  }

  Widget tasksGroupsRow(){
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.task_groups,
          style: GoogleFonts.roboto(textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 28,
              letterSpacing: 0.01,
              decoration: TextDecoration.none
          )),
        ),
        const SizedBox(width: 10,),
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (BuildContext context) => TaskGroupScreen(id: null, creation: true,)),
            );
          },
          child: CircleAvatar(
            backgroundColor: colors.mainColor,
            radius: 16,
            child: FaIcon(FontAwesomeIcons.plus , color: Colors.white, size: 18,),
          ),
        )
      ],
    );
  }

  Widget tasksGroupsList(){
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initVoid();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width,
        height: height,
        color: colors.scaffoldColor,
        child: Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15,),
                  userRow(),
                  const SizedBox(height: 20,),
                  todayProgress(),
                  const SizedBox(height: 20,),
                  toDoTasks(),
                  const SizedBox(height: 20,),
                  inProgressTasks(),
                  const SizedBox(height: 20,),
                  tasksGroupsRow(),
                  const SizedBox(height: 20,),
                  tasksGroupsList(),
                  SizedBox(height: bottomNavBarHeight+40,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}