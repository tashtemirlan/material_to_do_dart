import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/bottom_navigation_screen.dart';
import 'package:material_to_do/ui_folder/start_folder/welcome/sign_up_screen_boarding.dart';


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

  Widget loginTextFormFieldPhone (width){
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: emailController,
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
          if(value!.length < 5){
            return "";
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
            return "";
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
                print("login");
                Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  builder: (BuildContext context) => const BottomNavBar(),
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
                WidgetStateProperty.all<Color>(colors.mainColor.withOpacity(0.3))
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

  Future<void> login(String phone, String password) async{

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
                                  loginTextFormFieldPhone(width),
                                  const SizedBox(height: 12),
                                  loginTextFormFieldPassword(width),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: (){
                                      print("Forget password");
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