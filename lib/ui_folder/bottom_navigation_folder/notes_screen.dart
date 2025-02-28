import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data_class_folder/notes_folder/notes_data_class.dart';
import '../../global_folder/globals.dart';
import '../skeleton_folder/skeleton.dart';


class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen>{

  List<NotesDataClass> list = [];

  bool dataGet = false;

  void createNewTask(){
    print("create new task");
  }

  Widget notesList(double width){
    if(dataGet == false){
      return SizedBox(
        width: width,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 10,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index){
              return Padding(
                padding: (index==0)? EdgeInsets.zero : const EdgeInsets.only(top: 5),
                child: Skeleton(
                  width: width,
                  height: 125,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }
        ),
      );
    }
    else{
      if(list.isEmpty){
        return Text("list is empty");
      }
      else{
        return SizedBox(
          width: width,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: list.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    print("open task");
                  },
                  child: Padding(
                    padding: (index==0)? EdgeInsets.zero : const EdgeInsets.only(top: 5),
                    child: Container(),
                  ),
                );
              }
          ),
        );
      }
    }

  }

  Widget note(){
    return SizedBox();
  }

  Future<void> getNotes() async{
    print("notes get");
  }

  Future<void> initVoid() async{
    await getNotes();
    setState(() {
      dataGet = true;
    });
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
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.notes_string,
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
                              createNewTask();
                            },
                            child: CircleAvatar(
                              backgroundColor: colors.mainColor,
                              radius: 16,
                              child: FaIcon(FontAwesomeIcons.plus , color: Colors.white, size: 18,),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      notesList(width),
                      SizedBox(height: bottomNavBarHeight+10,)
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}