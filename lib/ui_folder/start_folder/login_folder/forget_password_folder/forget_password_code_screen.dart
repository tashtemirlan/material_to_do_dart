import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;

import '../../../../data_class_folder/login_sign_up_folder/forget_password_generate_code_data_class.dart';
import '../login_screen_boarding.dart';
import 'forget_password_new_password_screen.dart';


class ForgetPasswordCodeScreen extends StatefulWidget{
  final String userEmailForgetPassword ;
  const ForgetPasswordCodeScreen({super.key, required this.userEmailForgetPassword});

  @override
  ForgetPasswordCodeScreenState createState ()=> ForgetPasswordCodeScreenState();
}
class ForgetPasswordCodeScreenState extends State<ForgetPasswordCodeScreen>{


  String newCodeData = "";
  TextEditingController codeController = TextEditingController();

  //key for form field
  final formCodeSubmit = GlobalKey<FormState>();

  //bool to get if code is validated =>
  bool codeValidated = false;
  bool dataSet = false;
  bool newCodeClickable = true;

  //set logic =>
  Timer? _timer;
  int _seconds = 0; // Initial value in seconds
  Color timerClickable = colors.mainColor;

  String code = "";

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
          newCodeData = _formatTime(_seconds);
        } else {
          _timer?.cancel();
          newCodeClickable = true;
          timerClickable = colors.mainColor;
          newCodeData = AppLocalizations.of(context)!.get_new_code;
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget codeTextEdit(double width){
    return Container(
      width: width*0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(alignment: Alignment.centerLeft,
          child:TextFormField(controller: codeController, keyboardType: TextInputType.number,
            decoration:  InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: (codeValidated)?
                      const Color.fromRGBO(76, 197, 19, 0.6) :
                      const Color.fromRGBO(244, 244, 244, 0.93)
                  ),
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
              contentPadding: const EdgeInsets.only(left: 10),
              hintStyle: const TextStyle(fontSize: 16 , color: Color.fromRGBO(154, 154, 154, 1) , fontWeight: FontWeight.w400),
              hintText: AppLocalizations.of(context)!.code_accept_string,
              filled: true,
              fillColor: Colors.white,
              errorStyle:const TextStyle(
                  color: Color.fromRGBO(255, 0, 0, 0.5),
                  fontSize: 12,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w300
              ),
            ),
            style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.black),
            onChanged: (valueChanged){
              if(formCodeSubmit.currentState!.validate()){
                setState(() {
                  codeValidated = true;
                });
              }
              else{
                codeValidated = false;
              }
            },
            validator: (String?value){
              if(value == null || value.length<7){
                return "${AppLocalizations.of(context)!.field_less_then}7";
              }
              return null;},
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
              TextInputFormatter.withFunction((oldValue, newValue) {
                final text = newValue.text;
                if (text.length > 3) {
                  return TextEditingValue(
                    text: '${text.substring(0, 3)} ${text.substring(3)}',
                    selection: newValue.selection.copyWith(
                      baseOffset: newValue.selection.baseOffset + 1,
                      extentOffset: newValue.selection.extentOffset + 1,
                    ),
                  );
                }
                return newValue;
              }),
            ],
          )
      ),
    );
  }

  Future<void> getCode() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    //set Dio response =>
    try{
      final response = await dio.post(
          endpoints.forgetPasswordGenerateCodePostEndpoint ,
          data: {
            "email" : widget.userEmailForgetPassword,
          }
      );
      if(response.statusCode == 200){
        final result = forgetPasswordGenerateCodeDataClassFromJson(response.toString());
        setState(() {
          code = result.code!;
        });
      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
          print(toParseData);
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.user_with_this_email_not_exist_string,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
            backgroundColor: Colors.white, // Background color of the toast
            textColor: Colors.black,
          );
        }
      }
    }
  }

  Future<void> getNewCode() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    //set Dio response =>
    try{
      final response = await dio.post(
          endpoints.forgetPasswordGenerateCodePostEndpoint ,
          data: {
            "email" : widget.userEmailForgetPassword,
          }
      );
      if(response.statusCode == 200){
        final result = forgetPasswordGenerateCodeDataClassFromJson(response.toString());
        setState(() {
          code = result.code!;
          _seconds = 120;
          newCodeClickable = false;
          timerClickable = const Color.fromRGBO(40, 40, 40, 1);
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.new_code_send,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
            backgroundColor: Colors.white, // Background color of the toast
            textColor: Colors.black,
          );
          _startTimer();
        });
      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
          print(toParseData);
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.user_with_this_email_not_exist_string,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
            backgroundColor: Colors.white, // Background color of the toast
            textColor: Colors.black,
          );
        }
      }
    }
  }

  Future<void> initVoid() async{
    await getCode();
    setState(() {
      dataSet = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initVoid();
  }

  @override
  void dispose() {
    _timer?.cancel();
    codeController.dispose();
    super.dispose();
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
                child: (dataSet)?
                Form(
                    key: formCodeSubmit,
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
                                        AppLocalizations.of(context)!.enter_code_string, textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 32, color: Colors.black, fontWeight: FontWeight.w600
                                        ))
                                ),
                                const SizedBox(height: 20,),
                                codeTextEdit(width),
                                const SizedBox(height: 10,),
                                SizedBox(width: width*0.85,
                                    height: height*0.07 ,
                                    child: ElevatedButton(
                                        onPressed: ()async{
                                          if(formCodeSubmit.currentState!.validate()){
                                            setState((){
                                              codeValidated = true;
                                            });
                                            if(codeController.text.replaceAll(" ", "") == code){
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                  builder: (BuildContext context) => ForgetPasswordNewPasswordScreen(userEmail: widget.userEmailForgetPassword)));
                                            }
                                            else{
                                              Fluttertoast.showToast(
                                                msg: AppLocalizations.of(context)!.code_not_right,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM, // Position of the toast on the screen
                                                backgroundColor: Colors.white, // Background color of the toast
                                                textColor: Colors.black,
                                              );
                                            }
                                          }
                                          else{
                                            codeValidated = false;
                                          }
                                        },
                                        style: ButtonStyle(
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
                                                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500 , letterSpacing: 0.2
                                            ))
                                    )
                                ),
                                const SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: () async{
                                    if(newCodeClickable){
                                      setState(() {
                                        dataSet = false;
                                      });
                                      await getNewCode();
                                      setState(() {
                                        dataSet = true;
                                      });
                                    }
                                  },
                                  child: Text(
                                      (newCodeClickable)? AppLocalizations.of(context)!.get_new_code : newCodeData,
                                      style: TextStyle(
                                          fontSize: 16, color: timerClickable, fontWeight: FontWeight.w500 , letterSpacing: 0.2
                                      )),
                                ),
                                const SizedBox(height: 20,),
                                SizedBox(
                                  width: width * 0.85,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text(
                                        "${AppLocalizations.of(context)!.code_string} : $code",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(textStyle: TextStyle(
                                            color: colors.mainColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                            letterSpacing: 0.01,
                                            decoration: TextDecoration.none
                                        ))
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                )
                    :
                Center(
                  child: CupertinoActivityIndicator(
                    color: colors.mainColor,
                    radius: 16,
                  ),
                ),
              ),
            )
        )
    );
  }
}