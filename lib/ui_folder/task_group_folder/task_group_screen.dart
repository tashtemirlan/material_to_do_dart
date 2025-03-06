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

import '../../data_class_folder/notes_folder/notes_data_class.dart';
import '../../global_folder/globals.dart';
import '../skeleton_folder/skeleton.dart';


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

  Future<void> getNoteData() async{
    textTitleController.text = "Title";
    textDescriptionController.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    textDescriptionBool = true;
    textTitleBool = true;

    //todo : we must save data to our server like :
    //${icon.codePoint} - to get int of our selected icon
    // to get icon from server we need to use for example:
    //IconData myIcon = IconData(
    //  61817,  // codePoint you saved
    //  fontFamily: 'FontAwesomeSolid',  // Very important for FontAwesome
    //  fontPackage: 'font_awesome_flutter', // Required for FontAwesome
    //);

    //void saveIcon(IconData icon) {
    //  int codePoint = icon.codePoint;
    //  // Save `codePoint` to DB
    //}

    //IconData loadIcon(int codePoint) {
    //  return IconData(
    //    codePoint,
    //    fontFamily: 'FontAwesomeSolid',
    //    fontPackage: 'font_awesome_flutter',
    //  );
    //}

  }

  Future<void> saveTaskGroup() async{
    if(formTaskGroup.currentState!.validate()){
      if(widget.creation == true){
        await createTaskGroup();
      }
      else{
        await updateTaskGroup();
      }
    }
  }

  Future<void> createTaskGroup() async{
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.task_group_created_string,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
      backgroundColor: Colors.white, // Background color of the toast
      textColor: Colors.black,
    );
  }

  Future<void> updateTaskGroup() async{
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.task_group_updated_string,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
      backgroundColor: Colors.white, // Background color of the toast
      textColor: Colors.black,
    );
  }

  Future<void> deleteTaskGroup() async{
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.task_group_deleted_string,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
      backgroundColor: Colors.white, // Background color of the toast
      textColor: Colors.black,
    );
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
                        Navigator.pop(context);
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
      await getNoteData();
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
                                  Navigator.of(context).pop();
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
                                  deleteAlertDialog();
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