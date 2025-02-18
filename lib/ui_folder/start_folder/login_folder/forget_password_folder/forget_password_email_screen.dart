import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/global_folder/colors.dart' as colors;

import '../login_screen_boarding.dart';
import 'forget_password_code_screen.dart';


class ForgetPasswordEmailScreen extends StatefulWidget{
  const ForgetPasswordEmailScreen({super.key});

  @override
  ForgetPasswordEmailScreenState createState ()=> ForgetPasswordEmailScreenState();
}
class ForgetPasswordEmailScreenState extends State<ForgetPasswordEmailScreen>{

  TextEditingController emailController = TextEditingController();

  //bool to show if TextFormField have any value or not =>
  bool textFormFieldHaveValue = false;

  //key for form field
  final formKeyForgetPassword = GlobalKey<FormState>();


  Widget textFormFieldEmail(width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(221, 221, 221, 1)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.mainColor),
                borderRadius: BorderRadius.circular(8)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(255, 0, 0, 0.5)),
                borderRadius: BorderRadius.circular(8)
            ),
            contentPadding: const EdgeInsets.only(left: 10, right: 20),
            hintStyle: const TextStyle(fontSize: 16 , color: Color.fromRGBO(154, 154, 154, 1) , fontWeight: FontWeight.w400),
            hintText: AppLocalizations.of(context)!.email_address_string,
            fillColor: Colors.white,
            filled: true,
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 1,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          onChanged: (valueChanged){
            if(valueChanged.isNotEmpty){
              setState(() {
                textFormFieldHaveValue = true;
              });
            }
            else{
              setState(() {
                textFormFieldHaveValue = false;
              });
            }
          },
          validator: (String?value){
            if(value!.isEmpty){
              return AppLocalizations.of(context)!.empty_field_string;
            }
            return null;
          }
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
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
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    double mainSizedBoxHeightUserNotLogged = height - bottomNavBarHeight - statusBarHeight;


    return PopScope(
        canPop: false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body:Padding(padding: EdgeInsets.only(top: statusBarHeight),
              child: Container(
                width: width,
                height: mainSizedBoxHeightUserNotLogged,
                color: const Color.fromRGBO(250, 250, 250, 1),
                child: Form(
                  key: formKeyForgetPassword,
                  child: SizedBox(
                    width: width*0.95,
                    height: mainSizedBoxHeightUserNotLogged,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //first elem is x to sign out =>
                        SizedBox(
                          width: width*0.95,
                          height: 30,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) => const LoginPage()));
                              },
                              icon: const Icon(Icons.close, color: Colors.black, size: 30,),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: mainSizedBoxHeightUserNotLogged * 0.8,
                          child: Column(
                            children: [
                              SizedBox(
                                  width: width*0.85,
                                  height: 40,
                                  child: Text(
                                      AppLocalizations.of(context)!.forget_password_string, textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 32, color: Colors.black, fontWeight: FontWeight.w600
                                      ))
                              ),
                              const SizedBox(height: 10,),
                              SizedBox(
                                  width: width*0.85,
                                  height: 80,
                                  child: Text(
                                      AppLocalizations.of(context)!.send_please_email_string, textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 14, color: Color.fromRGBO(40, 40, 40, 1),
                                          fontWeight: FontWeight.w300 , letterSpacing: 0.2
                                      ))
                              ),
                              const SizedBox(height: 10,),
                              textFormFieldEmail(width),
                              const SizedBox(height: 10,),
                              SizedBox(width: width*0.85,
                                  height: mainSizedBoxHeightUserNotLogged*0.07  ,
                                  child: ElevatedButton(
                                      onPressed: ()async{
                                        if (formKeyForgetPassword.currentState!.validate()) {
                                          print("Form email is valid");
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                                              builder: (BuildContext context) => ForgetPasswordCodeScreen(userEmailForgetPassword: emailController.text,)));
                                        }
                                      },
                                      style: ButtonStyle(
                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          backgroundColor: (textFormFieldHaveValue)?
                                          WidgetStateProperty.all<Color>(
                                               colors.mainColor
                                          ) :
                                          WidgetStateProperty.all<Color>(
                                              const Color.fromRGBO(221, 221, 221, 1)
                                          )
                                      ),
                                      child: Text(
                                          AppLocalizations.of(context)!.send_string,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500 , letterSpacing: 0.2
                                          ))
                                  )
                              ),
                            ],
                          ),
                        )
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