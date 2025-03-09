import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;
import '../../data_class_folder/tasks_folder/date_tasks_data_class.dart';
import '../../global_folder/globals.dart';
import '../skeleton_folder/skeleton.dart';
import '../task_folder/task_screen.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen>{

  late DateTime selectedDateTime;

  bool dataGet = false;

  List<String> statusList = [];
  List<TaskDate>  list = [];
  List<TaskDate> filteredList = [];

  int selectedIndexStatus = 0;

  Future<void> getTodayTasks() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    dio.options.responseType = ResponseType.plain;
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDateTime);
    //set Dio response =>
    try{
      final response = await dio.get(
          "${endpoints.taskByDateGetEndpoint}?finish_date=$formattedDate"
      );
      if(response.statusCode == 200){
        if(response.data == "null"){}
        else{
          final result = dateTasksDataClassFromJson(response.toString());
          if(result.tasks != null){
            list = result.tasks!;
            filteredList = result.tasks!;
          }
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

  Future<void> fillStatusList() async{
    statusList.add(AppLocalizations.of(context)!.all_string);
    statusList.add(AppLocalizations.of(context)!.to_do_string);
    statusList.add(AppLocalizations.of(context)!.in_progress_string);
    statusList.add(AppLocalizations.of(context)!.completed_string);
  }

  Future<void> initVoid() async{
    selectedDateTime = DateTime.now();
    await getTodayTasks();
    await fillStatusList();
    setState(() {
      dataGet = true;
    });
  }

  Widget statusesWidget(double width){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: statusList.asMap().entries.map((entry){
          int index = entry.key;
          return GestureDetector(
            onTap: () async{
              setState(() {
                selectedIndexStatus = index;
              });
              await filterByStatus(selectedIndexStatus);
            },
            child: Padding(
              padding: (index==0)? EdgeInsets.zero : const EdgeInsets.only(left: 5),
              child: Container(
                decoration: BoxDecoration(
                    color: (selectedIndexStatus == index)? colors.mainColor : colors.additionalColor,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Text(
                      statusList[index],
                      style: GoogleFonts.roboto(textStyle: TextStyle(
                          color: (selectedIndexStatus == index)? Colors.white : colors.mainColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.01,
                          decoration: TextDecoration.none
                      )),
                    )
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> filterByStatus(int pos) async{
    if(pos ==0){
      //show all :
      setState(() {
        filteredList = list;
      });
    }
    else if(pos == 1){
      final filteredDataList = list.where((item){
        return item.status == "TODO";
      }).toList();
      setState(() {
        filteredList = filteredDataList;
      });
    }
    else if(pos == 2){
      final filteredDataList = list.where((item){
        return item.status == "IN PROGRESS";
      }).toList();
      setState(() {
        filteredList = filteredDataList;
      });
    }
    else{
      final filteredDataList = list.where((item){
        return item.status == "COMPLETED";
      }).toList();
      setState(() {
        filteredList = filteredDataList;
      });
    }
  }

  Future<void> update() async{
    setState(() {
      dataGet = false;
    });
    await getTodayTasks();
    setState(() {
      dataGet = true;
    });
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

  Widget statusTaskWidget(TaskDate task){
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

  Widget tasksWidgets(double width) {
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
      if(filteredList.isEmpty){
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
                      fontSize: 22,
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
              itemCount: filteredList.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: () async{
                    final result = await  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (BuildContext context) => ViewTaskScreen(ID: list[index].id!,)),
                    );
                    if(result!=null){
                      await update();
                    }
                  },
                  child: Padding(
                    padding: (index==0)? EdgeInsets.zero : const EdgeInsets.only(top: 5),
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
                                      filteredList[index].taskGroupName!,
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
                                      filteredList[index].title!,
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
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(FontAwesomeIcons.clock, color: colors.helpColor, size: 14,),
                                      const SizedBox(width: 5,),
                                      Text(
                                        filteredList[index].finishDate ==null?
                                        ""
                                            :
                                        "${DateFormat('HH:mm').format(filteredList[index].finishDate!)} |  ${formatDateWithSuffix(filteredList[index].startDate!)} - ${formatDateWithSuffix(filteredList[index].finishDate!)}",
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
                              statusTaskWidget(filteredList[index])
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

  void pickUpDate() async{
    final selectDate = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                          AppLocalizations.of(context)!.cancel_string,
                          style: GoogleFonts.roboto(textStyle: TextStyle(
                              color: colors.mainColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 0.01,
                              decoration: TextDecoration.none
                          ))
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: Text(
                          AppLocalizations.of(context)!.apply_string,
                          style: GoogleFonts.roboto(textStyle: TextStyle(
                              color: colors.mainColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 0.01,
                              decoration: TextDecoration.none
                          ))
                      ),
                      onPressed: () {
                        Navigator.pop(context, selectedDateTime);
                      },
                    ),
                  ],
                ),
              ),
              // Date picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDateTime,
                  onDateTimeChanged: (DateTime dateTime) {
                    selectedDateTime = dateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if(selectDate!=null){
      setState(() {
        dataGet = false;
        selectedDateTime = selectDate;
      });
      await getTodayTasks();
      setState(() {
        dataGet = true;
      });
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
      body: Container(
          width: width,
          height: height,
          color: colors.scaffoldColor,
          child: Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: RefreshIndicator(
              onRefresh: () async{
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
                      SizedBox(
                        width: width,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.today_tasks_string,
                            style: GoogleFonts.roboto(textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                letterSpacing: 0.01,
                                decoration: TextDecoration.none
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Text(
                              formatDateWithSuffix(selectedDateTime),
                              style: GoogleFonts.roboto(textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                  letterSpacing: 0.01,
                                  decoration: TextDecoration.none
                              ))
                          ),
                          const SizedBox(width: 20,),
                          GestureDetector(
                            onTap: pickUpDate,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: colors.mainColor,
                                  borderRadius: BorderRadius.circular(13)
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                child: Text(
                                    AppLocalizations.of(context)!.pick_date_string,
                                    style: GoogleFonts.roboto(textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: 0.01,
                                        decoration: TextDecoration.none
                                    ))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      statusesWidget(width),
                      const SizedBox(height: 10,),
                      tasksWidgets(width),
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