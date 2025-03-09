import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;
import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/ui_folder/bottom_navigation_folder/bottom_navigation_screen.dart';
import 'package:material_to_do/ui_folder/start_folder/login_folder/login_screen_boarding.dart';
import 'package:material_to_do/ui_folder/start_folder/welcome_screen_boarding.dart';


class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  SplashScreenState createState ()=> SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>{

  Future<bool> checkWelcomeCompleted() async{
    var box = await Hive.openBox("welcome_board");
    bool welcomeToken = box.containsKey("welcome_key");
    if(welcomeToken){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> checkTokensAuth() async{
    var box = await Hive.openBox("auth");
    bool accessTokenBoolean = box.containsKey("token");
    if(accessTokenBoolean == true){
      final accessToken = box.get("token");
      final isTokensValid = await checkValidUserToken(accessToken);
      if(isTokensValid){
        //if tokens are valid then we navigate user to screen with his pin number or face id
        Future.delayed(Duration(milliseconds: 1500), ()=>Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) => const BottomNavBar(position: 0),
        )));
      }
      else{
        //if tokens are not valid then we must navigate to login screen
        Future.delayed(Duration(milliseconds: 1500), ()=>Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        )));
      }
    }
    else{
      //if here is no any tokens then we must navigate user to login screen
      Future.delayed(Duration(milliseconds: 1500), ()=>Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      )));
    }
  }

  Future<bool> checkValidUserToken(String accessToken) async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    //set Dio response =>
    dio.options.headers['Authorization'] = "Bearer $accessToken";
    try{
      final response = await dio.post(endpoints.validateTokenPostEndpoint);
      if(response.statusCode == 200){
        return true;
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
    return false;
  }

  Future<void> checkHiveTokens() async{
    bool welcomeCompleted = await checkWelcomeCompleted();
    if(welcomeCompleted == false){
      //if user not completed welcome then we must navigate it to welcome screen :
      //todo : navigate to welcome screen =>
      Future.delayed(Duration(milliseconds: 1500), ()=>Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (BuildContext context) => const WelcomeScreenBoarding(),
      )));
    }
    else{
      // if user completed welcome then we should check if he have auth tokens valid:
      await checkTokensAuth();
    }
  }

  Future<void> logoMainMethod() async{
    //todo: ensure to initialize all neccessary voids and methods =>
    await Hive.initFlutter();
    // we should firstly check if user have a stored hive token of his authentication
    await checkHiveTokens();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    logoMainMethod();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: width,
          height: height,
          color: colors.scaffoldColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: height*0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo_background.png",
                        width: width*0.5,
                        height: width*0.5,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                      const SizedBox(height: 10,),
                      Text(
                          "ToDo" ,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48, color: Colors.black, fontWeight: FontWeight.w600,
                          )
                      )
                    ],
                  )
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/teit.png",
                            width: width*0.25,
                            height: height*0.25,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                          const SizedBox(width: 10,),
                          Text(
                              "${AppLocalizations.of(context)!.developed} Teit Corp." ,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18, color: colors.teitLogoColor, fontWeight: FontWeight.w600,
                              )
                          )
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        )
    );
  }
}