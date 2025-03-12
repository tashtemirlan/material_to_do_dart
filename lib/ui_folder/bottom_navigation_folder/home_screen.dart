import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:material_to_do/data_class_folder/user_folder/user_data_class.dart';
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;
import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/ui_folder/skeleton_folder/skeleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/ui_folder/task_group_folder/task_group_detail_screen.dart';

import '../../data_class_folder/task_group_folder/task_groups_data_class.dart';
import '../../data_class_folder/tasks_folder/date_tasks_data_class.dart';
import '../../data_class_folder/tasks_folder/to_do_tasks_data_class.dart';
import '../../global_folder/globals.dart';
import '../task_folder/task_screen.dart';
import '../task_group_folder/task_group_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{

  bool dataGet = false;

  List<TaskGroupsDataClass> listTaskGroups = [];
  bool anyToDoTasks = true;
  bool anyInProgressTasks = true;
  double percentageUserTodayCompleted = 0;

  UserDataClass? user;

  List<TaskDate>  listTaskDate = [];
  List<TodoTasksDataClass> listToDoTasks = [];
  List<TodoTasksDataClass> listInProgressToDoTasks = [];


  Future<void> getUserData() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);

    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    //set Dio response =>
    try{
      final response = await dio.get(endpoints.userInfoGetEndpoint);
      if(response.statusCode == 200){
        final result = userDataClassFromJson(response.toString());
        user = result;
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

  Future<void> getTodayTasks() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    dio.options.responseType = ResponseType.plain;
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //set Dio response =>
    try{
      final response = await dio.get(
        "${endpoints.taskByDateGetEndpoint}?finish_date=$formattedDate"
      );
      print("Response for today tasks : $response");
      if(response.statusCode == 200){
        final result = dateTasksDataClassFromJson(response.toString());
        int completedTasks = 0;
        if(result.tasks!.isNotEmpty){
          listTaskDate = result.tasks!;
          for(int a=0; a< result.tasks!.length; a++){
            if(result.tasks![a].status == "COMPLETED"){
              completedTasks++;
            }
          }
          percentageUserTodayCompleted = completedTasks / result.tasks!.length;
        }
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

  Future<void> getToDoTasks() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    dio.options.responseType = ResponseType.plain;
    //set Dio response =>
    try{
      final response = await dio.get(endpoints.toDOTasksGroupGetEndpoint);
      print("Response for to do tasks : $response");
      if(response.statusCode == 200){
        if(response.data == "null"){
         //cause we don't have any tasks now then we should :
          anyToDoTasks = false;
        }
        else{
          final result = todoTasksDataClassFromJson(response.toString());
          listToDoTasks = result;
          anyToDoTasks = true;
        }
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

  Future<void> getInProgressTasks() async {
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    dio.options.responseType = ResponseType.plain;
    //set Dio response =>
    try{
      final response = await dio.get(endpoints.inProgressTasksGroupGetEndpoint);
      print("Response for in progress tasks : $response");
      if(response.statusCode == 200){
        if(response.data == "null"){
          //cause we don't have any tasks now then we should :
          anyInProgressTasks = false;
        }
        else{
          //Same answer as for to do type so we use same parser
          final result = todoTasksDataClassFromJson(response.toString());
          listInProgressToDoTasks = result;
          anyInProgressTasks = true;
        }
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

  Future<void> getTasksGroups() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    dio.options.responseType = ResponseType.plain;
    //set Dio response =>
    try{
      final response = await dio.get(endpoints.allTaskGroupsGetEndpoint);
      if(response.statusCode == 200){
        final result = taskGroupsDataClassFromJson(response.toString());
        listTaskGroups = result;
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
    await getUserData();
    await getTodayTasks();
    await getToDoTasks();
    await getInProgressTasks();
    await getTasksGroups();
    setState(() {
      dataGet = true;
    });
  }

  Future<void> update() async{
    setState(() {
      dataGet = false;
    });
    await getUserData();
    await getTodayTasks();
    await getToDoTasks();
    await getInProgressTasks();
    await getTasksGroups();
    setState(() {
      dataGet = true;
    });
  }

  Widget userRow(double width){
    if(dataGet == false){
      return Row(
        children: [
          Skeleton(
            width: 64,
            height: 64,
            style: SkeletonStyle.circle,
          ),
          const SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.welcome_string,
                style: GoogleFonts.roboto(textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    letterSpacing: 0.01,
                    decoration: TextDecoration.none
                )),
              ),
              const SizedBox(height: 8,),
              Skeleton(
                width: width/2,
                height: 28,
                borderRadius: BorderRadius.circular(10),
              )
            ],
          )
        ],
      );
    }
    else{
      return Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CachedNetworkImage(
              imageUrl: "${endpoints.mainPath}/${user!.image!}",
              progressIndicatorBuilder: (context, url, downloadProgress) {
                return Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    color: Colors.grey.shade200,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
              imageBuilder: (context, imageProvider) {
                return ClipOval(
                  child: InstaImageViewer(
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.welcome_string,
                style: GoogleFonts.roboto(textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    letterSpacing: 0.01,
                    decoration: TextDecoration.none
                )),
              ),
              const SizedBox(height: 8,),
              Text(
                user!.fullName!,
                style: GoogleFonts.roboto(textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    letterSpacing: 0.01,
                    decoration: TextDecoration.none
                )),
              )
            ],
          )
        ],
      );
    }
  }

  String getStageCompletion(double percentage){
    if(percentage == 0){
      return AppLocalizations.of(context)!.zero_stage_string;
    }
    else if(percentage <30){
      return AppLocalizations.of(context)!.first_stage_string;
    }
    else if(percentage < 50){
      return AppLocalizations.of(context)!.second_stage_string;
    }
    else if(percentage < 70){
      return AppLocalizations.of(context)!.third_stage_string;
    }
    else{
      return AppLocalizations.of(context)!.fourth_stage_string;
    }
  }

  Widget todayProgress(double width){
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: colors.mainColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getStageCompletion(percentageUserTodayCompleted),
                    style: GoogleFonts.roboto(textStyle: TextStyle(
                        color: colors.secondHelpColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        letterSpacing: 0.01,
                        decoration: TextDecoration.none
                    )),
                  ),
                ],
              ),
              Spacer(),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: colors.secondHelpColor,
                      backgroundColor: colors.helpColor,
                      value: (percentageUserTodayCompleted == 0 && listTaskDate.isEmpty)? 1 : percentageUserTodayCompleted,
                    ),
                  ),
                  Center(
                      child: Text(
                        "${(percentageUserTodayCompleted*100).toInt()}%",
                        style: GoogleFonts.roboto(textStyle: TextStyle(
                            color: colors.secondHelpColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            letterSpacing: 0.01,
                            decoration: TextDecoration.none
                        )),
                      )
                  ),
                ],
              )
            ],
          ),
      ),
    );
  }

  Widget createIcon(int groupID){
    TaskGroupsDataClass? ts;
    for(int a=0 ; a<listTaskGroups.length; a++){
      if(listTaskGroups[a].id == groupID){
        ts = listTaskGroups[a];
        break;
      }
    }
    if(ts !=null){
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
            color: hexToColor(ts.backgroundColor!),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Align(
          alignment: Alignment.center,
          child: FaIcon(IconData(
            ts.iconData!,
            fontFamily: 'FontAwesomeSolid',
            fontPackage: 'font_awesome_flutter',
          ), color: hexToColor(ts.iconColor!), size: 16,),
        ),
      );
    }
    else{
      return const SizedBox();
    }
  }

  Widget toDoTasks(double width){
    if(anyToDoTasks){
      if(dataGet == false){
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(10, (index) {
              return Padding(
                padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(left: 20),
                child: Skeleton(
                  width: width*0.7,
                  height: 125,
                  borderRadius: BorderRadius.circular(25),
                ),
              );
            }),
          ),
        );
      }
      else{
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listToDoTasks.asMap().entries.map((entry){
              int index = entry.key;
              return GestureDetector(
                onTap: () async{
                  final result = await Navigator.of(context).push(
                    CupertinoPageRoute(builder: (BuildContext context) => ViewTaskScreen(ID: listToDoTasks[index].id!,)),
                  );
                  if(result!=null){
                    await update();
                  }
                },
                child: Padding(
                  padding: (index==0)? EdgeInsets.zero : const EdgeInsets.only(left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: colors.todoStatusAdditional,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width/2,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width/2 - 40,
                                    child: Text(
                                      listToDoTasks[index].taskGroupName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(textStyle: TextStyle(
                                          color: colors.black2,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          letterSpacing: 0.01,
                                          decoration: TextDecoration.none
                                      )),
                                    ),
                                  ),
                                  Spacer(),
                                  createIcon(listToDoTasks[index].taskGroupId!)
                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),
                            SizedBox(
                              width: width/2,
                              height: 40,
                              child: Text(
                                listToDoTasks[index].title!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    letterSpacing: 0.01,
                                    decoration: TextDecoration.none
                                )),
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }
    }
    else{
      return const SizedBox();
    }
  }

  Widget inProgressTasks(double width){
    if(anyInProgressTasks){
      if(dataGet == false){
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(10, (index) {
              return Padding(
                padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(left: 20),
                child: Skeleton(
                  width: width*0.7,
                  height: 125,
                  borderRadius: BorderRadius.circular(25),
                ),
              );
            }),
          ),
        );
      }
      else{
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listInProgressToDoTasks.asMap().entries.map((entry){
              int index = entry.key;
              return GestureDetector(
                onTap: () async{
                  final result = await Navigator.of(context).push(
                    CupertinoPageRoute(builder: (BuildContext context) => ViewTaskScreen(ID: listInProgressToDoTasks[index].id!,)),
                  );
                  if(result!=null){
                    await update();
                  }
                },
                child: Padding(
                  padding: (index==0)? EdgeInsets.zero : const EdgeInsets.only(left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: colors.inProgressStatusAdditional,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width/2,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width/2 - 40,
                                    child: Text(
                                      listInProgressToDoTasks[index].taskGroupName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(textStyle: TextStyle(
                                          color: colors.black2,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          letterSpacing: 0.01,
                                          decoration: TextDecoration.none
                                      )),
                                    ),
                                  ),
                                  Spacer(),
                                  createIcon(listInProgressToDoTasks[index].taskGroupId!)
                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),
                            SizedBox(
                              width: width/2,
                              height: 40,
                              child: Text(
                                listInProgressToDoTasks[index].title!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    letterSpacing: 0.01,
                                    decoration: TextDecoration.none
                                )),
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }
    }
    else{
      return const SizedBox();
    }
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
          onTap: () async{
            final result = await Navigator.of(context).push(
              CupertinoPageRoute(builder: (BuildContext context) => TaskGroupScreen(id: null, creation: true,)),
            );
            if(result!=null){
              setState(() {
                dataGet = false;
              });
              await getTasksGroups();
              setState(() {
                dataGet = true;
              });
            }
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

  // Convert a Hex string to Color
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add full opacity if only RGB is provided
    }
    int a = int.parse(hex.substring(0, 2), radix: 16);
    int r = int.parse(hex.substring(2, 4), radix: 16);
    int g = int.parse(hex.substring(4, 6), radix: 16);
    int b = int.parse(hex.substring(6, 8), radix: 16);
    return Color.fromRGBO(r, g, b, a / 255.0);
  }

  Widget tasksGroupsList(double width){
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
      if(listTaskGroups.isEmpty){
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            width: width,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.no_any_task_group_string,
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
              itemCount: listTaskGroups.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index){
                IconData ic = IconData(
                    listTaskGroups[index].iconData!,
                    fontFamily: 'FontAwesomeSolid',
                    fontPackage: 'font_awesome_flutter',
                );
                return GestureDetector(
                  onTap: () async{
                    final result = await Navigator.of(context).push(
                        CupertinoPageRoute(builder: (BuildContext context) => TaskGroupDetailScreen(id: listTaskGroups[index].id!)));
                    if(result!=null){
                      await update();
                    }
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: hexToColor(listTaskGroups[index].backgroundColor!),
                                borderRadius: BorderRadius.circular(13)
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: FaIcon(ic, color: hexToColor(listTaskGroups[index].iconColor!), size: 28,),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            SizedBox(
                                width: width/3,
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listTaskGroups[index].name!, overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                          letterSpacing: 0.01,
                                          decoration: TextDecoration.none
                                      )),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      listTaskGroups[index].description!, overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          letterSpacing: 0.01,
                                          decoration: TextDecoration.none
                                      )),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      "${listTaskGroups[index].totalTasks} ${AppLocalizations.of(context)!.tasks_string}" ,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(textStyle: TextStyle(
                                          color: colors.black2,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          letterSpacing: 0.01,
                                          decoration: TextDecoration.none
                                      )),
                                    ),
                                  ],
                                )
                            ),
                            const Spacer(),
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    color: hexToColor(listTaskGroups[index].iconColor!),
                                    backgroundColor: hexToColor(listTaskGroups[index].backgroundColor!),
                                    value: (listTaskGroups[index].completionRate! ==0 && listTaskGroups[index].totalTasks==0) ? 1 : listTaskGroups[index].completionRate! / 100,
                                    strokeWidth: 4,
                                  ),
                                ),
                                Center(
                                    child: Text(
                                        (listTaskGroups[index].completionRate == 0 && listTaskGroups[index].totalTasks==0)?
                                        "100%"
                                            :
                                        "${listTaskGroups[index].completionRate}%",
                                      style: GoogleFonts.roboto(textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: 0.01,
                                          decoration: TextDecoration.none
                                      )),
                                    )
                                ),
                              ],
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
          child: RefreshIndicator(
            onRefresh: ()async{
              await update();
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
                    userRow(width),
                    const SizedBox(height: 20,),
                    todayProgress(width),
                    (anyToDoTasks)? const SizedBox(height: 20,) : const SizedBox(),
                    (anyToDoTasks)?
                    SizedBox(
                      width: width,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.to_do_string ,
                          style: GoogleFonts.roboto(textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              letterSpacing: 0.01,
                              decoration: TextDecoration.none
                          )),
                        ),
                      ),
                    )
                        :
                    const SizedBox(),
                    (anyToDoTasks)?  const SizedBox(height: 10,) : const SizedBox(),
                    toDoTasks(width),
                    (anyInProgressTasks)? const SizedBox(height: 20,) : const SizedBox(),
                    (anyInProgressTasks)? SizedBox(
                      width: width,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.in_progress_string ,
                          style: GoogleFonts.roboto(textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              letterSpacing: 0.01,
                              decoration: TextDecoration.none
                          )),
                        ),
                      ),
                    )
                        :
                    const SizedBox(),
                    (anyInProgressTasks)? const SizedBox(height: 10,) : const SizedBox(),
                    inProgressTasks(width),
                    const SizedBox(height: 20,),
                    tasksGroupsRow(),
                    const SizedBox(height: 20,),
                    tasksGroupsList(width),
                    SizedBox(height: bottomNavBarHeight+40,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}