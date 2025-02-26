import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_to_do/ui_folder/start_folder/login_folder/login_screen_boarding.dart';
import 'package:material_to_do/ui_folder/start_folder/sign_up_folder/policy_screen.dart';
import 'package:material_to_do/ui_folder/start_folder/sign_up_folder/privacy_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';






class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  SignUpPageState createState ()=> SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {


  bool nameBool = false;
  bool emailBool = false;
  bool passwordBool = false;

  bool isChecked = false;
  bool stateCheck = true;

  String langString = "";
  String langOpt1 = "";
  String langOpt2 = "";
  //bool to show password ->
  bool passwordVisible = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //key for form field
  final formSignUp = GlobalKey<FormState>();

  XFile? imageFile;
  FileImage? userChooseImage;

  Widget signUpTextFormFieldName (width){
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: nameController,
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
            hintText: AppLocalizations.of(context)!.name_hint_text,
            fillColor: Colors.white,
            filled: true,
            errorStyle: const TextStyle(
              fontSize: 0,
            ),
            errorMaxLines: 1,
            suffixIcon: (nameController.text.isEmpty)? const SizedBox() : (nameBool)?
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.solidCircleCheck, color: colors.circleCheckColor, size: 24,),)
                :
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.circleExclamation, color: colors.errorTextFormFieldColor, size: 24,),)
        ),
        style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600 , color: colors.darkBlack)),
        validator: (String?value){
          if(value!.length < 2){
            return "${AppLocalizations.of(context)!.field_less_then}2";
          }
          return null;
        },
        onChanged: (val){
          if(val.length<2){
            setState(() {
              nameBool = false;
            });
          }
          else{
            setState(() {
              nameBool = true;
            });
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(15),
        ],
      ),
    );
  }

  Widget signUpTextFormFieldEmail (width){
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: emailController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
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
            hintText: "email@mail.com",
            fillColor: Colors.white,
            filled: true,
            errorStyle: const TextStyle(
              fontSize: 0,
            ),
            errorMaxLines: 1,
            suffixIcon: (emailController.text.isEmpty)? const SizedBox() : (emailBool)?
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.solidCircleCheck, color: colors.circleCheckColor, size: 24,),)
                :
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.circleExclamation, color: colors.errorTextFormFieldColor, size: 24,),)
        ),
        style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600 , color: colors.darkBlack)),
        validator: (String?value){
          if(value!.length < 2){
            return "${AppLocalizations.of(context)!.field_less_then}2";
          }
          return null;
        },
        onChanged: (val){
          if(val.length<2){
            setState(() {
              emailBool = false;
            });
          }
          else{
            setState(() {
              emailBool = true;
            });
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(99),
        ],
      ),
    );
  }

  Widget signUpTextFormFieldPassword (width){
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: !passwordVisible,
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
          hintStyle: TextStyle(fontSize: 16 , color: colors.weightColor, fontWeight: FontWeight.w500),
          hintText: AppLocalizations.of(context)!.password_hint_text,
          fillColor: Colors.white,
          filled: true,
          errorStyle: const TextStyle(
            fontSize: 0,
          ),
          errorMaxLines: 1,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 13),
            child: IconButton(
              highlightColor: Colors.transparent,
              icon: FaIcon(
                passwordVisible
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: const Color.fromRGBO(137, 138, 141, 1),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
        ),
        style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600 , color: colors.darkBlack)),
        validator: (String?value){
          if(value!.isEmpty || value.length<8){
            return "${AppLocalizations.of(context)!.field_less_then}8";
          }
          return null;
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(16),
        ],
      ),
    );
  }

  Widget uploadImagesContainer(double width, double height) {
    return GestureDetector(
      onTap: () {
        _pickImages();
      },
      child: imageFile != null
          ? Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(
              File(imageFile!.path),
              width: width * 0.95,
              height: height * 0.4,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  imageFile = null;
                  userChooseImage = null;
                });
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withValues(alpha: 0.8),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      )
          : Container(
        width: width * 0.95,
        height: height * 0.4,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(250, 250, 250, 1),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: const Color.fromRGBO(221, 221, 221, 1),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.cameraRetro,
                color: Color.fromRGBO(77, 170, 232, 1),
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.add_image_string,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                )),
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.max_capacity_image_string,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(textStyle:  const TextStyle(
                  color: Color.fromRGBO(154, 154, 154, 1),
                  fontSize: 12,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonCreateAccount(width){
    return SizedBox(
        width: width,
        child: ElevatedButton(
            onPressed: () async{
              if(formSignUp.currentState!.validate() && isChecked== true){
                signUp(emailController.text, passwordController.text, nameController.text);
              }
              else{
                if(isChecked == false){
                  setState(() {
                    stateCheck = false;
                  });
                }
              }
            },
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                backgroundColor: (nameController.text.isNotEmpty  && emailController.text.isNotEmpty && passwordController.text.isNotEmpty && isChecked== true)?
                WidgetStateProperty.all<Color>(colors.mainColor)
                    :
                WidgetStateProperty.all<Color>(colors.mainColor.withOpacity(0.3))
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

  Widget checkBox(){
    if(stateCheck == true){
      return GestureDetector(
        onTap: (){
          if(isChecked==true){
            setState(() {
              isChecked = false;
              stateCheck = false;
            });
          }
          else{
            setState(() {
              isChecked = true;
              stateCheck = true;
            });
          }
        },
        child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
                border: Border.all(
                    color: (isChecked)? colors.mainColor : Colors.black,
                    width: 2
                ),
                borderRadius: BorderRadius.circular(5)
            ),
            child: Align(
              alignment: Alignment.center,
              child: (isChecked)?
              FaIcon(FontAwesomeIcons.check, color: colors.mainColor, size: 18,)
                  :
              const SizedBox(),
            )
        ),
      );
    }
    else{
      return GestureDetector(
        onTap: (){
          if(isChecked==true){
            setState(() {
              isChecked = false;
              stateCheck = false;
            });
          }
          else{
            setState(() {
              isChecked = true;
              stateCheck = true;
            });
          }
        },
        child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
                border: Border.all(
                    color: (isChecked)? colors.mainColor : colors.errorTextFormFieldColor,
                    width: 2
                ),
                borderRadius: BorderRadius.circular(5)
            ),
            child: Align(
              alignment: Alignment.center,
              child: (isChecked)?
              FaIcon(FontAwesomeIcons.check, color: colors.mainColor, size: 18,)
                  :
              const SizedBox(),
            )
        ),
      );
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File userSelectedFile = File(pickedFile.path);
      if (userSelectedFile.lengthSync() <= 12 * 1024 * 1024) {
        setState(() {
          imageFile = XFile(pickedFile.path);
          userChooseImage = FileImage(userSelectedFile);
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.not_choosen_image,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 12.0,
      );
    }
  }

  Future<void> signUp(String email , String password, String fullName) async{

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
    double mainSizedBoxHeightUserNotLogged = height - statusBarHeight;

    return PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: width,
            height: height,
            color: colors.scaffoldColor,
            child: Form(
                key: formSignUp,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                SizedBox(height: statusBarHeight+20,),
                                SizedBox(
                                    width: width,
                                    child: Text(
                                        AppLocalizations.of(context)!.sign_up_text, textAlign: TextAlign.start,
                                        style: GoogleFonts.roboto(textStyle: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.01,
                                          color: colors.darkBlack,
                                        )))
                                ),
                                const SizedBox(height: 12),
                                signUpTextFormFieldName(width),
                                const SizedBox(height: 12),
                                signUpTextFormFieldEmail(width),
                                const SizedBox(height: 12),
                                signUpTextFormFieldPassword(width),
                                const SizedBox(height: 40),
                                uploadImagesContainer(width, mainSizedBoxHeightUserNotLogged),
                                const SizedBox(height: 30),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                                      builder: (BuildContext context) => const LoginPage(),
                                    ));
                                  },
                                  child: SizedBox(
                                      width: width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 6),
                                        child: Text(
                                            AppLocalizations.of(context)!.login_text, textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(textStyle: TextStyle(
                                                fontSize: 18, color: colors.mainColor, fontWeight: FontWeight.w500
                                            ))),
                                      )
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    checkBox(),
                                    const SizedBox(width: 12,),
                                    Expanded(child: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                          text: AppLocalizations.of(context)!.policy_text_1,
                                          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16 ,
                                              color: colors.pureDarkColor,
                                              fontWeight: FontWeight.w500
                                          )),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:  AppLocalizations.of(context)!.policy_text_2,
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    Navigator.of(context).push(CupertinoPageRoute(
                                                      builder: (BuildContext context) => const PolicyScreen(),
                                                    ));
                                                  },
                                                style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16,
                                                    color: colors.mainColor,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration.underline
                                                ))
                                            ),
                                            TextSpan(
                                                text:  AppLocalizations.of(context)!.policy_text_3,
                                                style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16,
                                                    color: colors.pureDarkColor,
                                                    fontWeight: FontWeight.w500
                                                ))
                                            ),
                                            TextSpan(
                                                text:  AppLocalizations.of(context)!.policy_text_4,
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    Navigator.of(context).push(CupertinoPageRoute(
                                                      builder: (BuildContext context) => const PrivacyScreen(),
                                                    ));
                                                  },
                                                style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16,
                                                    color: colors.mainColor,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration.underline
                                                ))
                                            ),
                                          ]
                                      ),
                                    ),)
                                  ],
                                ),
                                const SizedBox(height: 30,),
                                buttonCreateAccount(width),
                                const SizedBox(height: 20,),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}