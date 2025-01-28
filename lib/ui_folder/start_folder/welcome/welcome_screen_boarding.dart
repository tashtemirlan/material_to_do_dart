import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/ui_folder/start_folder/welcome/login_screen_boarding.dart';


class WelcomeScreenBoarding extends StatefulWidget{
  const WelcomeScreenBoarding({super.key});

  @override
  WelcomeScreenBoardingState createState ()=> WelcomeScreenBoardingState();

}

class WelcomeScreenBoardingState extends State<WelcomeScreenBoarding>{

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
        resizeToAvoidBottomInset: false,
        body: Container(
          width: width,
          height: height,
          color: colors.scaffoldColor,
          child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: statusBarHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/board_welcome.png",
                      width: width,
                      height: height*0.5,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                      AppLocalizations.of(context)!.welcome_board_message1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32, color: colors.black1, fontWeight: FontWeight.w600,
                      )
                  ),
                  const SizedBox(height: 10,),
                  Text(
                      AppLocalizations.of(context)!.welcome_board_message2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, color: colors.black2, fontWeight: FontWeight.w600,
                      )
                  ),
                  const SizedBox(height: 10,),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                        builder: (BuildContext context) => const LoginPage(),
                      ));
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          color: colors.mainColor,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Spacer(),
                            Text(
                                AppLocalizations.of(context)!.welcome_board_button_message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600,
                                )
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              "assets/icons/right_arrow.svg",
                              height: 32,
                              width: 32,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 15,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer()
                ],
              ),
          )
        )
    );
  }
}