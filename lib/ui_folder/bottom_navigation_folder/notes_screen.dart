import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/ui_folder/notes_folder/note_page.dart';

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

  void createNewTask() async{
    final result = await Navigator.of(context).push(
      CupertinoPageRoute(builder: (BuildContext context) => NoteScreen(id: null, creation: true,)),
    );
    if(result!=null){
      setState(() {
        dataGet = false;
      });
      await getNotes();
      setState(() {
        dataGet = true;
      });
    }
  }

  void readTask(int ID) async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute(builder: (BuildContext context) => NoteScreen(id: ID, creation: false,)),
    );
    if(result!=null){
      setState(() {
        dataGet = false;
      });
      await getNotes();
      setState(() {
        dataGet = true;
      });
    }
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
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: width,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.notes_list_empty_string,
                  style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                      letterSpacing: 0.01,
                      decoration: TextDecoration.none
                  )),
                ),
              ),
            ),
        );
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
                    readTask(list[index].notesDataClassId!);
                  },
                  child: Padding(
                    padding: (index==0)? EdgeInsets.zero : const EdgeInsets.only(top: 10),
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list[index].title!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    letterSpacing: 0.01,
                                    decoration: TextDecoration.none
                                )),
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                list[index].description!,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    letterSpacing: 0.01,
                                    decoration: TextDecoration.none
                                )),
                              )
                            ],
                          ),
                      ),
                    ),
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
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    dio.options.responseType = ResponseType.plain;
    //set Dio response =>
    try{
      final response = await dio.get(endpoints.allNotesGetEndpoint);
      print(response);
      if(response.statusCode == 200){
        final result = notesDataClassFromJson(response.toString());
        list = result;
      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
          print(toParseData);
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.cant_get_data,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          );
        }
      }
    }
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
              child: RefreshIndicator(
                onRefresh: () async{
                  await getNotes();
                },
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
                          SizedBox(height: bottomNavBarHeight+40,)
                        ],
                      ),
                    ),
                  ),
              ),
            )
        )
    );
  }
}