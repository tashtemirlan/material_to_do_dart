import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;
import 'package:material_to_do/global_folder/colors.dart' as colors;

import '../../data_class_folder/task_group_folder/task_groups_data_class.dart';
import '../skeleton_folder/skeleton.dart';


class CreateTaskScreen extends StatefulWidget {
  final int position;
  const CreateTaskScreen({super.key, required this.position});

  @override
  CreateTaskScreenState createState() => CreateTaskScreenState();
}

class CreateTaskScreenState extends State<CreateTaskScreen>{

  TaskGroupsDataClass? selectedTaskGroup;

  bool titleBool = false;
  bool descriptionBool = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  final formCreateTask = GlobalKey<FormState>();

  bool dataGet = false;

  List<TaskGroupsDataClass> listTaskGroups = [];

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

  Widget taskGroupSelectWidget(double width){
    if(dataGet == true){
      if(listTaskGroups.isEmpty){
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
              AppLocalizations.of(context)!.task_groups_list_empty_string,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: 0.01,
                  decoration: TextDecoration.none
              ))
          ),
        );
      }
      else{
        return DropdownButtonFormField2<TaskGroupsDataClass>(
          isExpanded: true,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20)
              ),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.errorTextFormFieldColor),
                  borderRadius: BorderRadius.circular(20)
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.errorTextFormFieldColor),
                  borderRadius: BorderRadius.circular(20)
              ),
              contentPadding: const EdgeInsets.only(left: 24, right: 18, top: 20, bottom: 20),
              fillColor: Colors.white,
              filled: true,
              errorStyle: TextStyle(
                  fontSize: 12,
                  color: colors.errorTextFormFieldColor
              ),
              errorMaxLines: 1,
          ),
          hint: Text(
            AppLocalizations.of(context)!.select_task_group_string,
            style: TextStyle(fontSize: 16),
          ),
          items: listTaskGroups.map((item) => DropdownMenuItem<TaskGroupsDataClass>(
            value: item,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5), 
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
                          color: hexToColor(item.backgroundColor!),
                          borderRadius: BorderRadius.circular(13)
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: FaIcon(IconData(
                          item.iconData!,
                          fontFamily: 'FontAwesomeSolid',
                          fontPackage: 'font_awesome_flutter',
                        ), color: hexToColor(item.iconColor!), size: 28,),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name!, overflow: TextOverflow.ellipsis,
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
                              item.description!, overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  letterSpacing: 0.01,
                                  decoration: TextDecoration.none
                              )),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
            ),
          )).toList(),
          validator: (value) {
            if (value == null) {
              return AppLocalizations.of(context)!.select_task_group_string;
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              selectedTaskGroup = value;
            });
            formCreateTask.currentState!.validate();
          },
          onSaved: (value) {
            selectedTaskGroup = value;
          },
          buttonStyleData: const ButtonStyleData(
            height: 55,
            padding: EdgeInsets.only(right: 8),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              FontAwesomeIcons.chevronDown,
              color: Colors.black,
              size: 16,
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            useRootNavigator: true,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 5),
          ),
          selectedItemBuilder: (BuildContext context){
            return listTaskGroups.map((item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: hexToColor(item.backgroundColor!),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: FaIcon(
                        IconData(
                          item.iconData!,
                          fontFamily: 'FontAwesomeSolid',
                          fontPackage: 'font_awesome_flutter',
                        ),
                        color: hexToColor(item.iconColor!),
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name!,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.description!,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList();
          },
        );
      }
    }
    else{
      return Skeleton(
        width: width,
        height: 60,
        borderRadius: BorderRadius.circular(15),
      );
    }
  }

  Widget taskTitleWidget(double width){
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: titleController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.errorTextFormFieldColor),
                borderRadius: BorderRadius.circular(20)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.errorTextFormFieldColor),
                borderRadius: BorderRadius.circular(20)
            ),
            contentPadding: const EdgeInsets.only(left: 24, right: 18, top: 20, bottom: 20),
            hintStyle: TextStyle(fontSize: 16 , color: colors.weightColor1, fontWeight: FontWeight.w500),
            hintText: AppLocalizations.of(context)!.please_enter_text,
            labelStyle: TextStyle(fontSize: 16 , color: colors.weightColor1, fontWeight: FontWeight.w500),
            labelText: AppLocalizations.of(context)!.task_title_string,
            fillColor: Colors.white,
            filled: true,
            errorStyle: TextStyle(
              fontSize: 12,
              color: colors.errorTextFormFieldColor
            ),
            errorMaxLines: 1,
            suffixIcon: (titleController.text.isEmpty)? const SizedBox() : (titleBool)?
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.solidCircleCheck, color: colors.circleCheckColor, size: 24,),)
                :
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.circleExclamation, color: colors.errorTextFormFieldColor, size: 24,),)

        ),
        style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600 , color: colors.darkBlack)),
        validator: (String?value){
          if(value!.isEmpty){
            return AppLocalizations.of(context)!.empty_field_string;
          }
          return null;
        },
        onChanged: (val){
          if(val.isEmpty){
            setState(() {
              titleBool = false;
            });
          }
          else{
            setState(() {
              titleBool = true;
            });
          }
        },
      ),
    );
  }

  Widget descriptionTitleWidget(double width){
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: descriptionController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.errorTextFormFieldColor),
                borderRadius: BorderRadius.circular(20)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.errorTextFormFieldColor),
                borderRadius: BorderRadius.circular(20)
            ),
            contentPadding: const EdgeInsets.only(left: 24, right: 18, top: 20, bottom: 20),
            hintStyle: TextStyle(fontSize: 16 , color: colors.weightColor1, fontWeight: FontWeight.w500),
            hintText: AppLocalizations.of(context)!.please_enter_text,
            labelStyle: TextStyle(fontSize: 16 , color: colors.weightColor1, fontWeight: FontWeight.w500),
            labelText: AppLocalizations.of(context)!.task_description_string,
            fillColor: Colors.white,
            filled: true,
            errorStyle: TextStyle(
                fontSize: 12,
                color: colors.errorTextFormFieldColor
            ),
            errorMaxLines: 1,
            suffixIcon: (descriptionController.text.isEmpty)? const SizedBox() : (descriptionBool)?
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.solidCircleCheck, color: colors.circleCheckColor, size: 24,),)
                :
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.circleExclamation, color: colors.errorTextFormFieldColor, size: 24,),)

        ),
        style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600 , color: colors.darkBlack)),
        validator: (String?value){
          if(value!.isEmpty){
            return AppLocalizations.of(context)!.empty_field_string;
          }
          return null;
        },
        onChanged: (val){
          if(val.isEmpty){
            setState(() {
              descriptionBool = false;
            });
          }
          else{
            setState(() {
              descriptionBool = true;
            });
          }
        },
      ),
    );
  }

  Widget startDateWidget(double width){
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: pickUpStartDate,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.calendar, color: colors.mainColor, size: 24,),
                const SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.start_date_string,
                      style: GoogleFonts.roboto(textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          letterSpacing: 0.01,
                          decoration: TextDecoration.none
                      )),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      startDate == null ?
                      AppLocalizations.of(context)!.not_selected_string: formatDateWithSuffix(startDate!),
                      style: GoogleFonts.roboto(textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.01,
                          decoration: TextDecoration.none
                      )),
                    )
                  ],
                ),
                Spacer(),
                FaIcon(FontAwesomeIcons.chevronDown, color: colors.darkBlack1, size: 24,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget endDateWidget(double width){
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: pickUpEndDate,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: GestureDetector(
              onTap: (){
                pickUpEndDate();
              },
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.calendar, color: colors.mainColor, size: 24,),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.end_date_string,
                        style: GoogleFonts.roboto(textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            letterSpacing: 0.01,
                            decoration: TextDecoration.none
                        )),
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        endDate == null ?
                        AppLocalizations.of(context)!.not_selected_string: formatDateWithSuffix(endDate!),
                        style: GoogleFonts.roboto(textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.01,
                            decoration: TextDecoration.none
                        )),
                      )
                    ],
                  ),
                  Spacer(),
                  FaIcon(FontAwesomeIcons.chevronDown, color: colors.darkBlack1, size: 24,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget button(width){
    return SizedBox(
        width: width,
        child: ElevatedButton(
            onPressed: () async{
              if(formCreateTask.currentState!.validate()){
                await createTask();
              }
            },
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                backgroundColor: (titleController.text.isNotEmpty
                    && descriptionController.text.isNotEmpty
                    && selectedTaskGroup != null)?
                WidgetStateProperty.all<Color>(colors.mainColor)
                    :
                WidgetStateProperty.all<Color>(colors.palete8)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                  AppLocalizations.of(context)!.create_task_string,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(textStyle: const TextStyle(
                      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600 , letterSpacing: 0.01
                  ))),
            )
        )
    );
  }

  void pickUpStartDate() async{
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
                              fontSize: 16,
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
                        Navigator.pop(context, startDate);
                      },
                    ),
                  ],
                ),
              ),
              // Date picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  minimumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime dateTime) {
                    startDate = dateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if(selectDate!=null){
      if(endDate==null){
        setState(() {
          startDate = selectDate;
        });
      }
      else{
        if(startDate!.isAfter(endDate!)){
          setState(() {
            startDate = selectDate;
            endDate = null;
          });
        }
        else{
          setState(() {
            startDate = selectDate;
          });
        }
      }
    }
  }

  void pickUpEndDate() async{
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
                              fontSize: 16,
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
                        Navigator.pop(context, endDate);
                      },
                    ),
                  ],
                ),
              ),
              // Date picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: (startDate == null)? DateTime.now() : startDate!.add(Duration(minutes: 1)),
                  minimumDate: (startDate == null)? DateTime.now() : startDate!.add(Duration(minutes: 1)),
                  onDateTimeChanged: (DateTime dateTime) {
                    endDate = dateTime;
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
        endDate = selectDate;
      });
    }
  }

  String formatDateWithSuffix(DateTime date) {
    Locale locale = Localizations.localeOf(context);
    if (locale.languageCode == 'en') {
      String day = DateFormat('d', 'en').format(date);
      String month = DateFormat('MMMM', 'en').format(date);
      String hoursAndMinutes = DateFormat('HH:mm', 'en').format(date);
      return '$day${_getDaySuffixEnglish(day)} $month, ${date.year}  $hoursAndMinutes';
    } else {
      String day = DateFormat('d', 'ru').format(date);
      String hoursAndMinutes = DateFormat('HH:mm', 'en').format(date);
      return '$day${_getRussianDaySuffix(day)} ${getMonthInGenitive(date.month)}, ${date.year}  $hoursAndMinutes';
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
      print("Tasks groups data : $response");
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
    await getTasksGroups();
    setState(() {
      dataGet = true;
    });
  }

  String formatTimeZoneOffset(Duration offset) {
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final sign = offset.isNegative ? '-' : '+';
    return '$sign$hours:$minutes';
  }

  Future<void> createTask() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    dio.options.responseType = ResponseType.plain;
    //set Dio response =>
    try{
      final response = await dio.post(
          endpoints.createTaskPostEndpoint,
          data: {
            "title": titleController.text,
            "description": descriptionController.text,
            "task_group_id": selectedTaskGroup!.id,
            "start_date": startDate == null ? null : "${startDate!.toIso8601String()}${formatTimeZoneOffset(startDate!.timeZoneOffset)}",
            "finish_date": endDate == null ? null : "${endDate!.toIso8601String()}${formatTimeZoneOffset(endDate!.timeZoneOffset)}",
            "status": "TODO"
          }
      );
      print("Tasks groups data : $response");
      if(response.statusCode == 201){
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.task_created_string,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
        Navigator.of(context).pop();
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
              child: Form(
                key: formCreateTask,
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5,),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: FaIcon(FontAwesomeIcons.arrowLeft, color: colors.darkBlack, size: 24,),
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.add_task_string,
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
                        taskGroupSelectWidget(width),
                        const SizedBox(height: 20,),
                        taskTitleWidget(width),
                        const SizedBox(height: 20,),
                        descriptionTitleWidget(width),
                        const SizedBox(height: 20,),
                        startDateWidget(width),
                        const SizedBox(height: 20,),
                        endDateWidget(width),
                        const SizedBox(height: 20,),
                        button(width)
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