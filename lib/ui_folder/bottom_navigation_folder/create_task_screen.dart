import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;

import '../../data_class_folder/task_group_folder/task_groups_data_class.dart';


class CreateTaskScreen extends StatefulWidget {
  final int position;
  const CreateTaskScreen({super.key, required this.position});

  @override
  CreateTaskScreenState createState() => CreateTaskScreenState();
}

class CreateTaskScreenState extends State<CreateTaskScreen>{


  List<TaskGroupsDataClass> taskGroupsList = [];

  bool titleBool = false;
  bool descriptionBool = false;
  bool selectedTaskGroup = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  final formCreateTask = GlobalKey<FormState>();


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
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.01,
                          decoration: TextDecoration.none
                      )),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      startDate == null ?
                      AppLocalizations.of(context)!.not_selected_string: startDate.toString(),
                      style: GoogleFonts.roboto(textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
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
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.01,
                            decoration: TextDecoration.none
                        )),
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        endDate == null ?
                        AppLocalizations.of(context)!.not_selected_string: endDate.toString(),
                        style: GoogleFonts.roboto(textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
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
                print("create task");
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
                    && selectedTaskGroup==true)?
                WidgetStateProperty.all<Color>(colors.mainColor)
                    :
                WidgetStateProperty.all<Color>(colors.palete8)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                  AppLocalizations.of(context)!.sign_up_text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(textStyle: const TextStyle(
                      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600 , letterSpacing: 0.01
                  ))),
            )
        )
    );
  }


  //TODO : solve logic to pick date and with task groups
  void pickUpStartDate(){

  }

  void pickUpEndDate(){

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                        (taskGroupsList.isEmpty)? Text("data") : Text("DAta"),
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