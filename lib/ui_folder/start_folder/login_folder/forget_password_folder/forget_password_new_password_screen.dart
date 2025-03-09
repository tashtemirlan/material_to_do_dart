import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;

import '../login_screen_boarding.dart';
import 'forget_password_password_reseted.dart';


class ForgetPasswordNewPasswordScreen extends StatefulWidget{
  final String userEmail;
  const ForgetPasswordNewPasswordScreen({super.key, required this.userEmail});

  @override
  ForgetPasswordNewPasswordScreenState createState ()=> ForgetPasswordNewPasswordScreenState();
}
class ForgetPasswordNewPasswordScreenState extends State<ForgetPasswordNewPasswordScreen>{

  //bool to show password ->
  bool passwordVisibleEditor1 = false;
  bool passwordVisibleEditor2 = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRetryController = TextEditingController();

  //key for form field
  final formResetPasswordCreation = GlobalKey<FormState>();


  Widget newTextFormFieldPasswordValidNewFirst (width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: passwordController,
          keyboardType: TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: !passwordVisibleEditor1,
          decoration: InputDecoration(
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
            hintStyle: const TextStyle(fontSize: 16 , color: Color.fromRGBO(154, 154, 154, 1), fontWeight: FontWeight.w400),
            hintText: AppLocalizations.of(context)!.enter_password_string,
            contentPadding: const EdgeInsets.symmetric(vertical: 15 , horizontal: 10),
            suffixIcon: IconButton(
              icon: FaIcon(
                // Based on passwordVisible state choose the icon
                passwordVisibleEditor1
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: const Color.fromRGBO(137, 138, 141, 1),
                size: 16,
              ),
              onPressed: () {
                setState(() {
                  passwordVisibleEditor1 = !passwordVisibleEditor1;
                });
              },
            ),
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 2,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty || value.length<8){
              return "${AppLocalizations.of(context)!.field_less_then}8";
            }
            return null;
          }
      ),
    );
  }

  Widget newTextFormFieldPasswordValidNewSecond (width){
    return SizedBox(
      width: width*0.85,
      child: TextFormField(
          controller: passwordRetryController,
          keyboardType: TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: !passwordVisibleEditor2,
          decoration: InputDecoration(
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
            hintStyle: const TextStyle(fontSize: 16 , color: Color.fromRGBO(154, 154, 154, 1), fontWeight: FontWeight.w400),
            hintText: AppLocalizations.of(context)!.enter_password_string,
            contentPadding: const EdgeInsets.symmetric(vertical: 15 , horizontal: 10),
            suffixIcon: IconButton(
              icon: FaIcon(
                // Based on passwordVisible state choose the icon
                passwordVisibleEditor2
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: const Color.fromRGBO(137, 138, 141, 1),
                size: 16,
              ),
              onPressed: () {
                setState(() {
                  passwordVisibleEditor2 = !passwordVisibleEditor2;
                });
              },
            ),
            errorStyle:const TextStyle(
              color: Color.fromRGBO(255, 0, 0, 0.5),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 2,
          ),
          style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
          validator: (String?value){
            if(value!.isEmpty || value.length<8){
              return "${AppLocalizations.of(context)!.field_less_then}8";
            }
            return null;
          }
      ),
    );
  }

  Future<void> changePassword(String password) async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    //set Dio response =>
    try{
      final response = await dio.post(
          endpoints.forgetPasswordChangePasswordPostEndpoint,
          data: {
            "email" : widget.userEmail,
            "password" : password
          }
      );
      if(response.statusCode == 200){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const ForgetPasswordPasswordReseted()));
      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
          print(toParseData);
          Fluttertoast.showToast(
            msg: toParseData,
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
    passwordController.dispose();
    passwordRetryController.dispose();
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

    return PopScope(
      canPop: false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body:Padding(padding: EdgeInsets.only(top: statusBarHeight),
            child: Container(
              width: width,
              height: height,
              color: const Color.fromRGBO(250, 250, 250, 1),
              child: Form(
                key: formResetPasswordCreation,
                child: SizedBox(
                  width: width*0.95,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                        height: height * 0.8,
                        child: Column(
                          children: [
                            SizedBox(
                              width: width*0.85,
                              height: 40,
                              child: Text(
                                  AppLocalizations.of(context)!.create_password_string, textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 32, color: Colors.black, fontWeight: FontWeight.w600
                                  )),
                            ),
                            const SizedBox(height: 30,),
                            newTextFormFieldPasswordValidNewFirst(width),
                            const SizedBox(height: 10,),
                            newTextFormFieldPasswordValidNewSecond(width),
                            const SizedBox(height: 10,),
                            Container(
                                width: width*0.8,
                                height: height*0.07,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: ElevatedButton(
                                      onPressed: () async{
                                        if(passwordController.text==passwordRetryController.text){
                                          if(formResetPasswordCreation.currentState!.validate()){
                                            await changePassword(passwordController.text);
                                          }
                                        }
                                        else{
                                          Fluttertoast.showToast(
                                            msg: AppLocalizations.of(context)!.passwords_not_match,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                          );
                                        }
                                      },
                                      style: ButtonStyle(
                                          alignment: Alignment.center,
                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          backgroundColor: WidgetStateProperty.all<Color>(colors.mainColor)
                                      ),
                                      child: Text(
                                          AppLocalizations.of(context)!.continue_string,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 18, color: Colors.white, letterSpacing: 0.2 , fontWeight: FontWeight.w500
                                          ))
                                  ),
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
      ),
    );
  }
}