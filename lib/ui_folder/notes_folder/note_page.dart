import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data_class_folder/notes_folder/note_data_class.dart';
import '../../global_folder/globals.dart';

class NoteScreen extends StatefulWidget {
  final int? id;
  final bool creation;
  const NoteScreen({super.key, required this.id, required this.creation});

  @override
  NoteScreenState createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen>{

  bool dataGet = false;

  TextEditingController textTitleController = TextEditingController();
  TextEditingController textDescriptionController = TextEditingController();
  bool textTitleBool = false;
  bool textDescriptionBool = false;

  bool noteHasBeenUpdated = false;

  final formNote = GlobalKey<FormState>();

  Widget noteTitleWidget(double width){
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

  Widget noteDescriptionWidget(double width){
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

  Future<void> getNoteData() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    //set Dio response =>
    try{
      final response = await dio.get("${endpoints.noteGetEndpoint}${widget.id}");
      if(response.statusCode == 200){
        final result = noteDataClassFromJson(response.toString());
        setState(() {
          textTitleController.text = result.title ?? "";
          textDescriptionController.text = result.description ?? "";
          textDescriptionBool = true;
          textTitleBool = true;
        });
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

  Future<void> saveNote() async{
    if(formNote.currentState!.validate()){
      if(widget.creation == true){
        await createNote();
        Navigator.pop(context, "updating");
      }
      else{
        await updateNote();
      }
    }
  }

  Future<void> createNote() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    //set Dio response =>
    try{
      final response = await dio.post(
          endpoints.createNotePostEndpoint ,
          data: {
            "title" : textTitleController.text,
            "description" : textDescriptionController.text
          }
      );
      if(response.statusCode == 201){
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.note_created_string,
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

  Future<void> updateNote() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    //set Dio response =>
    try{
      final response = await dio.put(
          "${endpoints.updateNotePutEndpoint}${widget.id}",
          data: {
            "title" : textTitleController.text,
            "description" : textDescriptionController.text
          }
      );
      if(response.statusCode == 200){
        noteHasBeenUpdated = true;
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.note_updated_string,
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

  Future<void> deleteNote() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    var box = await Hive.openBox("auth");
    final token = box.get("token");
    dio.options.headers['Authorization'] = "Bearer $token";
    //set Dio response =>
    try{
      final response = await dio.delete("${endpoints.deleteNoteDeleteEndpoint}${widget.id}");
      if(response.statusCode == 200){
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.note_deleted_string,
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
              AppLocalizations.of(context)!.delete_note_string , textAlign: TextAlign.center,
              style: GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: 24, color: colors.darkBlack, fontWeight: FontWeight.w500 , letterSpacing: 0.1
              ))
          ),
          content: Text(
              AppLocalizations.of(context)!.accept_delete_note_string ,  textAlign: TextAlign.start,
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
                        await deleteNote();
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
                key: formNote,
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
                                if(noteHasBeenUpdated){
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
                                await saveNote();
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
                                AppLocalizations.of(context)!.create_note_string
                                    :
                                AppLocalizations.of(context)!.edit_note_string ,
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
                        noteTitleWidget(width),
                        const SizedBox(height: 20,),
                        noteDescriptionWidget(width),
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