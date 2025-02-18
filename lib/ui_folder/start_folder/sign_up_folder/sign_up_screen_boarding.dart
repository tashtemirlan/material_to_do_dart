import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:material_to_do/ui_folder/start_folder/login_folder/login_screen_boarding.dart';
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

  Widget placeImage(width){
    //TODO : add widget where we will place image for user. If not image added then we will set default
    return GestureDetector(
      onTap: (){},
      child: Container(
        width: width,
        height: 125,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(30)
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
              AppLocalizations.of(context)!.place_image_text, textAlign: TextAlign.center,
              style: GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: 18, color: colors.mainColor, fontWeight: FontWeight.w500
              ))),
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
                print("Sign up");
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


  Future<void> signUp(String phone , String email , String password, String fullName) async{

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
                child: SizedBox(
                    width: width,
                    height: mainSizedBoxHeightUserNotLogged,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //first elem is x to sign out =>
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
                                  const SizedBox(height: 40),
                                  placeImage(width),
                                  const SizedBox(height: 12),
                                  signUpTextFormFieldName(width),
                                  const SizedBox(height: 12),
                                  signUpTextFormFieldEmail(width),
                                  const SizedBox(height: 12),
                                  signUpTextFormFieldPassword(width),
                                  const SizedBox(height: 16),
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
                                  )
                                ],
                              ),
                            )
                        ),
                        //second elem is additional placeholders
                        Spacer(),
                        SizedBox(
                            width: width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
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
                                                      print("Policy1");
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
                                                      print("policy2");
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
                                  const SizedBox(height: 40,),
                                  buttonCreateAccount(width)
                                ],
                              ),
                            )
                        ),
                        Spacer()
                      ],
                    )
                )
            ),
          ),
        )
    );
  }
}