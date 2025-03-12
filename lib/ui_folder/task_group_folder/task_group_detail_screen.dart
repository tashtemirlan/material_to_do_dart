import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;
import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/ui_folder/skeleton_folder/skeleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data_class_folder/task_group_folder/task_group_data_class.dart';
import '../../data_class_folder/tasks_folder/to_do_tasks_data_class.dart';
import '../../global_folder/globals.dart';
import '../task_folder/task_screen.dart';
import '../task_group_folder/task_group_screen.dart';


class TaskGroupDetailScreen extends StatefulWidget {
  final int id;
  const TaskGroupDetailScreen({super.key, required this.id});

  @override
  TaskGroupDetailScreenState createState() => TaskGroupDetailScreenState();
}

class TaskGroupDetailScreenState extends State<TaskGroupDetailScreen>{

  bool dataGet = false;

  TaskGroupDataClass? ts;
  List<TodoTasksDataClass> listTasks = [];

  Future<void> getTasksForGroup() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    dio.options.responseType = ResponseType.plain;
    //set Dio response =>
    try{
      final response = await dio.get("${endpoints.tasksByGroupIdGetEndpoint}${widget.id}");
      print("Response for tasks in group id : ${widget.id}:\n $response");
      if(response.statusCode == 200){
        if(response.data == "null"){}
        else{
          //Same answer as for to do type so we use same parser
          final result = todoTasksDataClassFromJson(response.toString());
          listTasks = result;
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

  Future<void> getTaskGroupInfo() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    dio.options.responseType = ResponseType.plain;
    //set Dio response =>
    try{
      final response = await dio.get("${endpoints.taskGroupGetEndpoint}${widget.id}");
      print("Response for task_group with group id : ${widget.id}:\n $response");
      if(response.statusCode == 200){
        if(response.data == "null"){}
        else{
          //Same answer as for to do type so we use same parser
          final result = taskGroupDataClassFromJson(response.toString());
          ts = result;
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

  Future<void> initVoid() async{
    await getTaskGroupInfo();
    await getTasksForGroup();
    setState(() {
      dataGet = true;
    });
  }

  Future<void> update() async{
    setState(() {
      dataGet = false;
    });
    await getTaskGroupInfo();
    await getTasksForGroup();
    setState(() {
      dataGet = true;
    });
  }

  Widget statusTaskWidget(TodoTasksDataClass task){
    if(task.status == "TODO"){
      return statusContainerWidget(colors.todoStatusMain, colors.todoStatusAdditional, AppLocalizations.of(context)!.to_do_string);
    }
    else if(task.status == "IN PROGRESS"){
      return statusContainerWidget(colors.inProgressStatusMain, colors.inProgressStatusAdditional, AppLocalizations.of(context)!.in_progress_string);
    }
    else{
      return statusContainerWidget(colors.doneStatusMain, colors.doneStatusAdditional, AppLocalizations.of(context)!.completed_string);
    }
  }

  Widget statusContainerWidget(Color mainColor, Color additionalColor , String text){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: additionalColor
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 5 , horizontal: 8
        ),
        child: Text(
          text,
          style: GoogleFonts.roboto(textStyle: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.01,
              decoration: TextDecoration.none
          )),
        ),
      ),
    );
  }

  Widget createIcon(){
    if(ts !=null){
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
            color: hexToColor(ts!.backgroundColor!),
            borderRadius: BorderRadius.circular(15)
        ),
        child: Align(
          alignment: Alignment.center,
          child: FaIcon(IconData(
            ts!.iconData!,
            fontFamily: 'FontAwesomeSolid',
            fontPackage: 'font_awesome_flutter',
          ), color: hexToColor(ts!.iconColor!), size: 24,),
        ),
      );
    }
    else{
      return const SizedBox();
    }
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

  Widget taskGroupRow(double width){
    return SizedBox(
      width: width,
      child: Row(
        children: [
          createIcon(),
          const SizedBox(width: 20,),
          Expanded(child: Text(
            ts!.name!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(textStyle: TextStyle(
                color: colors.black1,
                fontWeight: FontWeight.w700,
                fontSize: 32,
                letterSpacing: 0.01,
                decoration: TextDecoration.none
            )),
          ),),
          const SizedBox(width: 20,),
          GestureDetector(
            onTap: () async{
              final result = await Navigator.of(context).push(
                CupertinoPageRoute(builder: (BuildContext context) => TaskGroupScreen(id: widget.id, creation: false,)),
              );
              if(result!=null){
                await update();
              }
            },
            child: CircleAvatar(
              backgroundColor: colors.mainColor,
              radius: 20,
              child: FaIcon(FontAwesomeIcons.penToSquare , color: Colors.white, size: 20,),
            ),
          )
        ],
      ),
    );
  }

  Widget tasksList(double width){
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
      if(listTasks.isEmpty){
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            width: width,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.tasks_list_empty,
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
              itemCount: listTasks.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: () async{
                    final result = await  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (BuildContext context) => ViewTaskScreen(ID: listTasks[index].id!,)),
                    );
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
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width/2,
                                  child: Text(
                                    listTasks[index].taskGroupName!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(textStyle: TextStyle(
                                        color: colors.black2,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: 0.01,
                                        decoration: TextDecoration.none
                                    )),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: width/2,
                                  child: Text(
                                    listTasks[index].title!,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                        letterSpacing: 0.01,
                                        decoration: TextDecoration.none
                                    )),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: width/2,
                                  child: Text(
                                    listTasks[index].description!,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 0.01,
                                        decoration: TextDecoration.none
                                    )),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(FontAwesomeIcons.clock, color: colors.helpColor, size: 14,),
                                    const SizedBox(width: 5,),
                                    Text(
                                      listTasks[index].finishDate ==null?
                                      ""
                                          :
                                      "${DateFormat('HH:mm').format(listTasks[index].finishDate!)} |  ${formatDateWithSuffix(listTasks[index].startDate!)} - ${formatDateWithSuffix(listTasks[index].finishDate!)}",
                                      style: GoogleFonts.roboto(textStyle: TextStyle(
                                          color: colors.helpColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: 0.01,
                                          decoration: TextDecoration.none
                                      )),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            statusTaskWidget(listTasks[index])
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

  String formatDateWithSuffix(DateTime date) {
    Locale locale = Localizations.localeOf(context);
    if (locale.languageCode == 'en') {
      String day = DateFormat('d', 'en').format(date);
      String month = DateFormat('MMMM', 'en').format(date);
      return '$day${_getDaySuffixEnglish(day)} $month';
    } else {
      String day = DateFormat('d', 'ru').format(date);
      return '$day${_getRussianDaySuffix(day)} ${getMonthInGenitive(date.month)}';
    }
  }

  String _getDaySuffixEnglish(String day) {
    int dayNumber = int.parse(day);
    if (dayNumber >= 11 && dayNumber <= 13) {
      return 'th';
    }
    switch (dayNumber % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getRussianDaySuffix(String day) {
    int dayNumber = int.parse(day);
    if (dayNumber >= 11 && dayNumber <= 14) {
      return 'е';  // Special case for 11-14 (like 11-е, 12-е)
    }
    switch (dayNumber % 10) {
      case 1:
        return 'ое';  // 1ое
      case 2:
      case 3:
      case 4:
        return 'е';   // 2е, 3е, 4е
      default:
        return 'е';   // 5е and all others
    }
  }

  String getMonthInGenitive(int month) {
    const monthsGenitive = [
      'Января', 'Февраля', 'Марта', 'Апреля',
      'Мая', 'Июня', 'Июля', 'Августа',
      'Сентября', 'Октября', 'Ноября', 'Декабря'
    ];
    return monthsGenitive[month - 1]; // month is 1-based
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
                    GestureDetector(
                      onTap: () async{
                        Navigator.of(context).pop("Update");
                      },
                      child: FaIcon(FontAwesomeIcons.chevronLeft , color: colors.black2, size: 24,),
                    ),
                    const SizedBox(height: 20,),
                    taskGroupRow(width),
                    const SizedBox(height: 20,),
                    Text(
                      AppLocalizations.of(context)!.tasks_all_string,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(textStyle: TextStyle(
                          color: colors.black1,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0.01,
                          decoration: TextDecoration.none
                      )),
                    ),
                    const SizedBox(height: 20,),
                    tasksList(width),
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