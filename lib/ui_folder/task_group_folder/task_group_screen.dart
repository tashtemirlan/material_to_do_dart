import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data_class_folder/task_group_folder/task_group_data_class.dart';
import '../../global_folder/globals.dart';


class TaskGroupScreen extends StatefulWidget {
  final int? id;
  final bool creation;
  const TaskGroupScreen({super.key, required this.id, required this.creation});

  @override
  TaskGroupScreenState createState() => TaskGroupScreenState();
}

class TaskGroupScreenState extends State<TaskGroupScreen>{

  bool dataGet = false;

  TextEditingController textTitleController = TextEditingController();
  TextEditingController textDescriptionController = TextEditingController();
  bool textTitleBool = false;
  bool textDescriptionBool = false;

  final formTaskGroup = GlobalKey<FormState>();

  Color selectedIconColor = colors.mainColor;
  Color backgroundColor = colors.palete1;
  IconData selectedIcon = FontAwesomeIcons.flutter;

  TaskGroupDataClass? ts;

  bool taskGroupHasBeenUpdated = false;

  Widget taskGroupTitleWidget(double width){
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: textTitleController,
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
            hintStyle: TextStyle(fontSize: 16 , color: colors.weightColor, fontWeight: FontWeight.w500),
            hintText: AppLocalizations.of(context)!.please_enter_text,
            labelText: AppLocalizations.of(context)!.title_string,
            labelStyle: TextStyle(fontSize: 16 , color: colors.weightColor, fontWeight: FontWeight.w500),
            fillColor: Colors.white,
            filled: true,
            errorStyle: TextStyle(
                fontSize: 12,
                color: colors.errorTextFormFieldColor
            ),
            errorMaxLines: 1,
            suffixIcon: (textTitleController.text.isEmpty)? const SizedBox() : (textTitleBool)?
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
              textTitleBool = false;
            });
          }
          else{
            setState(() {
              textTitleBool = true;
            });
          }
        },
      ),
    );

  }

  Widget taskGroupDescriptionWidget(double width){
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: textDescriptionController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.multiline,
        maxLines: null,
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
            hintStyle: TextStyle(fontSize: 16 , color: colors.weightColor, fontWeight: FontWeight.w500),
            hintText: AppLocalizations.of(context)!.please_enter_text,
            labelText: AppLocalizations.of(context)!.description_string,
            labelStyle: TextStyle(fontSize: 16 , color: colors.weightColor, fontWeight: FontWeight.w500),
            fillColor: Colors.white,
            filled: true,
            errorStyle: TextStyle(
                fontSize: 12,
                color: colors.errorTextFormFieldColor
            ),
            errorMaxLines: 1,
            suffixIcon: (textDescriptionController.text.isEmpty)? const SizedBox() : (textDescriptionBool)?
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
              textDescriptionBool = false;
            });
          }
          else{
            setState(() {
              textDescriptionBool = true;
            });
          }
        },
      ),
    );
  }

  Widget iconWidget(double width){
    return GestureDetector(
      onTap: (){
        showIconPicker(context, (icon) {
          setState(() {
            selectedIcon = icon;
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(13),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: FaIcon(selectedIcon, color: selectedIconColor, size: 28,),
                ),
              ),
              Spacer(),
              Text(
                  AppLocalizations.of(context)!.icon_string ,
                  style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: 0.01,
                      decoration: TextDecoration.none
                  ))
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Widget iconColorWidget(double width){
    return GestureDetector(
      onTap: (){
        showColorPicker(context, selectedIconColor, (color) {
          setState(() {
            selectedIconColor = color;
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedIconColor,
                    border: Border.all(
                        color: Colors.black,
                        width: 0.1
                    )
                ),
              ),
              Spacer(),
              Text(
                  AppLocalizations.of(context)!.icon_color_string ,
                  style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: 0.01,
                      decoration: TextDecoration.none
                  ))
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Widget backgroundColorWidget(double width){
    return GestureDetector(
      onTap: (){
        showColorPicker(context, backgroundColor, (color) {
          setState(() {
            backgroundColor = color;
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor,
                    border: Border.all(
                        color: Colors.black,
                        width: 0.1
                    )
                ),
              ),
              Spacer(),
              Text(
                  AppLocalizations.of(context)!.background_color_string,
                  style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: 0.01,
                      decoration: TextDecoration.none
                  ))
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  void showColorPicker(BuildContext context, Color currentColor, Function(Color) onColorSelected) {
    showDialog(
      context: context,
      builder: (context) {
        Color selectedColor = currentColor;

        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.pick_color_string,
              style: GoogleFonts.roboto(textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  letterSpacing: 0.01,
                  decoration: TextDecoration.none
              ))
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              labelTypes: [
                ColorLabelType.hex,
                ColorLabelType.rgb,
                ColorLabelType.hsl,
                ColorLabelType.hsv
              ],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                  AppLocalizations.of(context)!.apply_string,
                  style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: colors.mainColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: 0.01,
                      decoration: TextDecoration.none
                  ))
              ),
              onPressed: () {
                onColorSelected(selectedColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showIconPicker(BuildContext context, Function(IconData) onIconSelected) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: availableIcons.length,
          itemBuilder: (context, index) {
            final icon = availableIcons[index];
            return GestureDetector(
              onTap: () {
                onIconSelected(icon);
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  )
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: FaIcon(icon, size: 28),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Convert a Color to Hex string
  static String colorToHex(Color color) {
    int r = (color.r * 255).toInt();
    int g = (color.g * 255).toInt();
    int b = (color.b * 255).toInt();
    int a = (color.a * 255).toInt();

    return '#${a.toRadixString(16).padLeft(2, '0')}${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
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

  Future<void> getTaskGroupData() async{
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
          textTitleController.text = result.name!;
          textDescriptionController.text = result.description!;
          selectedIconColor = hexToColor(result.iconColor!);
          backgroundColor = hexToColor(result.backgroundColor!);
          selectedIcon = IconData(
            result.iconData!,
            fontFamily: 'FontAwesomeSolid',
            fontPackage: 'font_awesome_flutter',
          );
          textDescriptionBool = true;
          textTitleBool = true;
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

  Future<void> saveTaskGroup() async{
    if(formTaskGroup.currentState!.validate()){
      if(widget.creation == true){
        await createTaskGroup();
        Navigator.pop(context, "Update");
      }
      else{
        await updateTaskGroup();
      }
    }
  }

  Future<void> createTaskGroup() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    //set Dio response =>
    try{
      final response = await dio.post(
          endpoints.createTaskGroupPostEndpoint,
          data: {
            "name" : textTitleController.text,
            "description" : textDescriptionController.text,
            "icon_data" : selectedIcon.codePoint,
            "background_color" : colorToHex(backgroundColor),
            "icon_color" : colorToHex(selectedIconColor)
          }
      );
      if(response.statusCode == 201){
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.task_group_created_string,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
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

  Future<void> updateTaskGroup() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    //set Dio response =>
    try{
      final response = await dio.put(
          "${endpoints.updateTaskGroupPutEndpoint}${widget.id}",
          data: {
            "name" : textTitleController.text,
            "description" : textDescriptionController.text,
            "icon_data" : selectedIcon.codePoint,
            "background_color" : colorToHex(backgroundColor),
            "icon_color" : colorToHex(selectedIconColor)
          }
      );
      if(response.statusCode == 200){
        taskGroupHasBeenUpdated= true;
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.task_group_updated_string,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
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

  Future<void> deleteTaskGroup() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    //set Dio response =>
    try{
      final response = await dio.delete(
          "${endpoints.deleteTaskGroupDeleteEndpoint}${widget.id}",
      );
      if(response.statusCode == 200){
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.task_group_deleted_string,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
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

  void deleteAlertDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          title: Text(
              AppLocalizations.of(context)!.delete_task_group_string , textAlign: TextAlign.center,
              style: GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: 24, color: colors.darkBlack, fontWeight: FontWeight.w500 , letterSpacing: 0.1
              ))
          ),
          content: Text(
              AppLocalizations.of(context)!.accept_delete_task_group_string ,  textAlign: TextAlign.start,
              style:  GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: 14, color: colors.darkBlack, fontWeight: FontWeight.w500 , letterSpacing: 0.1
              ))
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: ()async{
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        child: Text(
                            AppLocalizations.of(context)!.no_string,
                            style: TextStyle(
                                fontSize: 14, color: colors.darkBlack, fontWeight: FontWeight.w500 , letterSpacing: 0.1
                            )
                        ),
                      )
                  ),
                  const SizedBox(width: 8,),
                  TextButton(
                      onPressed: () async{
                        await deleteTaskGroup();
                        Navigator.pop(context);
                        Navigator.pop(context, "Update");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        child: Text(
                            AppLocalizations.of(context)!.yes_string,
                            style: GoogleFonts.roboto(textStyle:  TextStyle(
                                fontSize: 14, color: colors.errorTextFormFieldColor, fontWeight: FontWeight.w500 , letterSpacing: 0.1
                            ))
                        ),
                      )
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> initVoid() async{
    if(widget.creation == false){
      await getTaskGroupData();
    }
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
              child: Form(
                  key: formTaskGroup,
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
                              GestureDetector(
                                onTap: () async{
                                  if(taskGroupHasBeenUpdated){
                                    Navigator.pop(context, "updating");
                                  }
                                  else{
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: FaIcon(FontAwesomeIcons.arrowLeft, color: colors.darkBlack, size: 28,),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async{
                                  await saveTaskGroup();
                                },
                                child: FaIcon(FontAwesomeIcons.floppyDisk, color: colors.mainColor, size: 28,),
                              ),
                              const SizedBox(width: 20,),
                              GestureDetector(
                                onTap: (){
                                  if(widget.id!=null){
                                    deleteAlertDialog();
                                  }
                                  else{
                                    Navigator.pop(context, "Update");
                                  }
                                },
                                child: FaIcon(FontAwesomeIcons.trashCan, color: colors.errorTextFormFieldColor, size: 28,),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: width,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (widget.creation)?
                                  AppLocalizations.of(context)!.create_task_group_string
                                      :
                                  AppLocalizations.of(context)!.edit_task_group_string ,
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
                          ),
                          const SizedBox(height: 10,),
                          taskGroupTitleWidget(width),
                          const SizedBox(height: 20,),
                          taskGroupDescriptionWidget(width),
                          const SizedBox(height: 20,),
                          iconColorWidget(width),
                          const SizedBox(height: 20,),
                          backgroundColorWidget(width),
                          const SizedBox(height: 20,),
                          iconWidget(width),
                          SizedBox(height: bottomNavBarHeight+40,)
                        ],
                      ),
                    ),
                  )
              ),
            )
        )
    );
  }
}