import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/bottom_navigation_screen.dart';
import 'package:material_to_do/ui_folder/start_folder/login_folder/forget_password_folder/forget_password_email_screen.dart';
import 'package:material_to_do/ui_folder/start_folder/sign_up_folder/sign_up_screen_boarding.dart';

import '../../../data_class_folder/login_sign_up_folder/login_token_data_class.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  LoginPageState createState ()=> LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  //bool to show password ->
  bool emailBool = false;
  bool passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //key for form field
  final formLogin = GlobalKey<FormState>();

  Widget loginTextFormFieldEmail (width){
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
            errorStyle: TextStyle(
                fontSize: 12,
                color: colors.errorTextFormFieldColor
            ),
            errorMaxLines: 1,
            suffixIcon: (emailController.text.isEmpty)? const SizedBox() : (emailBool)?
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.solidCircleCheck, color: colors.circleCheckColor, size: 24,),)
                :
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.circleExclamation, color: colors.errorTextFormFieldColor, size: 24,),)

        ),
        style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600 , color: colors.darkBlack)),
        validator: (String?value){
          if(value!.length < 5){
            return "${AppLocalizations.of(context)!.field_less_then}5";
          }
          return null;
        },
        onChanged: (val){
          if(val.length<5){
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
      ),
    );
  }

  Widget loginTextFormFieldPassword (width){
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
          errorStyle: TextStyle(
              fontSize: 12,
              color: colors.errorTextFormFieldColor
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
                size: 16,
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
        onChanged: (value){
          setState(() {

          });
        },
        validator: (String? value){
          if(value!.length <8){
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

  Widget buttonLogin(width){
    return SizedBox(
        width: width,
        child: ElevatedButton(
            onPressed: () async{
              if(formLogin.currentState!.validate()){
                //await login(emailController.text, passwordController.text);
                Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  builder: (BuildContext context) => const BottomNavBar(position: 0,),
                ));
              }
            },
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                backgroundColor: (emailController.text.length>=5 && passwordController.text.length>=8)?
                WidgetStateProperty.all<Color>(colors.mainColor)
                    :
                WidgetStateProperty.all<Color>(colors.palete8)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                  AppLocalizations.of(context)!.login_text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(textStyle: const TextStyle(
                      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600 , letterSpacing: 0.01
                  ))),
            )
        )
    );
  }

  Future<void> login(String email, String password) async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    //set Dio response =>
    try{
      final response = await dio.post(
          endpoints.loginPostEndpoint ,
          data: {
            "email" : email,
            "password" : password
          }
      );
      if(response.statusCode == 200){
        var box = await Hive.openBox("auth");
        final result = loginTokenDataClassFromJson(response.toString());
        box.put("token", result.token);
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) => const BottomNavBar(position: 0,),
        ));
      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
          print(toParseData);
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.login_error_string,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
            backgroundColor: Colors.white, // Background color of the toast
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
                key: formLogin,
                child: SizedBox(
                    width: width,
                    height: mainSizedBoxHeightUserNotLogged,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //first elem is x to sign out =>
                        SizedBox(
                            width: width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  SizedBox(height: statusBarHeight +20,),
                                  SizedBox(
                                      width: width,
                                      child: Text(
                                          AppLocalizations.of(context)!.login_text, textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.01,
                                            color: colors.darkBlack,
                                          ))
                                  ),
                                  const SizedBox(height: 40),
                                  loginTextFormFieldEmail(width),
                                  const SizedBox(height: 12),
                                  loginTextFormFieldPassword(width),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (BuildContext context) => const ForgetPasswordEmailScreen()));
                                    },
                                    child: SizedBox(
                                        width: width,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 6),
                                          child: Text(
                                              AppLocalizations.of(context)!.forget_password_question_text, textAlign: TextAlign.end,
                                              style: GoogleFonts.roboto(textStyle: TextStyle(
                                                  fontSize: 16, color: colors.mainColor, fontWeight: FontWeight.w500
                                              ))),
                                        )
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                                        builder: (BuildContext context) => const SignUpPage(),
                                      ));
                                    },
                                    child: SizedBox(
                                        width: width,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 6),
                                          child: Text(
                                              AppLocalizations.of(context)!.sign_up_text, textAlign: TextAlign.center,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: width,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: buttonLogin(width)
                                )
                            ),
                            const SizedBox(height: 50,)
                          ],
                        )
                      ],
                    )
                )
            ),
          ),
        )
    );
  }
}